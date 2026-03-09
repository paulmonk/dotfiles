---
paths: **/*.sql
---

# SQL

## Tooling

| Purpose | Tool              |
| ------- | ----------------- |
| Lint    | `sqlfluff lint`   |
| Format  | `sqlfluff format` |

## General Best Practices

- **Readability over brevity:** Optimise for readability,
  maintainability, and robustness rather than fewer lines.
  Newlines are cheap; people's time is expensive.
- **Query size:** Avoid enormous `select` statements.
  Refactor into multiple smaller CTEs that are later joined
  back together.
- **Identifiers:** Use lowercase `snake_case` for aliases
  and CTE names. Never use reserved words as identifiers.

## Syntax

- **Keywords:** Use lowercase for all keywords and function
  names (`select`, `from`, `count`).
- **Inequality:** Use `!=` instead of `<>` (reads like
  "not equal").
- **Concatenation:** Use `||` instead of `concat` (standard
  SQL, more portable).
- **Null handling:** Use `coalesce` instead of
  `ifnull`/`nvl`. Use `is null`/`is not null` instead of
  `isnull`/`notnull`. For nullable column comparisons, use
  `is [not] distinct from` instead of verbose `case` logic
  (SQL:2023, widely supported).
- **Conditionals:** Use `case` statements instead of
  `iff`/`if` for portability.
- **Aliasing:** Always use the `as` keyword when aliasing
  columns, expressions, and tables.
- **Aggregates:** Always alias grouping aggregates and other
  column expressions.
- **Filtering:** Use `where` instead of `having` when either
  would suffice (better performance). Use `qualify` to filter
  on window function results directly, avoiding a CTE wrapper
  (BigQuery, Databricks, DuckDB, Snowflake, ClickHouse).
- **Unions:** Use `union all` instead of `union` unless
  duplicates must be removed.
- **Distinct:** Use `select distinct` instead of grouping by
  all columns to make intent clear.
- **Ordering:** Avoid `order by` unless necessary for
  correct results; let consumers sort if needed.
- **Date parts:** Specify date parts as strings, not
  keywords (`date_trunc('month', created_at)`).
- **Comments:** Always use `/* */` syntax. For multi-line,
  keep `/*` with first text and `*/` with last text, indent
  continuation lines by 4 spaces.
- **Strings:** Use single quotes. Double quotes are for
  identifiers in most dialects.
- **Selective aggregation:** Use `filter (where ...)` on
  aggregate functions for conditional aggregates instead of
  `case` inside the aggregate (PostgreSQL, DuckDB, SQLite,
  Databricks).
- **Grouping:** Use `group by all` where supported (DuckDB,
  Databricks, ClickHouse) to avoid repeating non-aggregate
  columns. Use `grouping sets`, `rollup`, or `cube` for
  multi-level aggregation in a single pass instead of
  unioning multiple queries.
- **Pivoting:** Use `pivot`/`unpivot` where supported
  (DuckDB, Databricks, Snowflake, SQL Server, BigQuery)
  instead of manual `case` expressions for transposition.
- **Compound types:** Use native `struct`, `array`, and
  `map` types for nested data where supported (DuckDB,
  BigQuery, Databricks, Snowflake) instead of flattening
  into separate tables or JSON strings.

## Joins

- **No using:** Don't use `using` in joins; use `on` for
  consistency and flexibility.
- **Explicit joins:** Use `inner join` instead of just
  `join`.
- **Join order:** In join conditions, put the table
  referenced first immediately after `on` to clarify
  fan-out potential.
- **Column prefixes:** When joining multiple tables, always
  prefix column names with the table name/alias.
- **Filter placement:** For inner joins, put filter
  conditions in `where`, not the `join` clause.
- **Semi/anti joins:** Where supported (DuckDB, ClickHouse),
  prefer explicit `semi join` / `anti join` over
  `where exists` / `where not exists` subqueries.
- **ASOF joins:** For time-series "closest match" joins
  (e.g. matching to the most recent exchange rate), use
  `asof join` where supported (DuckDB, Snowflake,
  ClickHouse). Syntax varies by platform.
- **Lateral joins:** Use `lateral` (or `cross apply` /
  `outer apply` on SQL Server) for correlated subqueries
  in the `from` clause. Powerful but can degrade
  performance; use with caution.

```sql
/* Good */
select
    customers.email
    , orders.invoice_number
from customers
inner join orders on customers.id = orders.customer_id
where orders.total_amount >= 100

/* Bad */
select email, invoice_number
from customers
join orders on customers.id = orders.customer_id
    and orders.total_amount >= 100
```

## Performance

The below applies to distributed OLAP engines (BigQuery,
Databricks, Snowflake). In-process engines like DuckDB
handle partitioning and join strategies automatically.

### Partitioning

- **Filter on partition columns:** Always include partition
  columns in `where` to avoid full table scans.
- **Use simple predicates:** Partition pruning works with
  `=`, `in`, `between`, `<`, `>`. Avoid functions on
  partition columns.
- **Filter early:** Place partition filters in the earliest
  CTE that references the table.
- BigQuery: Date/timestamp or integer range columns. Max
  4,000 partitions per table.
- Databricks: Delta Lake uses `partitionBy()`. Avoid
  over-partitioning; target files of 1GB each.
- Snowflake: Automatic micro-partitions. Define clustering
  keys to guide organisation.

### Clustering

- **Filter on cluster columns:** Clustered columns enable
  block/micro-partition pruning.
- **Column order matters:** Filter on cluster columns in
  their defined order (leftmost first).
- BigQuery: Up to 4 columns. Effective on
  tables/partitions over 64MB.
- Databricks: Use `OPTIMIZE ... ZORDER BY` for
  multi-dimensional clustering. Liquid clustering
  (`CLUSTER BY`) auto-maintains. Use `bucketBy()` for
  join/filter column co-location.
- Snowflake: Up to 4 columns recommended. Check depth with
  `SYSTEM$CLUSTERING_INFORMATION`.

### Join Strategies (Distributed Engines)

- **Broadcast joins:** Small table replicated to all nodes.
  Avoids shuffle. Best under 10MB (Spark default threshold).
- **Shuffle/hash joins:** Both sides redistributed by join
  key. Required for large-large joins.
- **Sort-merge joins:** Both sides sorted, then merged.
  Efficient when pre-sorted.
- **Collocated joins:** Tables partitioned on join key can
  join locally without shuffle.
- **Avoid skew:** Highly skewed join keys cause hot spots.
  Consider pre-aggregating or salting.
- Databricks: Spark hints `/*+ BROADCAST(t) */`,
  `/*+ MERGE(t) */`, `/*+ SHUFFLE_HASH(t) */`. Priority:
  broadcast > merge > shuffle_hash. Adaptive Query
  Execution (AQE) auto-optimises at runtime.
- Snowflake: No hints. Ensure join columns have matching
  data types.

```sql
/* Databricks: broadcast small dimension table */
select /*+ BROADCAST(regions) */
    orders.id
    , regions.name
from orders
inner join regions on orders.region_id = regions.id
```

## CTEs

- **Single purpose:** CTEs should perform a single, logical
  unit of work.
- **Naming:** Use verbose names that convey purpose. Don't
  prefix/suffix with `cte`.
- **Documentation:** Comment CTEs with confusing or notable
  logic.
- **Prefer CTEs:** Use CTEs rather than subqueries for
  readability and reusability.
- **Recursive CTEs:** Use `with recursive` for hierarchical
  or graph traversal queries (org charts, bill of materials,
  category trees). Always include a depth limit or
  termination condition to prevent infinite loops.

```sql
/* Good */
with
    paying_customers as (
        select
            id
            , email
            , plan_name
        from customers
        where plan_name != 'free'
    )

select ...
from paying_customers

/* Bad */
select ...
from (
    select id, email, plan_name
    from customers
    where plan_name != 'free'
) as paying_customers
```

## Naming

- **Primary keys:** Name single-column primary keys `id`
  for clarity in joins.
- **Dates (UTC):** `<event>_date` for dates, `<event>_at`
  for timestamps.
- **Dates (timezone):** Suffix with timezone indicator
  (`order_date_et`, `created_at_pt`).
- **Booleans:** Prefix with verb (`is_`, `was_`, `has_`,
  `had_`, `does_`, `did_`).
- **Units:** Suffix numeric columns with units (`price_usd`,
  `weight_kg`).
- **Aliases:** Avoid unnecessary aliases, especially
  initialisms. Don't alias tables with 3 words or fewer.

```sql
/* Good */
select
    customers.email
    , orders.invoice_number
from customers
inner join orders on customers.id = orders.customer_id

/* Bad */
select c.email, o.invoice_number
from customers as c
inner join orders as o on c.id = o.customer_id
```

## Formatting

The overarching pattern: if there's only one thing, put it on
the same line as the keyword. If multiple, put each on its own
line indented one level.

- **Alignment:** Left-align everything.
- **Indentation:** Use 4 spaces.
- **Operators:** Never end a line with `and`, `or`, `+`,
  `||`, etc. Put operators at the start of continuation
  lines.
- **Commas:** Use leading commas on continuation lines,
  followed by a space.

### Select Clause

```sql
/* Single column */
select id

/* Multiple columns */
select
    id
    , email

/* With distinct */
select distinct
    state
    , country
```

### From Clause

```sql
/* Single join condition */
from customers
left join orders on customers.id = orders.customer_id

/* Multiple join conditions */
from customers
left join orders on
    customers.id = orders.customer_id
    and customers.region_id = orders.region_id
```

### Where Clause

```sql
/* Single condition */
where email like '%@domain.com'

/* Multiple conditions */
where
    email like '%@domain.com'
    and plan_name != 'free'
```

### Group By and Order By

```sql
/* Prefer group by all where supported */
group by all

/* Otherwise use column names, not numbers */
group by
    plan_name
    , signup_month

/* Column names: single on same line, multiple indented */
order by
    plan_name
    , signup_month
```

### CTE Formatting

```sql
with
    paying_customers as (
        select ...
        from customers
    )

    , paying_customers_per_month as (
        /* CTE comments go here */
        select ...
        from paying_customers
    )

select ...
from paying_customers_per_month
```

### Case Statements

- Single `when` on one line if short enough.
- Multi-line: indent `when`/`else` one level, `end` at same
  level as `case`.
- If after leading comma, align `end` with `case` using two
  extra spaces.

```sql
/* Short form */
select
    case when status_code = 1 then 'Active' else 'Inactive' end as status

/* Long form */
select
    case
        when status_code = 1 then 'Active'
        else 'Inactive'
    end as status
    , case
          when status_code = 1
              and deleted_at is null
              then 'Active'
          else 'Inactive'
      end as detailed_status
```

### Window Functions

```sql
/* Short form */
row_number() over (partition by customer_id order by created_at) as order_rank

/* Long form */
row_number() over (
    partition by customer_id
    order by created_at
  ) as order_rank

/* RANGE frame: value-based bounds (e.g. time intervals) */
avg(temperature) over (
    order by reading_datetime
    range between interval '1 hour' preceding
              and interval '1 hour' following
) as avg_temperature_within_hour

/* EXCLUDE: omit current row from frame */
avg(temperature) over (
    order by reading_datetime
    range between interval '1 hour' preceding
              and interval '1 hour' following
          exclude current row
) as avg_excluding_current

/* Named window: reuse the same definition across columns */
select
    reading_datetime
    , min(temperature) over hourly as min_temp
    , avg(temperature) over hourly as avg_temp
    , max(temperature) over hourly as max_temp
from readings
window hourly as (
    order by reading_datetime
    range between interval '1 hour' preceding
              and interval '1 hour' following
)
```

### Qualify and Filter

```sql
/* QUALIFY: filter on window results without a CTE */
select *
from customers
qualify 1 = row_number() over (
    partition by customer_id
    order by updated_at desc
)

/* FILTER: conditional aggregation without case */
select
    count(*) as total_orders
    , count(*) filter (where status = 'shipped') as shipped_orders
    , sum(amount) filter (where status = 'refunded') as refunded_amount
from orders
```

### In Lists

```sql
/* Break long lists */
where email in (
    'user-1@example.com'
    , 'user-2@example.com'
    , 'user-3@example.com'
)
```

### Parentheses

- Don't put extra spaces inside parentheses.

```sql
/* Good */
where plan_name in ('monthly', 'yearly')

/* Bad */
where plan_name in ( 'monthly', 'yearly' )
```
