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

# 🆙 Apply all migrations
migrate-apply:
	@CGO_ENABLED=0 ATLAS_DEV_URL="$(DB_URL)" atlas migrate apply --env gorm

# # ⬆️ Run all up migrations
# migrate-up:
# 	@migrate -path $(MIGRATIONS_DIR) -database "$(DB_URL)" up

# # ⬇️ Roll back the last migration
# migrate-down:
# 	@migrate -path $(MIGRATIONS_DIR) -database "$(DB_URL)" down 1

# Run migrations inside Docker container
docker-migrate-diff:
	docker compose exec app atlas migrate diff $(name) --env gorm

docker-migrate-apply:
	docker compose exec app atlas migrate apply --env gorm
