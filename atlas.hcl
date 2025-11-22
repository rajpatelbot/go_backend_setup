locals {
  db_user     = getenv("USER")
  db_password = getenv("PASSWORD")
  db_host     = getenv("HOST")
  db_port     = getenv("DB_PORT")
  db_name     = getenv("DB_NAME")
  ssl_mode    = getenv("SSL_MODE")

  db_url = "postgres://${local.db_user}:${local.db_password}@${local.db_host}:${local.db_port}/${local.db_name}?sslmode=${local.ssl_mode}&search_path=public"
}

data "external_schema" "gorm" {
  program = [
    "go",
    "run",
    "-mod=mod",
    "cmd/loadmodels/main.go"
  ]
}

env "gorm" {
  src = data.external_schema.gorm.url
  url = local.db_url
  dev = "docker://postgres/latest"

  migration {
    dir    = "file://migrations"
    format = atlas
  }

  format {
    migrate {
      diff = "{{ sql . \" \" }}"
    }
  }
}
