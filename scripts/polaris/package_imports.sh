#!/bin/bash
set -euo pipefail

module load cray-python

pypi_packages=("numpy" "torch" "pynvml" "tensorflow" "pyhf" "scikit-learn" "globus_compute_sdk" "parsl" "pillow" "scipy")
packages=("numpy" "torch" "pynvml" "tensorflow" "pyhf" "sklearn" "globus_compute_sdk" "parsl" "PIL" "scipy")

# https://alphahydrae.com/2021/02/how-to-create-a-temporary-directory-in-a-shell-script/
clean_up() {
  test -d "$tmp_dir" && rm -fr "$tmp_dir"
}

tmp_dir=$( mktemp -d )
trap "clean_up $tmp_dir" EXIT

python -m venv $tmp_dir
. $tmp_dir/bin/activate
pip install ${pypi_packages[@]}

for package in "${packages[@]}"
do
    echo "Running import test for $package"
    repeat=10
    tstart=$(date +%s.%N)
    for i in $(seq $repeat)
    do
        python -m timeit -n 1 -r 1 -u sec "import $package"
    done
    tend=$(date +%s.%N)
    tdiff=$(echo "$tend - $tstart" | bc)
    echo "Total time for $repeat iters: $tdiff"
done
