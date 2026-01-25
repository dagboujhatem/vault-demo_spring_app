#!/bin/bash
set -e

echo "Running Vault Demo (Full Cycle)..."

# Step 0: Infra & Insecure App (we run infra only in background here)
./step0/run.sh & # Running it in background or just start infra?

# Actually, for a demo script, we just want to go through the Vault flow.
# Let's just start infra and wait for it.
docker-compose up -d

./step1/run.sh
./step2/run.sh
./step3/run.sh
./step4/run.sh
