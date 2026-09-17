#!/bin/bash
awk -F',' 'NR==1 {next} {print $8"\t"$5}'
