.PHONY: all build up down clean logs help

all: build up

DC=docker compose -f docker-compose.yml

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

fclean: clean
	docker rmi -f $$(docker images -aq) || true
	docker network prune -f
	docker builder prune -af

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
