# Миграция данных

## Flyway

Start from terminal:
```shell
flyway -user=postgres -password=postgres -locations='filesystem:flyway-scripts/migration' \
 -url="jdbc:postgresql://127.0.0.1:5432/postgres" -target=2  migrate
```

## Liqiubase

```shell
liquibase update
```