#!/usr/bin/env bash

# First install Java 8 (this works on Ubuntu)
sudo apt update
sudo apt install openjdk-8-jdk

# Now Java is installed, so we can install Spark
cd /tmp
curl -O https://www.mirrorservice.org/sites/ftp.apache.org/spark/spark-3.0.0/spark-3.0.0-bin-hadoop2.7.tgz
tar -xzf spark-3.0.0-bin-hadoop2.7.tgz
sudo mv spark-3.0.0-bin-hadoop2.7 /usr/local/

# Create a symbolic link:
sudo rm -f /usr/local/spark
sudo ln -s /usr/local/spark-3.0.0-bin-hadoop2.7 /usr/local/spark