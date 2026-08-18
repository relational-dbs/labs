# labs-setup

PostgreSQL lab environment for the **Relational Databases** course — a Dockerized
PostgreSQL 18 instance pre-loaded with six realistic datasets, paired with a
Jupyter/Python toolchain for exploring and querying them.

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-18.1-336791?logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.13-3776AB?logo=python&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-required-2496ED?logo=docker&logoColor=white)

---

## Table of contents

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Quickstart](#quickstart)
4. [Repository structure](#repository-structure)
5. [PostgreSQL infrastructure](#postgresql-infrastructure)
6. [The six datasets](#the-six-datasets)
7. [Connecting to the database](#connecting-to-the-database)
8. [Python environment](#python-environment)
9. [Available extensions](#available-extensions)
10. [Workflow](#workflow)
11. [Troubleshooting](#troubleshooting)
12. [Course notes](#course-notes)

---

## Overview

This repository provisions the database layer used throughout the course labs. It
provides:

- A **PostgreSQL 18** server running in Docker, with a curated set of extensions
  (PostGIS, pgvector, pg_cron, and more) pre-installed.
- **Six domain-specific datasets** (airline, e-commerce, banking, library,
  ride-sharing, video streaming), each shipped as a SQL dump plus an ER diagram.
- **Two Jupyter notebooks** that automate the entire lifecycle: one that builds and
  starts the container, and one that loads the datasets.
- A **Python environment** (managed with `uv`) with the drivers and libraries needed
  to work with PostgreSQL from JupyterLab (`psycopg2`, `psycopg3`, SQLAlchemy,
  SQLModel, pandas, …).

Everything runs locally on your machine via Docker; no remote server or VPN is
required for the labs themselves.

---

## Prerequisites

| Tool | Minimum version | Purpose |
|---|---|---|
| [Docker Desktop](https://www.docker.com/products/docker-desktop/) | recent | Runs the PostgreSQL container |
| [Git](https://git-scm.com/) | — | Clones this submodule |
| [uv](https://docs.astral.sh/uv/) | — | Creates the Python virtual environment |
| Python | 3.13 | Kernel used by the notebooks |

> **Note:** this repository is a **git submodule** of the course project. If you
> cloned the parent repository, initialize submodules before proceeding (see
> [Quickstart](#quickstart)).

---

## Quickstart

```bash
# 1. From the parent repository, fetch the submodule
git submodule update --init --recursive

# 2. Enter this project and install its dependencies (own venv + kernel)
cd labs-setup
uv sync

# 3. Launch JupyterLab with this project's kernel
uv run jupyter lab
```

Then, inside JupyterLab, run the two notebooks **in order**:

1. **`postgresql/postgresql_infra.ipynb`** — generates the Dockerfile and
   `docker-compose` file, builds the image, and starts the container.
2. **`postgresql/postgresql_dataload.ipynb`** — copies the schemas into the
   container mount, creates the six databases, and imports their data.

After the second notebook finishes, the server is listening on **port `5423`** and
all six databases are ready to query (see
[Connecting to the database](#connecting-to-the-database)).

---

## Repository structure

```
labs-setup/
├── pyproject.toml                 # Python project + dependencies (uv-managed)
├── README.md
└── postgresql/
    ├── postgresql_infra.ipynb     # Builds & starts the container (generates Docker files)
    ├── postgresql_dataload.ipynb  # Creates the 6 DBs and imports the datasets
    ├── init-db.sh                 # Entrypoint: creates DBs listed in $DBS_LIST
    └── schemas/                   # Source datasets (committed)
        ├── aerolinea/             #   aerolinea_db.sql + ERD Aerolinea.pdf
        ├── amazon/                #   amazon_db.sql    + ERD Amazon.pdf
        ├── banco/                 #   banco_db.sql     + ERD Banco.pdf
        ├── biblioteca/            #   biblioteca_db.sql+ ERD Biblioteca.pdf
        ├── uber/                  #   uber_db.sql      + ERD Uber.pdf
        └── youtube/               #   youtube_db.sql   + ERD Youtube.pdf
```

> The `postgresql.dockerfile`, `postgresql.docker-compose.yml`, and the `mount/`
> directory are **generated at runtime** by the notebooks and are intentionally
> git-ignored. `mount/` holds the container's persistent data and a copy of the
> schemas that get bind-mounted into the container.

---

## PostgreSQL infrastructure

| Aspect | Value |
|---|---|
| Base image | `postgres:18.1-trixie` |
| Compiled extensions | `pg_cron` (from source), `pgvector` v0.8.2 (from source) |
| Apt-installed | PostGIS 3, `plpython3u` |
| Preloaded libraries | `pg_stat_statements`, `pg_cron` |
| Port mapping | `5423` (host) → `5432` (container) |
| Default database | `postgres` |
| Credentials | user `postgres` / password `password` |
| Resource limits | 2 CPUs, 2 GB memory |
| Restart policy | `unless-stopped` |
| Healthcheck | `pg_isready` + `SELECT 1` against each database |

### Persistent volumes

| Host path | Container path | Purpose |
|---|---|---|
| `mount/postgres/data` | `/var/lib/postgresql` | Database files (persists across restarts) |
| `mount/postgres/schemas` | `/schemas` | SQL dumps consumed by the data-loading notebook |
| `init-db.sh` | `/docker-entrypoint-initdb.d/init-db.sh` | First-start initialization |

The container also registers `host.docker.internal` → host gateway, so processes
inside the container can reach your host machine when needed.

---

## The six datasets

Each dataset lives under `postgresql/schemas/<name>/` as a PostgreSQL dump
(`<name>_db.sql`) plus a PDF entity-relationship diagram (`ERD <Name>.pdf`).

| Dataset | Domain | ER diagram |
|---|---|---|
| `aerolinea` | Airline — flights, passengers, routes | `ERD Aerolinea.pdf` |
| `amazon` | E-commerce — products, orders, payments | `ERD Amazon.pdf` |
| `banco` | Banking — customers, cards, transactions | `ERD Banco.pdf` |
| `biblioteca` | Library — books, loans, inventory | `ERD Biblioteca.pdf` |
| `uber` | Ride-sharing — users, drivers, trips | `ERD Uber.pdf` |
| `youtube` | Video streaming — users, videos, comments | `ERD Youtube.pdf` |

Each database is created with the same name as its dataset (e.g. the `aerolinea`
schema is loaded into the `aerolinea` database).

---

## Connecting to the database

### Connection string

```
postgresql://postgres:password@localhost:5423/postgres
```

Replace the final `postgres` with any of the dataset database names to target that
database, e.g.:

```
postgresql://postgres:password@localhost:5423/banco
```

### psql

```bash
psql "postgresql://postgres:password@localhost:5423/banco"
```

or from inside the container:

```bash
docker exec -it postgres psql -U postgres -d banco
```

### SQLAlchemy

```python
from sqlalchemy import create_engine

engine = create_engine("postgresql+psycopg2://postgres:password@localhost:5423/banco")
```

> The host is `localhost` (or `127.0.0.1`) when connecting from your machine, and
> `host.docker.internal` when connecting from another container.

---

## Python environment

The project is managed with [uv](https://docs.astral.sh/uv/). Running `uv sync`
creates the `.venv` and installs the kernel used by the notebooks (`python3`, from
the `relational-databases-labs` environment).

Key dependencies:

| Category | Packages |
|---|---|
| Jupyter | `jupyterlab`, `ipykernel`, `ipython-sql`, `ipywidgets`, `jupyter-tabnine` |
| PostgreSQL drivers | `psycopg2-binary`, `psycopg[binary]` |
| ORM / data | `sqlalchemy`, `sqlmodel`, `pandas`, `pydantic` |
| Data generation | `faker`, `faker-commerce`, `mimesis` |
| Console tables | `prettytable` (pinned `3.7.0`) |

The `ipython-sql` extension lets you run SQL directly inside notebook cells with the
`%sql` magic — handy for quick queries during labs.

---

## Available extensions

The image ships with the following extensions available. Enable them with
`CREATE EXTENSION` (see the *Plugins commands* cell in `postgresql_infra.ipynb` for
the full enable/disable list):

| Extension | Purpose |
|---|---|
| `plpython3u` | Python procedures inside the database |
| `vector` | Semantic / vector search (pgvector) |
| `postgis` | Geospatial and map data |
| `pg_trgm` | Fuzzy ("Google-like") text search |
| `unaccent` | Accent-insensitive matching |
| `pg_stat_statements` | Query performance statistics |
| `pg_cron` | Scheduled jobs (run in the `postgres` database) |
| `ltree` | Hierarchies and tree structures |
| `hstore` | Key-value pairs |

---

## Workflow

The two notebooks encode the full lifecycle and are meant to be run in order:

1. **`postgresql_infra.ipynb`**
   - Writes `postgresql.dockerfile` (PostgreSQL 18 + PostGIS + `plpython3u` +
     compiled `pg_cron` and `pgvector`).
   - Writes `postgresql.docker-compose.yml` (build context, volumes, ports, resource
     limits, healthcheck).
   - Runs `docker compose up -d --wait` to build and start the container.

2. **`postgresql_dataload.ipynb`**
   - Copies `postgresql/schemas/` into `mount/postgres/schemas/`.
   - Drops and recreates the six databases.
   - Imports each SQL dump into its database with `psql`.

### Rebuilding from scratch

The `POSTGRESQL_START_FROM_SCRATCH` flag in each notebook controls whether the
mount directory is wiped before (re)starting:

- Set to `True` to reset the environment completely (drops persisted data).
- Set to `False` (default in the infra notebook) to keep existing volumes.

To force a clean rebuild of the image, uncomment the
`docker compose … build --no-cache` line in the infra notebook.

---

## Troubleshooting

| Symptom | Likely cause / fix |
|---|---|
| Container reports `unhealthy` | The healthcheck also probes each database. On first start no databases exist yet; run `postgresql_dataload.ipynb` to create them, then re-check. |
| `port 5423 already in use` | Another PostgreSQL (or the container) is bound to `5423`. Stop it or change `POSTGRESQL_PORT` in the notebooks. |
| "Database does not exist" | The dataload notebook has not run yet, or it failed partway. Re-run it. |
| Changes don't persist after restart | Data lives in `mount/postgres/data`; if it was deleted (or `POSTGRESQL_START_FROM_SCRATCH=True`), data is recreated only by re-running the dataload notebook. |
| Docker build fails on `pg_cron`/`pgvector` | The build compiles both from source; ensure a stable network connection and sufficient disk space. |

---

## Course notes

- This is an **external submodule** (`github.com/relational-dbs/labs-setup`). It keeps
  its **own** `pyproject.toml`, virtual environment, and Jupyter kernel — do not
  modify it from the parent course repository.
- The Dockerfile and `docker-compose` file are generated artifacts; if you need a
  permanent change, edit the generation cells in `postgresql_infra.ipynb`, not the
  generated files.
- Credentials (`postgres` / `password`) are lab defaults and are **not** meant for
  production use.
