CLEAN_COLOR     = \033[38;5;198m
REMOVE_COLOR    = \033[38;5;201m
COMPILE_COLOR   = \033[38;5;207m
BOX_COLOR       = \033[38;5;219m
SUCCESS_COLOR   = \033[38;5;46m
INFO_COLOR      = \033[38;5;51m
RESET           = \033[0m

PROJECT_NAME    = inception
COMPOSE_FILE    = srcs/docker-compose.yml
ENV_FILE        = srcs/.env
DATA_PATH       = $(HOME)/data

all: up


up:
	@echo "$(BOX_COLOR)╔════════════════════════════════════════════╗$(RESET)"
	@echo "$(BOX_COLOR)║          Starting Inception Project        ║$(RESET)"
	@echo "$(BOX_COLOR)╚════════════════════════════════════════════╝$(RESET)"
	@echo "$(INFO_COLOR)📁 Creating data directories...$(RESET)"
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/static
	@echo "$(COMPILE_COLOR)🐳 Building and starting containers...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) --env-file $(ENV_FILE) up -d $(QUIET)
	@echo "$(SUCCESS_COLOR)✅ Inception is now running!$(RESET)"
	@echo "$(INFO_COLOR)🌐 WordPress          → https://lanani-f.42.fr$(RESET)"
	@echo "$(INFO_COLOR)📄 Static Site        → https://static.lanani-f.42.fr$(RESET)"
	@echo "$(INFO_COLOR)🧭 Portainer          → https://portainer.lanani-f.42.fr$(RESET)"
	@echo "$(INFO_COLOR)🗂️  Adminer            → https://adminer.lanani-f.42.fr$(RESET)"
	@echo "$(INFO_COLOR)🧑‍💻 WordPress admin  → https://lanani-f.42.fr/wp-admin$(RESET)"


down:
	@echo "$(CLEAN_COLOR)🛑 Stopping Inception containers...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) down $(QUIET)
	@echo "$(SUCCESS_COLOR)✅ All containers stopped$(RESET)"


restart:
	@echo "$(INFO_COLOR)🔄 Restarting Inception containers...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) restart $(QUIET)
	@echo "$(SUCCESS_COLOR)✅ Containers restarted$(RESET)"


logs:
	@echo "$(INFO_COLOR)📋 Showing container logs...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) logs


build:
	@echo "$(BOX_COLOR)╔════════════════════════════════════════════╗$(RESET)"
	@echo "$(BOX_COLOR)║            Building Docker Images          ║$(RESET)"
	@echo "$(BOX_COLOR)╚════════════════════════════════════════════╝$(RESET)"
	@echo "$(COMPILE_COLOR)🔨 Building all Docker images...$(RESET)"

	@DOCKER_BUILDKIT=0 docker compose -f $(COMPOSE_FILE) build > /dev/null 2>&1
	@echo "$(SUCCESS_COLOR)✅ All images built successfully!$(RESET)"


clean:
	@echo "$(CLEAN_COLOR)🧹 Cleaning containers and volumes...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) down -v $(QUIET)
	@docker system prune -af $(QUIET)
	@echo "$(SUCCESS_COLOR)✅ Cleanup completed$(RESET)"


fclean: clean
	@echo "$(BOX_COLOR)╔════════════════════════════════════════════╗$(RESET)"
	@echo "$(BOX_COLOR)║           Full Cleanup Started             ║$(RESET)"
	@echo "$(BOX_COLOR)╚════════════════════════════════════════════╝$(RESET)"
	@echo "$(REMOVE_COLOR)🗑️  Removing all containers and volumes...$(RESET)"
	@docker compose -f $(COMPOSE_FILE) down $(QUIET)
	@docker system prune -af $(QUIET)
	@echo "$(REMOVE_COLOR)🗑️  Cleaning data directories...$(RESET)"
	@docker run --rm -v $(DATA_PATH):/data alpine:3.21 sh -c "rm -rf /data/mariadb /data/static" $(QUIET)
	@echo "$(SUCCESS_COLOR)✅ Full cleanup completed!$(RESET)"


re: fclean all


status:
	@echo "$(INFO_COLOR)📊 Inception Project Status:$(RESET)"
	@echo "$(INFO_COLOR)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)"
	@docker compose -f $(COMPOSE_FILE) ps $(QUIET)
	@cd srcs/requirements/tools && ./health_check.sh


help:
	@echo "$(BOX_COLOR)╔════════════════════════════════════════════╗$(RESET)"
	@echo "$(BOX_COLOR)║              Inception Makefile            ║$(RESET)"
	@echo "$(BOX_COLOR)║                Help Menu                   ║$(RESET)"
	@echo "$(BOX_COLOR)╚════════════════════════════════════════════╝$(RESET)"
	@echo "$(INFO_COLOR)Available commands:$(RESET)"
	@echo "  $(SUCCESS_COLOR)make up$(RESET)      - Start all services"
	@echo "  $(SUCCESS_COLOR)make down$(RESET)    - Stop all services"
	@echo "  $(SUCCESS_COLOR)make restart$(RESET) - Restart all services"
	@echo "  $(SUCCESS_COLOR)make build$(RESET)   - Build all images"
	@echo "  $(SUCCESS_COLOR)make logs$(RESET)    - Show container logs"
	@echo "  $(SUCCESS_COLOR)make clean$(RESET)   - Clean containers and volumes"
	@echo "  $(SUCCESS_COLOR)make fclean$(RESET)  - Full cleanup"
	@echo "  $(SUCCESS_COLOR)make re$(RESET)      - Rebuild everything"
	@echo "  $(SUCCESS_COLOR)make status$(RESET)  - Show project status"
	@echo "  $(SUCCESS_COLOR)make help$(RESET)    - Show this help"
	@echo "  $(SUCCESS_COLOR)make redis$(RESET)   - Check Redis status in WordPress"


redis:
	@echo "$(INFO_COLOR)🔍 Checking Redis status in WordPress...$(RESET)"
	@docker exec -it wordpress wp redis status --allow-root


.PHONY: all up down restart logs build clean fclean re status help