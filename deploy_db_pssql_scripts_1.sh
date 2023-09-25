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
#while IFS= read -r sql_script || [ -n "$sql_script" ];
SQL_SCRIPT_FILE=$(cat sqldeploy.txt)
for sql_script in $SQL_SCRIPT_FILE
do
   
	echo -e "\n URL:$PG_SERVER_URL USER:$PG_USER SQL Script: $sql_script "
#	line=$
    if [ ! -f "$sql_script" ]; then
        echo -e "ERROR: Script file '$sql_script' not found."
        continue
    fi
    
done 

