#!/bin/bash

SYSTEM=polaris

PORT=59465
redis-server --port $PORT --save "" --appendonly no --client-output-buffer-limit "pubsub 32GB 32GB 1" &> /dev/null &
REDIS=$!
echo "Redis started on port $PORT."

ARGS="--executor parsl --parsl-executor htex-local "
ARGS+="--stream redis --stream-servers localhost:$PORT "
ARGS+="--ps-connector redis --ps-host localhost --ps-port $PORT "
ARGS+="--stream-method default proxy "
ARGS+="--data-size-bytes 10000 100000 1000000 10000000 "
ARGS+="--task-sleep 1.0 "
ARGS+="--repeat 1 "
ARGS+="--run-dir data/$SYSTEM/1-stream-scaling "

echo "Using args: $ARGS"

for WORKERS in 2 4 8 16 32
do
    task_count=$(( 16*WORKERS ))
    python -m psbench.run.stream_scaling $ARGS \
        --parsl-max-workers $WORKERS --task-count $task_count
done

kill $REDIS
echo "Stopped Redis."
echo "Done."
