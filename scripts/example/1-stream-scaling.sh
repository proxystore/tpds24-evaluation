#!/bin/bash

SYSTEM=$(hostname)

PORT=59465
redis-server --port $PORT --save "" --appendonly no --client-output-buffer-limit "pubsub 2048MB 2048MB 1" &> /dev/null &
REDIS=$!
echo "Redis started on port $PORT."

ARGS="--executor parsl --parsl-executor htex-local "
ARGS+="--stream redis --stream-servers localhost:$PORT "
ARGS+="--ps-connector redis --ps-host localhost --ps-port $PORT "
ARGS+="--stream-method default proxy "
ARGS+="--data-size-bytes 100000 1000000 10000000 "
ARGS+="--task-sleep 1.0 "
ARGS+="--repeat 1 "
ARGS+="--run-dir data/$SYSTEM/1-stream-scaling "

echo "Using args: $ARGS"

for WORKERS in 2 4 8 16
do
    task_count=$(( 8*WORKERS ))
    python -m psbench.run.stream_scaling $ARGS \
        --parsl-max-workers $WORKERS --task-count $task_count
done

kill $REDIS
echo "Stopped Redis."
echo "Done."
