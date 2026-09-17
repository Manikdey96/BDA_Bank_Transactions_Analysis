#!/bin/bash
awk -F',' 'NR==1 {next} {print $4"\t1"}'
