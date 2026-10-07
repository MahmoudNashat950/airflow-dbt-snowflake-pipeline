# Airflow + dbt + Snowflake Data Pipeline

A production-style data engineering pipeline that uses **Apache Airflow** to orchestrate **dbt** transformations running on **Snowflake**.

The project demonstrates how an orchestration tool, transformation framework, and cloud data warehouse can work together to build a reliable and testable data pipeline.

---
<img width="1903" height="753" alt="image" src="https://github.com/user-attachments/assets/390c411f-02a0-43b5-87da-5c7efb266f07" />

<img width="1814" height="774" alt="image" src="https://github.com/user-attachments/assets/5b01c286-0c4f-430c-8b3d-ca263e13bb72" />


<img width="1918" height="848" alt="image" src="https://github.com/user-attachments/assets/2ba5b698-13d6-4d66-a090-a671a776adb8" />


## Architecture

```text
                    ┌─────────────────┐
                    │   Apache Airflow│
                    │   Orchestration │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │   dbt Run       │
                    │ Transform Data  │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │    Snowflake    │
                    │  Data Warehouse │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │   dbt Tests     │
                    │ Data Validation │
                    └─────────────────┘
```

---

## Project Overview

The pipeline is orchestrated using Apache Airflow and executes a dbt workflow against Snowflake.

The Airflow DAG contains two main tasks:

1. **dbt Run** — builds the dbt models in Snowflake.
2. **dbt Test** — validates the transformed data after the models are built.

The tasks are executed sequentially:

```text
dbt_run → dbt_test
```

This ensures that data validation happens only after the transformations have completed successfully.

---

## Technologies

| Technology               | Purpose                              |
| ------------------------ | ------------------------------------ |
| **Apache Airflow 3.1.8** | Workflow orchestration               |
| **dbt Core 1.12.5**      | SQL transformations and data testing |
| **dbt Snowflake 1.12.1** | Snowflake adapter for dbt            |
| **Snowflake**            | Cloud data warehouse                 |
| **Python**               | Airflow DAG development              |
| **SQL**                  | Data transformation                  |
| **WSL2 / Ubuntu**        | Local development environment        |

---

## dbt Project Structure

```text
dbt/
└── snowglake_data_project/
    ├── analyses/
    ├── macros/
    ├── models/
    │   ├── staging/
    │   │   ├── stg_customer.sql
    │   │   ├── stg_order_items.sql
    │   │   ├── stg_orders.sql
    │   │   └── stg_products.sql
    │   │
    │   ├── marts/
    │   │   └── fct_daily_order_revenue.sql
    │   │
    │   └── sources.yml
    │
    ├── seeds/
    ├── tests/
    └── dbt_project.yml
```

### Staging Models

The staging layer prepares source data for downstream transformations.

Examples:

* `stg_customer`
* `stg_orders`
* `stg_order_items`
* `stg_products`

### Mart Model

The mart layer contains business-oriented transformed data.

Current example:

```text
fct_daily_order_revenue
```

This model produces daily order revenue information for analytical use cases.

---

## Airflow DAG

The DAG is located at:

```text
dags/dbt_dag.py
```

The workflow is defined as:

```python
dbt_run >> dbt_test
```

### Task 1 — dbt Run

Runs the dbt project against Snowflake:

```bash
dbt run
```

### Task 2 — dbt Test

Runs the dbt test suite:

```bash
dbt test
```

The second task depends on the successful completion of the first task.

---

## Data Transformation Flow

```text
Source Data
     │
     ▼
Staging Models
     │
     ├── stg_customer
     ├── stg_orders
     ├── stg_order_items
     └── stg_products
     │
     ▼
Mart Models
     │
     └── fct_daily_order_revenue
     │
     ▼
Analytics-Ready Data
```

---

## Running the Project

### 1. Clone the repository

```bash
git clone https://github.com/MahmoudNashat950/airflow-dbt-snowflake-pipeline.git

cd airflow-dbt-snowflake-pipeline
```

### 2. Configure Snowflake

Create a local dbt profile for your Snowflake account.

The profile should contain your Snowflake connection information, including:

* Account
* Username
* Password
* Role
* Warehouse
* Database
* Schema

**Do not commit credentials to GitHub.**

The repository intentionally excludes local credential files through `.gitignore`.

---

### 3. Run dbt manually

Navigate to the dbt project:

```bash
cd dbt/snowglake_data_project
```

Run:

```bash
dbt debug
```

Then:

```bash
dbt run
```

And finally:

```bash
dbt test
```

---

### 4. Start Airflow

Set the Airflow home directory:

```bash
export AIRFLOW_HOME=~/airflow
```

Activate the Airflow environment:

```bash
source ~/airflow_env/bin/activate
```

Start the Airflow API server:

```bash
airflow api-server --port 8081
```

In another terminal, start the scheduler:

```bash
airflow scheduler
```

---

### 5. Trigger the DAG

Trigger the workflow:

```bash
airflow dags trigger dbt_snowflake_workflow
```

The expected workflow is:

```text
dbt_run
   │
   ▼
dbt_test
   │
   ▼
DAG Success
```

---

## Data Quality

The pipeline uses dbt tests to validate the transformed data.

Running:

```bash
dbt test
```

allows data quality checks to be executed as part of the workflow.

This creates a simple validation layer between data transformation and downstream analytics.

---

## Project Goals

This project was built to practice and demonstrate:

* Data pipeline orchestration
* Apache Airflow DAG development
* dbt project structure
* SQL-based transformations
* Data warehouse concepts
* Snowflake integration
* Data quality testing
* Task dependencies
* Local development with WSL2
* Integration between multiple data engineering tools

---

## Key Design Principle

The project separates responsibilities between the different tools:

```text
Airflow → Orchestration

dbt → Transformation & Testing

Snowflake → Data Warehouse
```

This separation makes the pipeline easier to maintain, test, and extend.

---

## Future Improvements

Potential improvements include:

* Add incremental dbt models
* Add more data quality tests
* Add dbt documentation and lineage
* Add Airflow sensors
* Add automated CI/CD
* Containerize the complete environment with Docker
* Add monitoring and alerting
* Introduce a dedicated production deployment environment

---

## Author

**Mahmoud Nashat**

Data Engineering & AI Engineering Student

GitHub: [MahmoudNashat950](https://github.com/MahmoudNashat950)

Portfolio: [mahmoudnashat950.github.io](https://mahmoudnashat950.github.io/)
