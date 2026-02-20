.PHONY: all build up down restart clean logs help

all: build up

build:
	docker-compose -f srcs/docker-compose.yml build

up:
	docker-compose -f srcs/docker-compose.yml up -d

down:
	docker-compose -f srcs/docker-compose.yml down

restart: down up

clean:
	docker-compose -f srcs/docker-compose.yml down -v
	docker system prune -af

logs:
	docker-compose -f srcs/docker-compose.yml logs -f

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