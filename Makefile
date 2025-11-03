# Load environment variables
include .env
export $(shell sed 's/=.*//' .env)

# Directories and DB connection
MIGRATIONS_DIR=migrations
DB_URL=postgres://$(DB_USER):$(DB_PASSWORD)@$(HOST):$(DB_PORT)/$(DB_NAME)?sslmode=$(SSL_MODE)

# 🏗️ Build the Go binary
build:
	@go build -o bin/go_backend_setup main.go

# 🚀 Run the Go server
run:
	@go run main.go

# 🧱 Create a new migration file (usage: make migrate-create name=create_users_table)
migrate-create:
	@migrate create -ext sql -dir $(MIGRATIONS_DIR) -seq $(name)

# ⬆️ Run all up migrations
migrate-up:
	@migrate -path $(MIGRATIONS_DIR) -database "$(DB_URL)" up

# ⬇️ Roll back the last migration
migrate-down:
	@migrate -path $(MIGRATIONS_DIR) -database "$(DB_URL)" down 1

# 🧹 Reset the database (dangerous)
migrate-drop:
	@migrate -path $(MIGRATIONS_DIR) -database "$(DB_URL)" drop -f

# 🧩 Force set migration version (usage: make migrate-force version=1)
migrate-force:
	@migrate -path $(MIGRATIONS_DIR) -database "$(DB_URL)" force $(version)
