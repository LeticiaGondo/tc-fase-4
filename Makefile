PROJECT_NAME ?= feedback-api
COMPOSE ?= docker compose

ifneq (,$(wildcard .env))
  include .env
  export
endif

.PHONY: build up down logs restart clean test verify lint db-backup db-restore

build:
	$(COMPOSE) build

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

logs:
	$(COMPOSE) logs -f

restart: down up

clean:
	rm -rf target

test:
	./mvnw test

verify:
	./mvnw verify

lint:
	./mvnw spotless:apply

db-backup:
	scripts/db/backup.sh

db-restore:
	scripts/db/restore.sh
