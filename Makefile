.PHONY: all build up down restart clean logs help

all: build up

DC=docker compose -f srcs/docker-compose.yml

build:
	$(DC) build

up:
	$(DC) up -d

down:
	$(DC) down

logs:
	$(DC) logs -f

clean:
	$(DC) down -v
	docker system prune -af

help:
	@echo "Inception Project - Docker Infrastructure"
	@echo "=========================================="
	@echo "Available commands:"
	@echo "  make all       - Build and start all containers"
	@echo "  make build     - Build Docker images"
	@echo "  make up        - Start containers"
	@echo "  make down      - Stop containers"
	@echo "  make restart   - Restart all containers"
	@echo "  make clean     - Stop containers and remove volumes"
	@echo "  make logs      - View container logs"
	@echo "  make help      - Show this help message"
