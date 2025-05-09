#!/bin/bash
# Usage
# bash log_diff.sh "Refactored module imports"

# Set index file path
INDEX_FILE=".log_index"

# Read current i or default to 1
if [[ -f $INDEX_FILE ]]; then
  i=$(<"$INDEX_FILE")
else
  i=1
fi

# Compute previous index
prev=$((i - 1))

# Create log file path
log_file="../log-$i.txt"
prev_log_file="../log-$prev.txt"

# Read comment from argument
comment="$1"

# Write comment to log file
echo "# $comment" > "$log_file"

# Append find output
find . \( -name "*.d.ts" -o -name "*.js" \) >> "$log_file"

# Show diff if previous log exists
if [[ -f $prev_log_file ]]; then
  echo "=== Diff from log-$prev.txt to log-$i.txt ==="
  diff "$prev_log_file" "$log_file"
else
  echo "No previous log to diff with."
fi

# Increment and save next index
echo $((i + 1)) > "$INDEX_FILE"
