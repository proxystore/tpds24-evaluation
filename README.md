# SC24 ProxyStore Analysis

Data, analysis, and figures for the SC24 ProxyStore paper.

## Get Started

This repository requires Python 3.9, 3.10, or 3.11. To get started running
the analysis notebooks, create a new virtual environment, install the
dependencies, and launch Jupyter Lab.
```bash
python -m venv venv
. venv/bin/activate
pip install -r requirements.txt
jupyter-lab
```
Note: this does not install ProxyStore or the benchmark suite because those
have heavier dependencies not needed for analysis. We suggest creating a
different virtual environment when running benchmarks.

## TODOs

*After acceptance:*
- [ ] Make repo public
- [ ] Enable pre-commit CI
- [ ] Freeze version dependencies (including proxystore/psbench)
- [ ] Improve documentation
