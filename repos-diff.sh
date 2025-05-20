#!/bin/bash

# --- Config ---
OLD_REPO_PATH="../old-repo"  # Adjust to your old repo location
OLD_COMPONENTS_PATH="$OLD_REPO_PATH/packages/components/src"
NEW_COMPONENTS_PATH="src/components"

# Check if old repo exists
if [ ! -d "$OLD_REPO_PATH/.git" ]; then
  echo "❌ Old repo not found at $OLD_REPO_PATH. Please update the path."
  exit 1
fi

# Go through each component in the new repo
for component_dir in "$NEW_COMPONENTS_PATH"/*; do
  component=$(basename "$component_dir")

  main_file="$NEW_COMPONENTS_PATH/$component/$component.tsx"
  if [ ! -f "$main_file" ]; then
    # Try index.tsx fallback
    main_file="$NEW_COMPONENTS_PATH/$component/index.tsx"
    if [ ! -f "$main_file" ]; then
      echo "⚠️  Skipping $component (no main file found)"
      continue
    fi
  fi

  # Get creation date of main file in new repo
  created_at=$(git log --diff-filter=A --format="%ad" --date=iso -- "$main_file" | tail -1)
  if [ -z "$created_at" ]; then
    echo "⚠️  Skipping $component (could not determine creation date)"
    continue
  fi

  # Check if component exists in old repo
  old_path="$OLD_COMPONENTS_PATH/$component"
  if [ ! -d "$old_path" ]; then
    echo "❌ $component not found in old repo"
    continue
  fi

  echo "🔍 Checking updates for $component since $created_at"

  # Run git log in old repo since creation date
  echo "----------------------------"
  git -C "$OLD_REPO_PATH" log --since="$created_at" --pretty=format:"%C(yellow)%h%Creset %ad %s" --date=short --name-only -- "$old_path" | sed 's/^/   /'
  echo
done
