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

```mermaid
flowchart LR
    classDef host  fill:#e8f0fe,stroke:#4285f4,stroke-width:1.5px,color:#174ea6
    classDef ctr   fill:#e6f4ea,stroke:#34a853,stroke-width:1.5px,color:#137333
    classDef db    fill:#fef7e0,stroke:#f9ab00,stroke-width:1.5px,color:#b06000
    classDef aux   fill:#f1f3f4,stroke:#9aa0a6,stroke-width:1px,color:#3c4043

    subgraph HOST["HOST MACHINE"]
        direction TB
        JL["JupyterLab<br/><i>kernel: python3</i>"]:::host
        INF["postgresql_infra.ipynb<br/>build + start"]:::host
        DL["postgresql_dataload.ipynb<br/>create DBs + import"]:::host
        SRC["schemas/<br/>6 datasets + ERDs"]:::host
        VOL["mount/postgres/<br/>data · schemas"]:::host
    end

    subgraph CT["DOCKER CONTAINER · postgres:18.1-trixie"]
        direction TB
        PG[("PostgreSQL 18")]:::ctr
        EXT["PostGIS 3 · pgvector 0.8.2 · pg_cron<br/>plpython3u · pg_trgm · unaccent<br/>pg_stat_statements · ltree · hstore"]:::aux
        V1["/var/lib/postgresql"]:::aux
        V2["/schemas"]:::aux
    end

    subgraph DBS["DATABASES"]
        direction TB
        A[(aerolinea)]:::db
        B[(amazon)]:::db
        C[(banco)]:::db
        D[(biblioteca)]:::db
        E[(uber)]:::db
        F[(youtube)]:::db
    end

    JL --> INF
    JL --> DL
    SRC -->|copy| DL
    INF -->|"docker compose up"| CT
    DL -->|"psql import"| PG
    VOL -.->|bind| V1
    VOL -.->|bind| V2
    PG --- EXT
    PG --> A & B & C & D & E & F
    JL -.->|"localhost:5423"| PG
```

---

## Prerequisites

The environment needs **Docker**, **Git**, and **uv**. **Python 3.13** (the notebook
kernel) is installed and managed automatically by `uv` — no separate Python download
is required.

| Tool | Purpose | Windows | macOS | Linux |
|---|---|---|---|---|
| **Docker** | Runs the PostgreSQL container | [Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/) | [Docker Desktop](https://docs.docker.com/desktop/setup/install/mac-install/) | [Docker Engine](https://docs.docker.com/engine/install/) · [Desktop](https://docs.docker.com/desktop/setup/install/linux/) |
| **Git** | Clones the submodule | [Git for Windows](https://github.com/git-for-windows/git/releases/latest) | [Homebrew](https://brew.sh/) → `brew install git` | `apt`/`dnf` · [per-distro](https://git-scm.com/download/linux) |
| **uv** | Creates the venv + kernel | [install.ps1](https://astral.sh/uv/install.ps1) | [install.sh](https://astral.sh/uv/install.sh) | [install.sh](https://astral.sh/uv/install.sh) |
| **Python 3.13** | Kernel | via `uv` | via `uv` | via `uv` |

> **Note:** this repository is a **git submodule** of the course project. If you
> cloned the parent repository, initialize submodules before proceeding (see
> [Quickstart](#quickstart)).

### Docker

**Windows** — Docker Desktop (requires WSL2). Install via the
[Windows install guide](https://docs.docker.com/desktop/setup/install/windows-install/)
or download directly:
[Docker Desktop Installer.exe](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe)

**macOS** — Docker Desktop ([install guide](https://docs.docker.com/desktop/setup/install/mac-install/)):
- Apple Silicon: [Docker.dmg (arm64)](https://desktop.docker.com/mac/main/arm64/Docker.dmg)
- Intel: [Docker.dmg (amd64)](https://desktop.docker.com/mac/main/amd64/Docker.dmg)

**Linux** — [Docker Engine](https://docs.docker.com/engine/install/)
(e.g. [Ubuntu](https://docs.docker.com/engine/install/ubuntu/)), or
[Docker Desktop for Linux](https://docs.docker.com/desktop/setup/install/linux/).

Verify: `docker --version` and `docker compose version`.

### Git

**Windows** — install [Git for Windows](https://github.com/git-for-windows/git/releases/latest).

**macOS** — via [Homebrew](https://brew.sh/) (recommended):

```bash
# 1. Install Homebrew (package manager)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install Git
brew install git
```

or via Xcode Command Line Tools: `xcode-select --install`.

**Linux** — use your package manager ([all distributions](https://git-scm.com/download/linux)):

```bash
sudo apt install git   # Debian / Ubuntu
sudo dnf install git   # Fedora
```

Verify: `git --version`.

### uv

**Windows** (PowerShell):

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**macOS / Linux**:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Full instructions: [uv installation docs](https://docs.astral.sh/uv/getting-started/installation/).

### Python 3.13

Managed by `uv` — running `uv sync` in this project provisions the correct Python
(≥ 3.13) automatically. To install it explicitly:

```bash
uv python install 3.13
```

A standalone install is also available at [python.org](https://www.python.org/downloads/)
([Windows](https://www.python.org/downloads/windows/), [macOS](https://www.python.org/downloads/macos/)) if you prefer to manage Python yourself.

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

```mermaid
flowchart TB
    classDef step fill:#e8f0fe,stroke:#4285f4,stroke-width:1.5px,color:#174ea6
    classDef dec  fill:#fce8e6,stroke:#ea4335,stroke-width:1.5px,color:#a50e0e
    classDef done fill:#e6f4ea,stroke:#34a853,stroke-width:1.5px,color:#137333

    S1["1 · Run postgresql_infra.ipynb"]:::step --> D{POSTGRESQL_START_FROM_SCRATCH?}:::dec
    D -->|"yes"| S2["Reset mount/"]:::step
    D -->|"no (default)"| S3["Reuse volumes"]:::step
    S2 --> S4["Generate dockerfile + compose"]:::step
    S3 --> S4
    S4 --> S5["docker compose up -d --wait"]:::step
    S5 --> S6["Container healthy"]:::done
    S6 --> S7["2 · Run postgresql_dataload.ipynb"]:::step
    S7 --> S8["Copy schemas/ → mount/"]:::step
    S8 --> S9["DROP + CREATE 6 databases"]:::step
    S9 --> S10["psql import *_db.sql"]:::step
    S10 --> S11[("6 databases ready")]:::done
```

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
