data "external_schema" "gorm" {
  program = [
    "go",
    "run",
    "-mod=mod",
    "ariga.io/atlas-provider-gorm",
    "load",
    "--dialect", "postgres",
    "--path", "./models"
  ]
}

env "gorm" {
  src = data.external_schema.gorm.url
  dev = "postgres://${env.USER}:${env.PASSWORD}@${env.HOST}:${env.DB_PORT}/${env.DB_NAME}?sslmode=${env.SSL_MODE}"
  
  migration {
    dir = "file://migrations"
    format = golang-migrate
  }

  format {
    migrate {
      diff = "{{ sql . }}"
    }
  }
}
