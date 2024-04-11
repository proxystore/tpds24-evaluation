# SC24 ProxyStore Analysis

Data, analysis, and figures for the SC24 ProxyStore paper.

## Get Started

This repository requires Python 3.9, 3.10, or 3.11. To get started running
the benchmarks and analysis notebooks, create a new virtual environment,
install the dependencies, and launch Jupyter Lab.

```bash
python -m venv venv
. venv/bin/activate
pip install -r requirements.txt
jupyter-lab
```

## SC24 Artifacts Appendix

We have provided a Docker image and set of scripts for reproducing the benchmarks in our SC24 submission.

### Install

Build the Docker image which will install the necessary dependencies pinned in the `requirements.txt` file.
```bash
docker build -t sc24-proxystore .
```

### Run Task Pipelining

The `scripts/docker/0-task-pipelining.sh` will execute the experiment with the exact parameters used in the SC24 submission.
Use the following command to execute the experiment in the Docker image.
Completing all of the runs takes 20 minutes and requires 4 cores and 16 GB of memory.

```bash
docker run --rm -it -v $PWD:/analysis sc24-proxystore /bin/bash /analysis/scripts/docker/0-task-pipelining.sh
```

This will produce an output directory in `data/docker/0-task-pipelining/` containing the runtime log (`log.txt`) and results (`result.csv`).

### Run Stream Scaling

The `scripts/docker/1-stream-scaling.sh` will execute the experiment with the exact parameters used in the SC24 submission.
Use the following command to execute the experiment in the Docker image.
Completing all of the runs takes 30 minutes and requires 32 cores and 256 GB of memory.

**Note:** The numbers passed as arguments to the script are the number of workers to perform runs with.
The default below is to run the experiments with 2, 4, 8, 16, and 32 workers.
Modify this list based on how many cores your machine has.

```bash
docker run --rm -it -v $PWD:/analysis sc24-proxystore /bin/bash /analysis/scripts/docker/1-stream-scaling.sh 2 4 8 16 32
```

This will produce an output directory for each run configuration (worker counts) in `data/docker/1-stream-scaling/` containing the runtime log (`log.txt`) and results (`result.csv`).

### Run Memory Management

The `scripts/docker/2-memory-management.sh` will execute the experiment with the exact parameters used in the SC24 submission.
Use the following command to execute the experiment in the Docker image.
Completing all of the runs takes 1 hour and requires 32 cores and 64 GB of memory.

```bash
docker run --rm -it -v $PWD:/analysis sc24-proxystore /bin/bash /analysis/scripts/docker/2-memory-management.sh
```

This will produce four output directories for each of the memory management methods in `data/docker/2-memory-management/`.
Each directory will contain the runtime log (`log.txt`) and results (`result.csv`).

### Analyze Results

A Jupyter Notebook is provided for each experiment to analyze process results and create figures.
The Jupyter Lab server can be started in the Docker container.

```bash
docker run --rm -it -p 8888:8888 -v $PWD:/analysis sc24-proxystore /bin/bash jupyter-lab --ip 0.0.0.0 --no-browser --allow-root
```

The Jupyter Lab can be opened on the local host using the printed link that looks like:
```
http://127.0.0.1:8888/lab?token=<TOKEN>
```

The `notebooks/` directory contains one notebook for each experiment in the SC24 submission.
Open one of `notebooks/0-task-pipelining.ipynb`, `notebooks/1-stream-scaling.ipynb`, and `notebooks/2-memory-management.ipynb` to analyze the data produced by the above experiments.
At the bottom of each notebook is a section called "Analyze Results" containing a `path` variable to the results of the experiment you want to analyze.
Update the `path` variable and run the notebook to produce figures.
