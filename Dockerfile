# -----------------------
# 1. Builder Stage
# -----------------------
FROM golang:1.24-alpine AS builder

WORKDIR /app

RUN apk add --no-cache git

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main ./cmd/server


# -----------------------
# 2. Runtime Stage
# -----------------------
FROM alpine:latest

RUN apk add --no-cache ca-certificates postgresql-client wget bash tzdata go git

WORKDIR /app

# Copy runtime files
COPY --from=builder /app/main .
COPY --from=builder /app/models ./models
COPY --from=builder /app/migrations ./migrations
COPY --from=builder /app/atlas.hcl .
COPY .env .env

# Install Atlas
RUN wget https://release.ariga.io/atlas/atlas-linux-amd64-latest -O /usr/local/bin/atlas \
    && chmod +x /usr/local/bin/atlas

# Copy startup script
COPY start.sh start.sh
RUN chmod +x start.sh

EXPOSE 8000

CMD ["bash", "start.sh"]
