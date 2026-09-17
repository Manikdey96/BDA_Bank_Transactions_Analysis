#!/bin/bash
awk -F',' 'NR==1 {next} {print $11"\t"$9",1"}'
