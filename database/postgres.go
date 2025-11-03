package database

import (
	"go_backend_setup/utils"
	"log"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

/**
 * This function is responsible to establish a connection with Postgres database.
 * This will return a DB instance.
 */
func NewDatabase() *gorm.DB {
	// Generate DSN
	dsn := utils.GenerateDSN()

	// Open connection
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("⚠️ Failed to connect to database: %v", err)
	}

	return db
}
