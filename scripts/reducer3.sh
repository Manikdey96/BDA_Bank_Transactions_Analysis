#!/bin/bash
awk -F'\t' '{
  split($2, arr, ",")
  val = arr[1]; cnt = arr[2]
  if ($1 == prev) { sum += val; count += cnt }
  else {
    if (prev != "") printf "%s\t%.2f\t%d\t%.2f\n", prev, sum, count, sum/count
    prev = $1; sum = val; count = cnt
  }
}
END { if (prev != "") printf "%s\t%.2f\t%d\t%.2f\n", prev, sum, count, sum/count }'
