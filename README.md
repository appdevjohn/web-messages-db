# Web Messages PostgreSQL Config

The `setup.sql` file contains all of the instructions to set up the PostgreSQL database.

## Setting Up in Docker

First, build an image with the database properly set up.

```
docker build -t messages-db .
```

Next, run a container based on that image. Use the following environment variables and set the port to `5432`.

```
docker run -p 5432:5432 --name db -d \
    -e POSTGRES_USER=user \
    -e POSTGRES_PASSWORD=password1 \
    -e POSTGRES_DB=messages_db \
    messages-db
```

Then, if you want to interact with the database in the terminal, you can exec into the container.

```
docker exec -it db bash

psql -U user -d messages_db
```
