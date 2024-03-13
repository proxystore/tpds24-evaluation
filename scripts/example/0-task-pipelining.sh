#!/bin/bash

SYSTEM=$(hostname)

PORT=59465
redis-server --port $PORT --save "" --appendonly no &> /dev/null &
REDIS=$!
echo "Redis started on port $PORT."

ARGS="--executor dask --dask-workers 2 "
ARGS+="--ps-connector redis --ps-host localhost --ps-port $PORT "
ARGS+="--submission-method sequential-no-proxy sequential-proxy pipelined-proxy-future "
ARGS+="--task-chain-length 8 "
ARGS+="--task-data-bytes 10000000 "
ARGS+="--task-overhead-fractions 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 "
ARGS+="--task-sleep 1 "
ARGS+="--repeat 5 "
ARGS+="--run-dir data/$SYSTEM/0-task-pipelining "

echo "Using args: $ARGS"

python -m psbench.run.task_pipelining $ARGS

kill $REDIS
echo "Stopped Redis."
echo "Done."
