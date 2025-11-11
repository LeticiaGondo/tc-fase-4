# Feedback API

Infraestrutura inicial do backend Feedback API utilizando Spring Boot, MySQL e Docker.

## Pré-requisitos

- Docker e Docker Compose
- Java 21 e Maven (para executar localmente sem Docker)

## Configuração

1. Copie as variáveis de ambiente padrão:
   ```bash
   cp .env.example .env
   ```
2. Suba os serviços:
   ```bash
   docker compose up --build -d
   ```
3. Verifique os endpoints de saúde:
   ```bash
   curl -sSf http://localhost:8080/health/ping
   curl -sSf http://localhost:8080/health/db
   curl -sSf http://localhost:8080/actuator/health
   ```

## Desenvolvimento

- Executar testes:
  ```bash
  ./mvnw verify
  ```
- Padronizar formatação/lint:
  ```bash
  ./mvnw spotless:apply
  ```
- Utilitários de banco:
  ```bash
  scripts/db/backup.sh
  scripts/db/restore.sh <arquivo>
  ```

## Estrutura principal

- `Dockerfile` e `docker-compose.yml` para build/execução da API e MySQL
- Configurações em `src/main/resources/application.yml`
- Migrações Flyway em `src/main/resources/db/migration`
- Endpoint de saúde em `src/main/java/com/fiap/feedback/api/HealthController.java`
