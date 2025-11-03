package database

import (
	"log"
	"os/exec"

	"go_backend_setup/utils"
)

/**
 * This function is responsible to generate a migrations and store it in migrations folder.
 */
func RunMigrations() {
	// Generate DSN
	dsn := utils.GenerateDSN()

	// Execute migration command
	cmd := exec.Command(
		"migrate",
		"-path", "migrations",
		"-database", dsn,
		"up",
	)

	// Run the command and capture output
	output, err := cmd.CombinedOutput()
	if err != nil {
		log.Fatalf("Migration failed: %v\n%s", err, string(output))
	}

	log.Println("✅ Migrations applied successfully.")
}
