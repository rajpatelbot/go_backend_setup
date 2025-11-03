package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"time"

	"go_backend_setup/config"
	"go_backend_setup/database"

	"github.com/gin-gonic/gin"
)

func main() {
	// Set log format to include date, time with microseconds, and file line number
	log.SetFlags(log.LstdFlags | log.Lmicroseconds | log.Lshortfile)
	log.SetOutput(os.Stdout)

	// Load environment variables from .env file
	config.InitEnv()
	env := config.EnvConfig

	// Define a Gin mode
	if env.GIN_MODE == "release" {
		gin.SetMode(gin.ReleaseMode)
	} else {
		gin.SetMode(gin.DebugMode)
	}

	// Start the server
	srv := StartServer(env)

	// Connect to the database
	db := database.NewDatabase()
	if db != nil {
		log.Println("✅ Successfully connected to the database.")
	}

	// Wait for shutdown signal and gracefully shutdown the server
	WaitForShutdown(srv)

	log.Println("✅ All active connections finished. Resources cleaned up.")
	log.Println("👋 Server exiting.")
}

func StartServer(env *config.Env) *http.Server {
	// Server initialization
	router := gin.Default()

	// Create an http server
	srv := &http.Server{
		Addr:    ":" + env.PORT,
		Handler: router,
	}

	// Graceful server start in a goroutine
	go func() {
		log.Printf("🚀 Server is running at %s", srv.Addr)
		err := srv.ListenAndServe()
		if err != nil && err != http.ErrServerClosed {
			log.Fatalf("Server listen error: %v\n", err)
		}
	}()

	return srv
}

func WaitForShutdown(srv *http.Server) {
	// Wait for interrupt signal to gracefully shutdown the server
	quit := make(chan os.Signal, 1)

	// Catch OS interrupt signals
	signal.Notify(quit, os.Interrupt)

	// Block until a signal is received (e.g. Ctrl+C)
	<-quit

	log.Println("⚠️ Shutdown signal received. Started graceful shutdown...")

	// The context is used to inform the server; it has timeout to finish
	// Gives running requests a deadline to complete within timeout
	const timeout = 5 * time.Second
	ctx, cancel := context.WithTimeout(context.Background(), timeout)
	defer cancel()

	// Attempt graceful server shutdown and stop accepting new requests
	err := srv.Shutdown(ctx)
	if err != nil {
		log.Fatalf("Server forced to shutdown after: %v %v", timeout, err)
	}
}
