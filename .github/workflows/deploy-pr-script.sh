#! /usr/bin/env sh
SECTION="env.$PR_NUMBER"
grep -q "^\[$SECTION\]$" wrangler.toml || {
  {
    printf "\n[%s]" "$SECTION"
    printf "\nworkers_dev = true"
  } >>wrangler.toml
  bunx wrangler d1 create "db-$PR_NUMBER" | tail -n 5 | sed "s/^\\[\\[d1_databases\\]\\]/\\[\\[$D1_SECTION\\]\\]/" >>wrangler.toml
}
cat wrangler.toml
