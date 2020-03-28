#!/usr/bin/env bash

# First install Java 8 (this works on Ubuntu)
sudo apt update
sudo apt install openjdk-8-jdk

# Now Java is installed, so we can install Spark
cd /tmp
curl -O https://downloads.apache.org/spark/spark-2.4.5/spark-2.4.5-bin-hadoop2.7.tgz
tar -xzf spark-2.4.5-bin-hadoop2.7.tgz
sudo mv spark-2.4.5-bin-hadoop2.7 /usr/local/

# Create a symbolic link:
sudo rm -f /usr/local/spark
sudo ln -s /usr/local/spark-2.4.5-bin-hadoop2.7 /usr/local/spark