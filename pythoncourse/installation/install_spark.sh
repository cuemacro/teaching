#!/usr/bin/env bash

# Assumes we already have Java installed
cd /tmp
curl -O http://apache.mirrors.tds.net/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz
tar -xzf spark-2.4.3-bin-hadoop2.7.tgz
sudo mv spark-2.4.3-bin-hadoop2.7 /usr/local/

# Create a symbolic link:
sudo ln -s /usr/local/spark-2.4.3-bin-hadoop2.7 /usr/local/spark