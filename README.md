# UCI Online Retail: Multi-Engine ETL Pipeline

End-to-end ETL pipeline that processes 541,909 transactions from the UCI Online Retail dataset using **Pandas** and **PySpark**, and loads the cleaned data into **Microsoft SQL Server**.

**Dataset:** [UCI Online Retail](https://archive.ics.uci.edu/dataset/352/online+retail), transactions of a UK-based online gift store (many wholesale customers).

## Tech Stack

| Layer | Tools |
|---|---|
| Processing | Python, Pandas, PySpark |
| Storage | Microsoft SQL Server |
| Environment | Google Colab, Git LFS |

## Architecture

## Repository Structure

## Pipeline Stages

1. **Ingestion:** Load raw CSV, initialize a local Spark session, enforce schema.
2. **EDA and profiling:** Audit all 541,909 records across 8 columns, check distributions of `Quantity` and `UnitPrice`, map nulls (`CustomerID`, `Description`).
3. **Anomaly isolation:** Edge cases are separated, not deleted, so they can be analyzed later.
   - Cancellations (invoice starts with "C"): 9,288 rows
   - Returns (negative quantity): 10,624 rows
   - Pricing anomalies (zero or negative `UnitPrice`): 2,517 rows
4. **Cleaning and transformation:** Remove 5,268 exact duplicates, cast `InvoiceDate` to timestamp, create `TotalSales = Quantity x UnitPrice`.
5. **Validation:** Assertions confirm no negative quantities, invalid prices or duplicates remain in the sales stream. Missing `CustomerID` is kept for aggregate sales; rows missing `InvoiceNo` or `StockCode` are dropped.
6. **Aggregation and export:** Total revenue is about 10.64 million, with country-wise and monthly breakdowns (top markets: UK and Netherlands). Output is exported to CSV and loaded into SQL Server.

## Why Two Engines?

Pandas is eager and in-memory, PySpark is lazy and distributed. Both notebooks apply the same logic, and the two cleaned outputs are **identical** (same file hash), which verifies the transformation logic across engines.

## Data Model

![Database model](Working%20Database%20Model%20of%20pipeline.png)

## How to Run

1. Download `Online Retail.xlsx` from the UCI link above and place it in `data/` (see `data/README.md`).
2. Open a notebook from `Notebooks/` in Google Colab or Jupyter.
3. Run all cells. The cleaned CSV is written as output.
4. Run `SQL/Schema_only.sql` in SQL Server to create the database, then load the cleaned CSV.

Note: the cleaned CSVs are stored with Git LFS. Run `git lfs install` before cloning.

## Key Learnings

- Strategic isolation beats destructive cleaning: returns and cancellations carry business signal.
- Managing the same logic in Pandas (eager) and PySpark (lazy, immutable DataFrames).

## Planned Improvements

- Fix SQL schema (DECIMAL for money, primary key, indexes, no dot in table name)
- Star schema (fact and dimension tables)
- Convert notebooks into a modular `src/` package with config and logging
- Unit tests and CI with GitHub Actions
- Power BI dashboard on the cleaned data
- Azure-based version (ADLS, Data Factory, Databricks)

## License

MIT
