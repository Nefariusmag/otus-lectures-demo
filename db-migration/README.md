# Миграция данных

## Flyway

Before

```shell
docker run -p 5432:5432 -it --rm -e POSTGRES_PASSWORD=postgres --name postgres-db postgres:11 
```

Start from terminal:
```shell
flyway -user=postgres -password=postgres -locations='filesystem:flyway-scripts/migration' \
 -url="jdbc:postgresql://127.0.0.1:5432/postgres" -target=2  migrate
```

## Liqiubase

```shell
liquibase status
liquibase updateSQL
liquibase update
liquibase changelogSync
```