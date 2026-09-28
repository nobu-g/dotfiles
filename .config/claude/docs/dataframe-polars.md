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
- Comment a transformation only when it relies on a non-obvious invariant or data assumption, such as an expected join cardinality (see `Comments` in `coding-principles.md`).

## Examples

### Lazy Scan and Filter

```python
import polars as pl

lf = pl.scan_parquet("data/raw/events.parquet")

result = (
    lf.filter(pl.col("event_date") >= "2024-01-01")
    .select(["user_id", "event_type", "event_date"])
    .collect()
)
```

### Group By and Aggregation

```python
summary = (
    lf.group_by("user_id")
    .agg(
        pl.col("event_type").count().alias("event_count"),
        pl.col("event_date").max().alias("last_event"),
    )
    .collect()
)
```

### Join with Cardinality Validation

```python
orders = pl.scan_parquet("data/processed/orders.parquet")
users = pl.scan_parquet("data/processed/users.parquet")

# Each order has at most one matching user, so the join must not fan out.
order_count = orders.select(pl.len()).collect().item()
joined = orders.join(
    users,
    on="user_id",
    how="left",
    validate="m:1",
).collect()

assert joined.height == order_count, "join changed the number of orders"
```
