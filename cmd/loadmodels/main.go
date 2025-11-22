package main

import (
	"go_backend_setup/models"
	"log"
	"os"

	"ariga.io/atlas-provider-gorm/gormschema"
)

func main() {
	stmts, err := gormschema.New("postgres").Load(
		&models.User{},
		&models.Admin{},
	)
	if err != nil {
		log.Fatalf("failed to load gorm schema: %v", err)
	}
	os.Stdout.WriteString(stmts)
}
