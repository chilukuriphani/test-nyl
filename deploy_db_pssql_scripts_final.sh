#!/bin/bash

# Define PostgreSQL server details
PG_SERVER_URL="$PG_SERVER_URL"   # Environment variable for PostgreSQL server URL
PG_USER="$PG_USER"               # Environment variable for PostgreSQL username
PG_PASSWORD="$PG_PASSWORD"       # Environment variable for PostgreSQL password

PG_SERVER_URL=$1
PG_USER=$2
PG_PASSWORD=$3

# Check if required environment variables are set
if [ -z "$PG_SERVER_URL" ] || [ -z "$PG_USER" ] || [ -z "$PG_PASSWORD" ]; then
    echo "ERROR: Please set PG_SERVER_URL, PG_USER, and PG_PASSWORD environment variables."
    exit 1
fi

# File containing sequential SQL scripts
SQL_SCRIPT_FILE="sqldeploy.txt"

# Check if the SQL script file exists
if [ ! -f "$SQL_SCRIPT_FILE" ]; then
    echo "ERROR: SQL script file '$SQL_SCRIPT_FILE' not found."
    exit 1
fi

# Read and execute SQL scripts from the file
while IFS= read -r sql_script || [ -n "$sql_script" ];
do
    # Check if the script file exists
    if [ ! -f "$sql_script" ]; then
        echo -e "ERROR: Script file '$sql_script' not found."
        continue
    fi

    # Execute the SQL script using psql

    echo "/n executing $sql_script script on $PG_SERVER_URL using $PG_USER USER"
    psql -h "$PG_SERVER_URL" -U "$PG_USER" -d "$PG_USER" -a -f "$sql_script" <<-EOF
        $PG_PASSWORD
        EOF
    # Check the exit status of psql
    if [ $? -eq 0 ]; then
        echo -e "Script '$sql_script' executed successfully."
    else
        echo -e "ERROR: Script '$sql_script' failed to execute."
    fi
done < "$SQL_SCRIPT_FILE"