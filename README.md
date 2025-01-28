# Set up project

1. `bun create hono project-name`. Select `cludflare-workers` template
2. `bun run wrangler d1 migrations create <db-name> <migration-description>`

# Github Actions 

1. [Create cloudflare api token](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/)
2. Get [account ID](https://developers.cloudflare.com/fundamentals/setup/find-account-and-zone-ids/)
3. Create Github deploy action 

```yaml
name: Deploy Worker
on:
  push:
    tags:
      - 'v[0-9]+.[0-9]+.[0-9]+'
jobs:
  deploy:
    runs-on: ubuntu-latest
    timeout-minutes: 60
    #needs: test
    steps:
      - uses: actions/checkout@v4
      - name: Build & Deploy Worker
        uses: cloudflare/wrangler-action@v3
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          environment: production
          postCommands: |
            wrangler d1 migrations apply -e=production --remote
    #test:
    # test job
```

4. Create PR preview
    
```yaml
name: Deploy Worker
on:
  pull_request:
    branches:
      - main
jobs:
  deploy:
    runs-on: ubuntu-latest
    timeout-minutes: 60
    needs: test
    steps:
      - uses: actions/checkout@v4
      - name: Build & Deploy Worker
        uses: cloudflare/wrangler-action@v3
        env:
            PR_NUMBER: pr-${{ github.event.number }}
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          environment: pr-${{ github.event.number }}
          preCommands: |
            echo "\n[env.pr-$PR_NUMBER]" >> wrangler.toml 
            echo "\nworkers_dev = true" >> wrangler.toml
            wrangler d1 create "db-$PR_NUMBER" |  tail -n 5 | sed "s/^\\[\\[d1_databases\\]\\]/\\[\\[env.$PR_NUMBER.d1_databases\\]\\]/" >> wrangler.toml
          postCommands: |
            wrangler d1 migrations apply -e="$pr-PR_NUMBER" --remote
  test:
    # test job
```

5. Delete PR preview
```yaml
on:
  pull_request:
    branches:
      - main
    types:
      - closed

jobs:
  cleanup:
    if: github.event.pull_request.merged == true
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Delete db and destroy worker
        uses: cloudflare/wrangler-action@v3
        env:
            PR_NUMBER: pr-${{ github.event.number }}
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          environment:  pr-${{ github.event.number }}
          command: |
            delete -e $PR_NUMBER
            d1 delete "db-$PR_NUMBER" -y

```
