CREATE TABLE jobs (
  id          INTEGER UNIQUE PRIMARY KEY,
  printer     TEXT NOT NULL,
  uniqname    TEXT NOT NULL,
  job_id      INTEGER NOT NULL,
  num_copies  INTEGER NOT NULL,
  page_number INTEGER NOT NULL,
  job_billing INTEGER NOT NULL,
  host_name   TEXT NOT NULL,
  printed_at  INTEGER NOT NULL,

  unique(printer, uniqname, job_id)
);

CREATE INDEX printer on jobs (printer);
CREATE INDEX uniqname on jobs (uniqname);
