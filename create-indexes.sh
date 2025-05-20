#!/bin/bash

COMPONENTS_PATH="src/components"

for component_dir in "$COMPONENTS_PATH"/*; do
  [ -d "$component_dir" ] || continue  # Skip non-directories

  index_file="$component_dir/index.ts"
  if [ -f "$index_file" ]; then
    echo "✅ index.ts already exists in $(basename "$component_dir")"
    continue
  fi

  echo "⚙️  Generating index.ts for $(basename "$component_dir")"

  # Start with an empty index.ts
  echo "// Auto-generated index.ts" > "$index_file"

  # Loop through .ts and .tsx files (except index.ts) and export them
  for file in "$component_dir"/*.ts*; do
    filename=$(basename "$file")
    name_without_ext="${filename%.*}"

    # Skip index.ts or index.tsx
    if [[ "$name_without_ext" == "index" ]]; then
      continue
    fi

    echo "export * from './$name_without_ext';" >> "$index_file"
  done
done
