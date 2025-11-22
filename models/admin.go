package models

import "time"

type Admin struct {
	ID        uint   `gorm:"primary_key,autoIncrement:false"`
	Email     string `gorm:"unique;not null"`
	Password  string `gorm:"not null"`
	CreatedAt time.Time
	UpdatedAt time.Time
}
