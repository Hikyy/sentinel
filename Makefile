# Sentinel Hooks — commandes dev courantes.
#
# Workflow recommandé :
#   1. `make up`        — démarre Postgres + RabbitMQ + backend + frontend en Docker (hot-reload)
#   2. dans ton IDE Java, configure le projet pour compiler dans apps/backend/target/classes
#      (IntelliJ: Project Structure → Modules → Paths → Inherit project compile output)
#   3. modifie un fichier Java ou TS — le reload est automatique

.PHONY: help up down logs ps clean dev-back dev-front test test-back test-front build build-back build-front backend-deps

help:
	@echo "Sentinel Hooks — commandes :"
	@echo ""
	@echo "  make up             Démarre toute la stack DEV (Postgres+RabbitMQ+back+front)"
	@echo "  make down           Arrête toute la stack"
	@echo "  make logs           Suit les logs de tous les services"
	@echo "  make ps             Liste les services en cours"
	@echo "  make clean          Arrête + supprime volumes (⚠️ perd les données)"
	@echo ""
	@echo "  make dev-back       Démarre seulement Postgres+RabbitMQ (pour run le back en local)"
	@echo "  make backend-deps   Pré-télécharge les dépendances Maven dans target/dependency"
	@echo ""
	@echo "  make test           Tous les tests"
	@echo "  make test-back      Tests backend uniquement"
	@echo "  make test-front     Tests frontend uniquement"
	@echo ""
	@echo "  make build          Build prod des images Docker"

up:
	docker compose -f infra/docker-compose.yml up -d
	@echo ""
	@echo "✅ Stack démarrée. Services :"
	@echo "   Backend       : http://localhost:8080"
	@echo "   Frontend      : http://localhost:4200"
	@echo "   Actuator      : http://localhost:8080/actuator/health"
	@echo "   Prometheus    : http://localhost:8080/actuator/prometheus"
	@echo "   RabbitMQ UI   : http://localhost:15672 (sentinel/dev)"
	@echo "   Postgres      : localhost:5432 (sentinel/sentinel/dev)"

down:
	docker compose -f infra/docker-compose.yml down

logs:
	docker compose -f infra/docker-compose.yml logs -f

ps:
	docker compose -f infra/docker-compose.yml ps

clean:
	docker compose -f infra/docker-compose.yml down -v

dev-back:
	docker compose -f infra/docker-compose.yml up -d postgres rabbitmq

backend-deps:
	cd apps/backend && mvn dependency:copy-dependencies -DoutputDirectory=target/dependency

test: test-back test-front

test-back:
	docker compose -f infra/docker-compose.yml run --rm -w /build \
	  -v $(PWD)/apps/backend:/build maven:3.9-eclipse-temurin-21-alpine \
	  mvn -B test

test-front:
	cd apps/frontend && npm test

build: build-back build-front

build-back:
	docker build -t sentinel/backend:latest -f apps/backend/Dockerfile apps/backend

build-front:
	docker build -t sentinel/frontend:latest -f apps/frontend/Dockerfile apps/frontend
