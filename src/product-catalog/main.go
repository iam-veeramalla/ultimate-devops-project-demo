package main

import (
	"context"
	"fmt"
	"log"
	"net"
	"os"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"go.opentelemetry.io/contrib/instrumentation/google.golang.org/grpc/otelgrpc"
)

func main() {
	// Example startup logging
	fmt.Println("Starting Product Catalog Service...")

	// Example environment variable usage
	serviceAddr := os.Getenv("PRODUCT_CATALOG_SERVICE_ADDR")
	if serviceAddr == "" {
		log.Fatal("PRODUCT_CATALOG_SERVICE_ADDR not set")
	}

	// Just for example — not required unless you’re making an outgoing gRPC connection
	ctx := context.Background()
	conn, err := createClient(ctx, serviceAddr)
	if err != nil {
		log.Fatalf("failed to connect to %s: %v", serviceAddr, err)
	}
	defer conn.Close()

	// Start a mock gRPC server (for demonstration)
	listener, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	grpcServer := grpc.NewServer()
	fmt.Println("Product Catalog gRPC server started on port :50051")
	if err := grpcServer.Serve(listener); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}

//nolint:unused // This helper function may be used for testing or external client setup
func {createClient(ctx context.Context, svcAddr string) (*grpc.ClientConn, error) {
	// Use grpc.NewClient (grpc.DialContext is deprecated)
	return grpc.NewClient(svcAddr,
		grpc.WithTransportCredentials(insecure.NewCredentials()),
		grpc.WithStatsHandler(otelgrpc.NewClientHandler()),
	)
}

// Example function showing the fmt.Sprintf fix
func logFeatureFlag() {
	// Before: msg := fmt.Sprintf("Error: Product Catalog Fail Feature Flag Enabled")
	msg := "Error: Product Catalog Fail Feature Flag Enabled"
	log.Println(msg)
}

}

