Semester 1---Project 1

# UCI-Retail-ETL-Pipeline
End-to-end Retail ETL Pipeline using PySpark , Pandas  and Microsoft SQL Server and Engine. UCI Online Retail dataset is a transaction dataset hosted in the UCI Machine Learning Repository that records orders for a UK-based online store selling unique all-occasion gifts, including many wholesale buyers.

----------Scalable Multi-Engine ETL Pipeline: UCI Online Retail Dataset----------
An enterprise-grade, dual-implementation Extract, Transform, Load (ETL) pipeline built to process over 541,000+ transactional records from the UCI Online Retail repository. This project explores data engineering best practices using both single-node memory processing (Pandas) and distributed big data computing (PySpark), ensuring robust data hygiene, anomaly isolation, and accurate revenue attribution

-----------Project Architecture & Stages----------
The pipeline follows a rigorous, multi-stage engineering lifecycle designed to handle messy real-world data without sacrificing critical business context.

Stage 1: Ingestion & Environment Setup
●	What we did: Configured cloud execution environments (Google Colab) to ingest raw CSV data streams. We established secure file-handling mechanisms, validated directory structures using operating system libraries (os), and initialized distributed compute clusters (SparkSession with local multi-core scaling).
●	Engineering focus: Ensuring seamless ingestion and schema enforcement (inferSchema=True) to map types correctly from the start.

Stage 2: Exploratory Data Analysis (EDA) & Profiling
●	What we did: Performed structural audits on all 541,909 records across 8 core attributes. We analyzed memory footprints, generated statistical distributions (quantiles, means, and standard deviations for Quantity and UnitPrice), and mapped out null-value distributions across columns like CustomerID and Description.
●	Engineering focus: Profiling dataset boundaries to anticipate anomalies before executing transformations.

Stage 3: Anomaly Detection & Safe Isolation
●	What we did: Instead of executing destructive deletions, we intelligently isolated edge cases into distinct data subsets:
○	Cancellations: Filtered out 9,288 invoice records prefixed with "C".
○	Returns: Isolated 10,624 transactions carrying negative quantities.
○	Pricing Anomalies: Extracted 2,517 records with zero or negative unit prices.
●	Engineering focus: Preserving downstream business value (e.g., studying customer return behaviors rather than deleting them).

Stage 4: Cleaning & Data Transformation
●	What we did: Built clean working references (df_clean / df_sales) by removing 5,268 exact duplicate rows. We cast string-based invoice dates into proper timestamp objects (datetime64[ns] / to_timestamp) and engineered a high-precision revenue metric (TotalSales = Quantity \times UnitPrice).
●	Engineering focus: Ensuring data immutability and maintaining clean state lineages throughout transformation graphs

Stage 5: Rigorous Validation & Quality Assurance
●	What we did: Implemented defensive assertion checks post-transformation. We verified that negative quantities, invalid prices, and duplicate rows were completely eradicated from the active sales stream while handling missing CustomerID attributes gracefully (retaining transactions for aggregate sales reporting while dropping records missing essential transactional keys like InvoiceNo or StockCode).
●	Engineering focus: Guaranteeing 100% data integrity before target loading.

Stage 6: Aggregation & Export
●	What we did: Computed high-level business intelligence metrics, including total corporate revenue (\approx \$10.64\text{ million}) and country-wise/monthly revenue breakdowns (identifying top-performing markets like the UK and Netherlands). Finally, we exported the validated dataset into clean CSV artifacts ready for data warehouse ingestion (e.g., Oracle Database).
●	Engineering focus: Delivering actionable insights alongside clean data assets.

---------Reflections & Engineering Insights---------
●	One thing I learnt: The critical difference between destructive cleaning and strategic isolation. Automatically dropping negative quantities or cancellations destroys valuable signals regarding product returns and customer friction. True engineering preserves these anomalies in separate partitions.

●	One thing I improved: My ability to manage state and logic across two completely different computational paradigms—shifting from Pandas' eager, in-memory execution model to PySpark's lazy evaluation and immutable DataFrame transformations.

●	One question it gave to me: When scaling this pipeline to handle real-time, streaming transaction data (millions of events per second), how can we optimize watermark thresholds and windowed aggregations in Spark Structured Streaming to handle late-arriving returns without delaying critical daily revenue dashboards?
