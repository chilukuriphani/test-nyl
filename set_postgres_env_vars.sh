#!/bin/bash
SECRET_ID=$1
if [ -z "$SECRET_ID" ] ; then
    echo "ERROR: Please Pass the SECRET_ID argument for PostGres."
    exit 1
fi

# Get the secret values from the secret
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id "$SECRET_ID")

# Parse the JSON output to extract the username and password
DB_HOST=$(echo "$SECRET_JSON" | jq -r '.SecretString | fromjson | .host')
DB_USERNAME=$(echo "$SECRET_JSON" | jq -r '.SecretString | fromjson | .username')
DB_PASSWORD=$(echo "$SECRET_JSON" | jq -r '.SecretString | fromjson | .password')
DB_PORT=$(echo "$SECRET_JSON" | jq -r '.SecretString | fromjson | .port')
DB_DATABASE=$(echo "$SECRET_JSON" | jq -r '.SecretString | fromjson | .db_name')

# Set environment variables
export PGHOST="$DB_HOST"
export PGPORT="$DB_PORT"
export PGDATABASE="$DB_DATABASE"
export PGUSER="$DB_USERNAME"
export PGPASSWORD="$DB_PASSWORD"

# Print environment variables for verification
echo "PGUSER: $PGUSER"
echo "PGPASSWORD: ***"
echo "PGHOST: $PGHOST"
echo "PGPORT: $PGPORT"
echo "PGDATABASE: $PGDATABASE"
