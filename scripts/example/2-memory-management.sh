#!/bin/bash

SYSTEM=$(hostname)

PORT=59465
# Increase proto-max-bulk-len if needed
redis-server --port $PORT --save "" --appendonly no &> /dev/null &
REDIS=$!
echo "Redis started on port $PORT."

ARGS="--executor dask --dask-workers 8 "
ARGS+="--ps-connector redis --ps-host localhost --ps-port $PORT "
ARGS+="--stage-sizes 1 1 8 1 1 8 1 1 "
ARGS+="--data-sizes-bytes 100000000 "
ARGS+="--task-sleep 5.0 "
ARGS+="--repeat 3 "
ARGS+="--run-dir data/$SYSTEM/2-memory-management "

echo "Using args: $ARGS"

python -m psbench.run.workflow_memory $ARGS --data-management manual-proxy
python -m psbench.run.workflow_memory $ARGS --data-management owned-proxy
# We run the default-proxy last because it will leave data in the redis
# server and we don't want that to throw off the memory usage for the
# prior runs.
python -m psbench.run.workflow_memory $ARGS --data-management default-proxy

kill $REDIS
echo "Stopped Redis."
echo "Done."
