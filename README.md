# Go Backend Setup

A modern Go backend setup with Gin framework, PostgreSQL, and automated migrations using GORM and Atlas. This project provides a solid foundation for building web applications with Go.

## 🛠️ Prerequisites

Before you begin, ensure you have the following installed on your system:

1. **Go** (version 1.24 or later)
   - Download and install from [golang.org](https://golang.org/dl/)
   - Verify installation: `go version`

2. **PostgreSQL** (version 14 or later)
   - Download and install from [postgresql.org](https://www.postgresql.org/download/)
   - Verify installation: `psql --version`

3. **Atlas CLI Tool**
   - Install using Go:
     ```powershell
     go install ariga.io/atlas/cmd/atlas@latest
     ```
   - Verify installation: `atlas version`

4. **Migrate CLI Tool**
   - Install using Go:
     ```powershell
     go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest
     ```

## 📦 Project Dependencies

The project uses the following major dependencies:

- [Gin](https://github.com/gin-gonic/gin) - Web framework
- [GORM](https://gorm.io) - ORM library
- [Viper](https://github.com/spf13/viper) - Configuration management
- [Atlas](https://atlasgo.io) - Schema migration tool that auto-generates migrations from GORM models

## 🚀 Getting Started

1. **Clone the repository**
   ```powershell
   git clone https://github.com/rajpatelbot/go_backend_setup.git
   cd go_backend_setup
   ```

2. **Install dependencies**
   ```powershell
   go mod download
   ```

3. **Configure environment variables**
   - Copy the example environment file:
     ```powershell
     copy .env.example .env
     ```
   - Update the `.env` file based on your congigurations

4. **Run database migrations**
   ```powershell
   make migrate-up
   ```

## 🎯 Available Make Commands

- `make build` - Build the Go binary
- `make run` - Run the server
- `make migrate-create name=migration_name` - Create a new migration file
- `make migrate-apply` - Apply all the migrations with actual database

## 🔄 Development Workflow

1. Create or update Go models in the `models` directory
2. Generate a migration from your models:
   ```powershell
   make migrate-diff name=describe_your_changes
   ```
   This command will:
   - Compare your GORM models against the current database schema
   - Auto-generate the necessary SQL migration file
   - Place it in the `migrations` directory

3. Review the generated migration in the `migrations` directory

4. Apply the migration:
   ```powershell
   make migrate-apply
   ```

5. Start the server:
   ```powershell
   make run
   ```

## 📝 Additional Notes

- The server runs on port 8080 by default (configurable in `.env`)
- Supports graceful shutdown with a 5-second timeout
- Uses Gin's debug mode by default (configurable in `.env`)
