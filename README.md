<img align='right' src="/assets/gptuner.png" alt="GPTuner logo" width="130">

# GPTuner: A Manual-Reading Database Tuning System via GPT-Guided Bayesian Optimization

- This repository hosts the source code and supplementary materials for our VLDB 2024 submission, "GPTuner: A Manual-Reading Database Tuning System via GPT-Guided Bayesian Optimization". 
- GPTuner collects and refines heterogeneous domain knowledge, unifies a structured view of the refined knowledge, and uses the knowlege to (1) select important knobs, (2) optimize the value range of each knob and (3) explore the optimized space with a novel Coarse-to-Fine Bayesian Optimization Framework.


## System Overview

<img src="/assets/gptuner_overview.png" alt="GPTuner overview" width="800">

**GPTuner** is a manual-reading database tuning system to suggest satisfactory knob configurations with reduced tuning costs. The figure above presents the tuning workflow that involves seven steps:
1. 📌 User provides the DBMS to be tuned (e.g., PostgreSQL or MySQL), the target workload, and the optimization objective (e.g., latency or throughput).
2. 📌 GPTuner collects and refines the heterogeneous knowledge from different sources (e.g., GPT-4, DBMS manuals, and web forums) to construct _Tuning Lake_, a collection of DBMS tuning knowledge.
3. 📌 GPTuner unifies the refined tuning knowledge from _Tuning Lake_ into a structured view accessible to machines (e.g., JSON).
4. 📌 GPTuner reduces the search space dimensionality by selecting important knobs to tune (i.e., fewer knobs to tune means fewer dimensions).
5. 📌 GPTuner optimizes the search space in terms of the value range for each knob based on structured knowledge.
6. 📌 GPTuner explores the optimized space via a novel Coarse-to-Fine Bayesian Optimization framework.
7. 📌 Finally, GPTuner identifies satisfactory knob configurations within resource limits (e.g., the maximum optimization time or iterations specified by users).

## Quick Start
The following instructions have been tested on Ubuntu 20.04 and PostgreSQL v14.9:

1. Install PostgreSQL:
```
sudo apt-get update
sudo apt-get install postgresql-14
```

2. Install BenchBase with our script, which is tested on openjdk version "17.0.8.1" 2023-08-24:
```
cd ./scripts
sh install_benchbase.sh postgres
```

3. Install Benchmark with our script:
Note: modify /GPTuner/benchbase/target/benchbase-postgres/config/postgres/sample_{your_target_benchmark}_config.xml to customize your tuning setting first
```
sh build_benchmark.sh postgres tpch
```

4. Install dependencies:
```
sudo pip install -r requirements.txt
```

5. Execute the GPTuner to optimize your DBMS:
Note: modify configs/postgres.ini to determine the target DBMS first
```
# PYTHONPATH=src python src/run_gptuner.py <dbms> <benchmark> <timeout> <seed>
PYTHONPATH=src python src/run_gptuner.py postgres tpch 180 -seed=100
```
where `<dbms>` is the target DBMS (e.g., postgres or mysql), `<benchmark>` is the target workload (e.g., tpch or tpcc), `<timeout>` is the maximum time allowed to stress test the benchmark, `<seed>` is the random seed used by the optimizer.

## Code Structure
- `configs/`
  - `postgres.ini`: Configuration file to optimize PostgreSQL
  - `mysql.ini`: Configuration file to optimize MySQL
- `optimization_results/`
  - `temp_results/`: Temporary storage for optimization results
  - `postgres/`
    - `coarse/`: Coarse-stage optimization results for PostgreSQL
    - `fine/`: Fine-stage optimization results for PostgreSQL
- `scripts/`
  - `install_benbase.sh`: Script to install the BenchBase benchmark tool
  - `build_benchmark.sh`: Script to build benchmark environments
  - `recover_postgres.sh`: Script to recover the state of PostgreSQL database
  - `recover_mysql.sh`: Script to recover the state of MySQL database
- `knowledge_collection/`
  - `postgres/`
    - `target_knobs.txt`: List of target knobs for PostgreSQL tuning
    - `knob_info/`
      - `system_view.json`: Information from PostgreSQL system views (pg_settings)
      - `official_document.json`: Information from PostgreSQL official documentation
    - `knowledge_sources/`
      - `gpt/`: Knowledge sourced from GPT models
      - `manual/`: Knowledge from DBMS manuals
      - `web/`: Knowledge extracted from web sources
      - `dba/`: Knowledge from database administrators
    - `tuning_lake/`: Data lake for DBMS tuning knowledge
    - `structured_knowledge/`
      - `special/`: Specialized structured knowledge
      - `normal/`: General structured knowledge
- `example_pool/`: Pool of examples for prompt ensemble algorithm
- `src/`
  - `dbms/`
    - `dbms_template.py`: Template for database management systems
    - `postgres.py`: Implementation for PostgreSQL
    - `mysql.py`: Implementation for MySQL
  - `knowledge_handler/`
    - `knowledge_preparation.py`: Module for knowledge preparation (**Sec. 5.1**)
    - `knowledge_transformation.py`: Module for knowledge transformation (**Sec. 5.2**)
  - `space_optimizer/`
    - `knob_selection.py`: Module for knob selection (**Sec. 6.1**)
    - `default_space.py`: Definition of default search space
    - `coarse_space.py`: Definition of coarse search space (**Sec. 6.2**)
    - `fine_space.py`: Definition of fine search space (**Sec. 6.2**)
  - `config_recommender/`
    - `workload_runner.py`: Module to run workloads
    - `coarse_stage.py`: Recommender for coarse stage configuration (**Sec. 7**)
    - `fine_stage.py`: Recommender for fine stage configuration (**Sec. 7**)
  - `run_gptuner.py`: Main script to run GPTuner