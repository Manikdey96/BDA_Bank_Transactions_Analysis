#!/bin/bash
awk -F'\t' '{
  if ($1 == prev) { sum += $2 }
  else { if (prev != "") print prev"\t"sum; prev = $1; sum = $2 }
}
END { if (prev != "") print prev"\t"sum }'
