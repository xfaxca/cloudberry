#!/bin/bash
# App-specific system/node settings required for certain apps. 

# Elasticsearch
# bm.max_map_count must be higher than default. 
echo 'vm.max_map_count = 262144' | sudo tee -a /etc/sysctl.conf
