FROM python:3.9-slim

RUN apt-get update -y \
&& apt-get install -y --no-install-recommends \
    git \
    redis-server \
&& apt-get clean autoclean \
&& rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Expose 8888 for Jupyter Lab
EXPOSE 8888

WORKDIR /analysis
