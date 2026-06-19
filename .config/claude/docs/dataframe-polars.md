# DataFrame Operations with Polars

Standards for DataFrame operations: loading, filtering, joining, aggregating, transforming, and reshaping.

## Default: Polars

- Prefer **polars** for all DataFrame work.
- Prefer **LazyFrame** for loading, filtering, joins, aggregations, and transformations.
- Use eager execution when simpler and data is small.

## Pandas: Only When Required

- Use pandas **only** when required by an existing dependency, external library, or legacy code.
- If pandas is needed, keep its usage minimal and convert back to polars as soon as practical.

## Transformations

- Transformations should be reproducible and scriptable.
- Avoid manual, spreadsheet-like edits.
- Document data transformations with comments (written in English).

## Examples

### Lazy Scan and Filter

```python
import polars as pl

# Lazily scan the Parquet file
lf = pl.scan_parquet("data/raw/events.parquet")

# Filter by date and select columns
result = (
    lf.filter(pl.col("event_date") >= "2024-01-01")
    .select(["user_id", "event_type", "event_date"])
    .collect()
)
```

### Group By and Aggregation

```python
# Aggregate the event count per user
summary = (
    lf.group_by("user_id")
    .agg(
        pl.col("event_type").count().alias("event_count"),
        pl.col("event_date").max().alias("last_event"),
    )
    .collect()
)
```

### Safe Join with Row Count Check

```python
left = pl.scan_parquet("data/processed/users.parquet")
right = pl.scan_parquet("data/processed/orders.parquet")

# Check row counts before the join
left_count = left.select(pl.len()).collect().item()
right_count = right.select(pl.len()).collect().item()

joined = left.join(right, on="user_id", how="left").collect()

# Check the row count after the join (detect fan-out)
assert joined.height >= left_count, "rows were lost during the join"
print(f"left={left_count}, right={right_count}, joined={joined.height}")
```
