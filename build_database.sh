#!/bin/bash -u

source db_config

: "${DB_HOST:?You must set DB_HOST}"
: "${DB_PORT:?You must set DB_PORT}"
: "${DB_USER:?You must set DB_USER}"
: "${DB_PASSWORD:?You must set DB_PASSWORD}"
: "${DB_NAME:?You must set DB_NAME}"
: "${DB_SCHEMA:?You must set DB_SCHEMA}"
: "${BRACKETS_CODES_TABLE:?You must set BRACKETS_CODES_TABLE name}"
: "${RANKINGS_CODES_TABLE:?You must set RANKINGS_CODES_TABLE name}"
: "${STANDINGS_CODES_TABLE:?You must set STANDINGS_CODES_TABLE name}"

psql postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME -v SCHEMA_NAME=$DB_SCHEMA -f create_tables.sql
echo "Done with creating the db schema"

row_count=`psql -X -A postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME -t -c "select count(*) from $DB_SCHEMA.$BRACKETS_CODES_TABLE"`
if [[ $row_count > 0 ]]
then
    echo "$BRACKETS_CODES_TABLE table is not empty. Deleting and re-populating $BRACKETS_CODES_TABLE table."
    psql -X -A postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME -t -c "delete from $DB_SCHEMA.$BRACKETS_CODES_TABLE"
fi
psql postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME -c "\copy $DB_SCHEMA.$BRACKETS_CODES_TABLE
    (code, code_real, discipline_localization_key, event_localization_key, sub_event_localization_key) from 'brackets_codes.csv' DELIMITER ',' CSV HEADER;"

row_count=`psql -X -A postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME -t -c "select count(*) from $DB_SCHEMA.$RANKINGS_CODES_TABLE"`
if [[ $row_count > 0 ]]
then
    echo "$RANKINGS_CODES_TABLE table is not empty. Deleting and re-populating $RANKINGS_CODES_TABLE table."
    psql -X -A postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME -t -c "delete from $DB_SCHEMA.$RANKINGS_CODES_TABLE"
fi
psql postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME -c "\copy $DB_SCHEMA.$RANKINGS_CODES_TABLE
    (code, code_real, discipline_localization_key, event_localization_key, sub_event_localization_key) from 'rankings_codes.csv' DELIMITER ',' CSV HEADER;"

row_count=`psql -X -A postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME -t -c "select count(*) from $DB_SCHEMA.$STANDINGS_CODES_TABLE"`
if [[ $row_count > 0 ]]
then
    echo "$STANDINGS_CODES_TABLE table is not empty. Deleting and re-populating $STANDINGS_CODES_TABLE table."
    psql -X -A postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME -t -c "delete from $DB_SCHEMA.$STANDINGS_CODES_TABLE"
fi
psql postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME -c "\copy $DB_SCHEMA.$STANDINGS_CODES_TABLE
    (code, code_real, discipline_localization_key, event_localization_key, sub_event_localization_key) from 'standings_codes.csv' DELIMITER ',' CSV HEADER;"


echo "Done with codes table initializations."
