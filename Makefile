# Load environment variables
include .env
export $(shell sed 's/=.*//' .env)

# Directories and DB connection
MIGRATIONS_DIR=migrations
DB_URL=postgres://$(USER):$(PASSWORD)@$(HOST):$(DB_PORT)/$(DB_NAME)?sslmode=$(SSL_MODE)

# 🏗️ Build the Go binary
build:
	@go build -o bin/go_backend_setup main.go

# 🚀 Run the Go server
run:
	@go run cmd/server/main.go

# 🧱 Create a new empty migration file
migrate-create:
	@migrate create -ext sql -dir $(MIGRATIONS_DIR) -seq $(name)

# ✨ Generate a migration file using Atlas (auto-generates SQL from models)
migrate-diff:
	@CGO_ENABLED=0 ATLAS_DEV_URL="$(DB_URL)" atlas migrate diff $(name) --env gorm

# ⬆️ Run all up migrations
migrate-up:
	@migrate -path $(MIGRATIONS_DIR) -database "$(DB_URL)" up

# ⬇️ Roll back the last migration
migrate-down:
	@migrate -path $(MIGRATIONS_DIR) -database "$(DB_URL)" down 1
