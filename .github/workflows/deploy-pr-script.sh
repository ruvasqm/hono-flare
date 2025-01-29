#! /usr/bin/env sh
SECTION="env.$PR_NUMBER"
D1_SECTION="env.$PR_NUMBER.d1_databases"
echo "$D1_SECTION"
grep -q "^\[$SECTION\]$" wrangler.toml || {
  printf "\n[%s]" "$SECTION" >>wrangler.toml
  printf "\nworkers_dev = true" >>wrangler.toml
}
grep -q "^\[\[$D1_SECTION\]\]" wrangler.toml || {
  bunx wrangler d1 create "db-$PR_NUMBER" | tail -n 5 | sed "s/^\\[\\[d1_databases\\]\\]/\\[\\[$D1_SECTION\\]\\]/" >>wrangler.toml
}
cat wrangler.toml
