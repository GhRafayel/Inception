.PHONY: all build up down restart logs clean fclean re help

NAME = inception

all: build up

build:
	@mkdir -p /home/$(USER)/data/mariadb
	@mkdir -p /home/$(USER)/data/wordpress
	docker compose -f srcs/docker-compose.yml build

up:
	docker compose -f srcs/docker-compose.yml up -d

down:
	docker compose -f srcs/docker-compose.yml down

restart:
	docker compose -f srcs/docker-compose.yml restart

logs:
	docker compose -f srcs/docker-compose.yml logs -f

clean:
	docker compose -f srcs/docker-compose.yml down -v

fclean: clean
	docker system prune -af --volumes
	sudo rm -rf /home/$(USER)/data

re: fclean all

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
	@echo "  make fclean    - Full clean (containers, images, volumes, data)"
	@echo "  make logs      - View container logs"
	@echo "  make re        - Rebuild everything from scratch"
	@echo "  make help      - Show this help message"