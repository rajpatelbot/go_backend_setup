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
   - Update the `.env` file with your PostgreSQL credentials and other configurations:
     ```env
     PORT=8080
     GIN_MODE=debug

     # Database Configuration
     DB_HOST=localhost
     DB_PORT=5432
     DB_NAME=your_database_name
     DB_USER=your_username
     DB_PASSWORD=your_password
     SSL_MODE=disable
     ```

4. **Create the database**
   ```sql
   createdb your_database_name
   ```

5. **Run database migrations**
   ```powershell
   make migrate-up
   ```

## 🎯 Available Make Commands

- `make build` - Build the Go binary
- `make run` - Run the server
- `make migrate-create name=migration_name` - Create a new migration file
- `make migrate-up` - Run all pending migrations
- `make migrate-down` - Rollback the last migration

## 🏗️ Project Structure

```
.
├── cmd/
│   └── server/
│       └── main.go       # Application entry point
├── config/
│   └── env.go            # Environment configuration
├── database/
│   └── postgres.go       # Database connection
├── migrations/           # Database migration files
├── models/
│   └── user.go          # Data models
└── utils/
    └── dsn.go           # Database connection string utilities
```

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
   make migrate-up
   ```

5. Start the server:
   ```powershell
   make run
   ```

### 📝 Migration Workflow Example

Let's say you want to add a new field to your User model:

1. Update the model in `models/user.go`:
   ```go
   type User struct {
       ID        uint      `gorm:"primarykey"`
       Name      string    `gorm:"size:255;not null"`
       Email     string    `gorm:"size:255;not null;unique"`
       Age       int       `gorm:"not null"` // New field
       CreatedAt time.Time
       UpdatedAt time.Time
   }
   ```

2. Generate the migration:
   ```powershell
   make migrate-diff name=add_age_to_users
   ```

3. Atlas will generate a migration like:
   ```sql
   -- migrate:up
   ALTER TABLE users ADD COLUMN age integer NOT NULL;
   
   -- migrate:down
   ALTER TABLE users DROP COLUMN age;
   ```

4. Apply the migration:
   ```powershell
   make migrate-up
   ```

## 📝 Additional Notes

- The server runs on port 8080 by default (configurable in `.env`)
- Supports graceful shutdown with a 5-second timeout
- Uses Gin's debug mode by default (configurable in `.env`)

## � Run with Docker

You can run the Postgres database and the app with Docker Compose. This is useful for local development or CI.

1. Copy `.env.example` to `.env` (if present) and update values. For the Docker setup, set the DB host to the compose service name `db`:

```powershell
copy .env.example .env
# edit .env and set:
# HOST=db
# PORT=8080
# DB_PORT=5432
```

2. Build and start the app + database:

```powershell
docker compose up --build
```

The app will be reachable at http://localhost:8080 (or the port you set in `.env`).

Notes about running migrations:

- Option A — Run migrations from your host (recommended if you have `atlas`/`migrate` installed):
   1. Start Postgres with Docker Compose: `docker compose up -d db`
   2. Update `.env` so the DB host that the migration tool connects to is `localhost` and `DB_PORT` is the mapped port (usually `5432`).
   3. Run `make migrate-up` from your host as usual.

- Option B — Run migrations from inside a container (advanced):
   - The app image here is a small runtime image (it does not include the Atlas or migrate CLIs). If you prefer to run migrations in a container, create a small helper image that includes the CLI tools or run them from a temporary container that has the tools installed and network access to the `db` service.

If you hit a connection error, confirm the following:

- `.env` is present and either the app container has `HOST=db` (so the app connects to the compose postgres), or you connect from your host and use `localhost` with a mapped port.
- Port mapping in `docker-compose.yml` is set to `${PORT}:${PORT}` and `${DB_PORT}:5432`.


## �📄 License

This project is licensed under the MIT License - see the `LICENSE` file for details.
