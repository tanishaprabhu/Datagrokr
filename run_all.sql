\set ON_ERROR_STOP on
\echo '1/6 - Schema'
\i sql/01_schema.sql
\echo '2/6 - Bulk load'
\i sql/02_bulk_load.sql
\echo '3/6 - Merge day-1 customers'
\i sql/03_merge_dimension.sql
\echo '4/6 - Load facts'
\i sql/04_load_fact.sql
\echo '5/6 - Create indexes'
\i sql/05_indexes.sql
\echo '6/6 - Explain plans and business query'
\i sql/06_queries_explain.sql
\echo 'Day 1 complete. Run: psql -d de_pipeline -f sql/07_day2_incremental.sql'
