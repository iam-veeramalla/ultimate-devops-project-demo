# syntax=docker/dockerfile:1

################################################################################
# Build stage
################################################################################

ARG RUST_VERSION=1.85.0
ARG APP_NAME=shipping

FROM rust:${RUST_VERSION}-slim-bullseye AS build

ARG APP_NAME

WORKDIR /app

RUN --mount=type=bind,source=src/shipping/src,target=src \
    --mount=type=bind,source=src/shipping/build.rs,target=build.rs \
    --mount=type=bind,source=src/shipping/Cargo.toml,target=Cargo.toml \
    --mount=type=bind,source=src/shipping/Cargo.lock,target=Cargo.lock \
    --mount=type=bind,source=pb,target=proto \
    --mount=type=cache,target=/app/target/ \
    --mount=type=cache,target=/usr/local/cargo/registry/ \
    <<EOF
set -e

cargo build --locked --release --features dockerproto

cp ./target/release/\$APP_NAME /bin/server
EOF

################################################################################
# Runtime stage
################################################################################

FROM debian:bullseye-slim AS final

ARG UID=10001

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

USER appuser

COPY --from=build /bin/server /bin/server

EXPOSE 7077

CMD ["/bin/server"]
