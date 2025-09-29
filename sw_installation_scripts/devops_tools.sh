#!/usr/bin/env bash
# Install Docker, Terraform, and kubectl on Ubuntu
# Safe mode
set -euo pipefail

# ---- Configurable defaults ----
# For kubectl, you can pin the stable series (e.g., v1.34). Change if you need a different minor.
K8S_SERIES="${K8S_SERIES:-v1.34}"

# ---- Helpers ----
log()  { printf "\n\033[1;32m[INFO]\033[0m %s\n" "$*"; }
warn() { printf "\n\033[1;33m[WARN]\033[0m %s\n" "$*"; }
err()  { printf "\n\033[1;31m[ERR ]\033[0m %s\n" "$*" >&2; }

need_root() {
  if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    err "Please run as root: sudo $0"
    exit 1
  fi
}

check_ubuntu() {
  if [[ ! -r /etc/os-release ]]; then
    err "/etc/os-release not found; this script supports Ubuntu only."
    exit 1
  fi
  . /etc/os-release
  if [[ "${ID:-}" != "ubuntu" ]]; then
    err "Detected ID='${ID:-unknown}'. This script supports Ubuntu only."
    exit 1
  fi
  UBUNTU_CODENAME_VAL="${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}"
  if [[ -z "${UBUNTU_CODENAME_VAL}" ]]; then
    err "Could not determine Ubuntu codename."
    exit 1
  fi
}

install_prereqs() {
  log "Installing prerequisites (ca-certificates, curl, gnupg, lsb-release)..."
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -y
  apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https
  install -m 0755 -d /etc/apt/keyrings
}

install_docker() {
  log "Setting up Docker apt repository and installing Docker Engine..."
  # Remove conflicting packages (ok if absent)
  apt-get remove -y docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc || true

  # Add Docker GPG key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  chmod a+r /etc/apt/keyrings/docker.asc

  # Add Docker repo (uses detected architecture + codename)
  ARCH="$(dpkg --print-architecture)"
  . /etc/os-release
  echo \
"deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(${UBUNTU_CODENAME:+echo "$UBUNTU_CODENAME"} || echo "${VERSION_CODENAME}") stable" \
    | tee /etc/apt/sources.list.d/docker.list >/dev/null

  apt-get update -y
  apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  # Enable & start Docker
  if command -v systemctl >/dev/null 2>&1; then
    systemctl enable --now docker
  else
    service docker start || true
  fi

  # Add invoking user to docker group (if any)
  TARGET_USER="${SUDO_USER:-${USER}}"
  if id -u "${TARGET_USER}" >/dev/null 2>&1; then
    usermod -aG docker "${TARGET_USER}" || true
    warn "Added '${TARGET_USER}' to 'docker' group. You must log out and back in (or run 'newgrp docker') to use Docker without sudo."
  fi
}

install_terraform() {
  log "Setting up HashiCorp apt repository and installing Terraform..."
  # Add HashiCorp GPG key
  curl -fsSL https://apt.releases.hashicorp.com/gpg \
    | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  chmod a+r /usr/share/keyrings/hashicorp-archive-keyring.gpg

  # Add repo (uses Ubuntu codename)
  . /etc/os-release
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${UBUNTU_CODENAME_VAL} main" \
    | tee /etc/apt/sources.list.d/hashicorp.list >/dev/null

  apt-get update -y
  apt-get install -y terraform
}

install_kubectl() {
  log "Setting up Kubernetes apt repository (${K8S_SERIES}) and installing kubectl..."
  # Keyring
  curl -fsSL "https://pkgs.k8s.io/core:/stable:/${K8S_SERIES}/deb/Release.key" \
    | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

  # Repo
  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${K8S_SERIES}/deb/ /" \
    | tee /etc/apt/sources.list.d/kubernetes.list >/dev/null
  chmod 644 /etc/apt/sources.list.d/kubernetes.list

  apt-get update -y
  apt-get install -y kubectl
}

print_versions() {
  log "Verifying installations..."
  echo
  docker --version || true
  terraform -version || true
  kubectl version --client --output=yaml || kubectl version --client || true
  echo
  log "All done ✅"
}

main() {
  need_root
  check_ubuntu
  install_prereqs
  install_docker
  install_terraform
  install_kubectl
  print_versions
}

main "$@"

