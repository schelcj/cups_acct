DB="sql/cups_acct.db"
SCHEMA="sql/schema.sql"

rebuild_db:
	@rm -f $(DB)
	@sqlite3 $(DB) < $(SCHEMA)
