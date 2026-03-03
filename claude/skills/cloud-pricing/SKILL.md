---
name: cloud-pricing
description: >-
  This skill should be used when the user asks "how much does X
  cost", "price of", "what does X cost on AWS/Azure/GCP",
  "cheapest region for", "compare cloud costs", "pricing for",
  "cloud rates", "cost comparison", "estimate cost", "monthly
  cost for", or "budget for". Also triggered by questions
  about regional price differences, on-demand vs committed pricing,
  or cross-provider cost comparisons. Covers all services (compute,
  storage, databases, analytics, serverless, etc.) across AWS,
  Azure, and GCP.
---

# Cloud Pricing Lookup

Query cloud provider pricing APIs directly via curl and jq.
All prices are on-demand/pay-as-you-go in USD unless the user
asks otherwise.

## Provider APIs

### AWS Price List API

No authentication required for the Bulk API. The Query API
needs AWS CLI credentials.

**Bulk API (no auth, public HTTP)**

Service index:

```bash
curl -s 'https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/index.json' | jq '.offers | keys[]'
```

Per-service, per-region pricing (large files, use jq to filter):

```bash
curl -s "https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/${SERVICE_CODE}/current/${REGION}/index.json" \
  | jq '.products | to_entries[:5]'
```

Not all services have per-region files. If the URL returns 404,
fall back to the global index:

```bash
curl -s "https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/${SERVICE_CODE}/current/index.json" \
  | jq '.products | to_entries[:5]'
```

Common service codes: `AmazonEC2`, `AmazonS3`, `AmazonRDS`,
`AmazonDynamoDB`, `AWSLambda`, `AmazonAthena`, `AmazonRedshift`,
`AmazonElastiCache`, `AmazonEKS`, `AmazonECS`,
`AmazonCloudFront`, `AmazonKinesis`, `AmazonSageMaker`,
`awskms`, `AmazonRoute53`.

AWS regions use format: `us-east-1`, `eu-west-1`,
`ap-southeast-2`, etc.

**Query API (needs AWS CLI)**

More targeted lookups when AWS CLI is available:

```bash
aws pricing get-products \
  --service-code AmazonRDS \
  --region us-east-1 \
  --filters \
    "Type=TERM_MATCH,Field=databaseEngine,Value=PostgreSQL" \
    "Type=TERM_MATCH,Field=regionCode,Value=ap-southeast-2" \
  | jq '.PriceList[:3] | map(fromjson)'
```

The `--region` here is the API endpoint region (us-east-1 or
ap-south-1), not the product region. Use the `regionCode`
filter for the actual region.

### Azure Retail Prices API

No authentication required. Public REST API with OData filters.

```bash
curl -s 'https://prices.azure.com/api/retail/prices?$filter=serviceName%20eq%20%27SQL%20Database%27%20and%20armRegionName%20eq%20%27uksouth%27' \
  | jq '.Items[:5] | .[] | {serviceName, skuName, armRegionName, retailPrice, unitOfMeasure, productName}'
```

Available OData filters: `serviceName`, `armRegionName`,
`skuName`, `productName`, `meterName`, `serviceFamily`,
`priceType`, `armSkuName`.

Filter values are **case sensitive**. Use exact casing from
the API (e.g. `Virtual Machines`, not `virtual machines`).

Common service names: `Virtual Machines`, `SQL Database`,
`Azure Cosmos DB`, `Storage`, `Azure Synapse Analytics`,
`Azure Databricks`, `Azure Kubernetes Service`,
`Azure Cache for Redis`, `Functions`, `Event Hubs`,
`Azure Monitor`, `Key Vault`, `Load Balancer`.

Azure regions use format: `eastus`, `westeurope`,
`australiaeast`, `uksouth`, etc.

Paginated: follow `NextPageLink` if present in response.

To discover available service names:

```bash
curl -s 'https://prices.azure.com/api/retail/prices?$filter=armRegionName%20eq%20%27eastus%27' \
  | jq '[.Items[].serviceName] | unique | sort'
```

### GCP Cloud Billing API

The gcloud CLI has no billing or pricing subcommand. Do not
attempt `gcloud billing services` or similar; it does not
exist. Use curl against the REST API.

Authenticate with a gcloud bearer token:

```bash
TOKEN=$(gcloud auth print-access-token)
```

**List services:**

```bash
curl -s -H "Authorization: Bearer $TOKEN" \
  'https://cloudbilling.googleapis.com/v1/services' \
  | jq '.services[] | {serviceId, displayName}'
```

**List SKUs for a service:**

```bash
curl -s -H "Authorization: Bearer $TOKEN" \
  "https://cloudbilling.googleapis.com/v1/services/${SERVICE_ID}/skus" \
  | jq '.skus[:5] | .[] | {description, serviceRegions, pricingInfo}'
```

To find the service ID for a specific service:

```bash
curl -s -H "Authorization: Bearer $TOKEN" \
  'https://cloudbilling.googleapis.com/v1/services' \
  | jq '.services[] | select(.displayName | test("BigQuery"; "i")) | {serviceId, displayName}'
```

GCP regions use format: `us-east1`, `europe-west1`,
`australia-southeast1`, etc.

Filter SKUs client-side by checking `serviceRegions` array
and `description` field. The API does not support server-side
region filtering. Responses can be very large. Use `pageSize`
to limit results and `pageToken` to paginate:

```bash
curl -s -H "Authorization: Bearer $TOKEN" \
  "https://cloudbilling.googleapis.com/v1/services/${SERVICE_ID}/skus?pageSize=100" \
  | jq '{skus: [.skus[] | {description, serviceRegions}], nextPageToken}'
```

**Full example (BigQuery pricing in australia-southeast1):**

```bash
TOKEN=$(gcloud auth print-access-token) && \
  SERVICE_ID=$(curl -s -H "Authorization: Bearer $TOKEN" \
    'https://cloudbilling.googleapis.com/v1/services' \
    | jq -r '.services[] | select(.displayName == "BigQuery") | .serviceId') && \
  curl -s -H "Authorization: Bearer $TOKEN" \
    "https://cloudbilling.googleapis.com/v1/services/${SERVICE_ID}/skus" \
    | jq '[.skus[] | select(.serviceRegions[] == "australia-southeast1") | {description, pricing: .pricingInfo[0].pricingExpression.tieredRates}]'
```

If `gcloud` is not available, tell the user it is needed for
GCP pricing lookups and suggest installing it.

## Cross-Provider Service Mapping

Equivalent services across providers (approximate):

| Category | AWS | Azure | GCP |
|---|---|---|---|
| Data warehouse | Redshift, Athena | Synapse Analytics | BigQuery |
| Relational DB | RDS | SQL Database | Cloud SQL |
| NoSQL | DynamoDB | Cosmos DB | Firestore/Bigtable |
| Object storage | S3 | Blob Storage | Cloud Storage |
| Serverless compute | Lambda | Functions | Cloud Functions/Run |
| Container orchestration | EKS | AKS | GKE |
| Caching | ElastiCache | Azure Cache for Redis | Memorystore |
| Message queue | SQS/SNS | Service Bus | Pub/Sub |
| Stream processing | Kinesis | Event Hubs | Dataflow |
| Search | OpenSearch | AI Search | Vertex AI Search |
| CDN | CloudFront | Front Door/CDN | Cloud CDN |
| DNS | Route 53 | DNS | Cloud DNS |
| Key management | KMS | Key Vault | Cloud KMS |

## Workflow

1. **Parse the query**: identify provider(s), service(s), and
   region(s). If the user names a service generically (e.g.
   "object storage"), map it to each provider using the table
   above.

2. **Check tool availability**: verify `curl` and `jq` are
   present. For GCP, check `gcloud` is available and
   authenticated.

3. **Query each provider**: run the appropriate curl commands.
   For large AWS bulk files, pipe through jq early to avoid
   memory issues. Prefer the AWS Query API when AWS CLI is
   available.

4. **Extract relevant data**: use jq to pull out service name,
   SKU, region, unit price, and unit of measure.

5. **Present results**: format as a markdown table. For
   cross-provider comparisons, normalise to a common structure:

   | Provider | Service | SKU/Tier | Region | Price (USD) | Unit |
   |---|---|---|---|---|---|

6. **Note caveats**: mention if pricing is tiered (e.g.
   first 1TB free), if there are significant differences
   between on-demand and committed pricing, or if the
   comparison is imperfect (different services have different
   billing models).

## Error Handling

- If an API call returns empty results, check service name
  spelling and casing (Azure is case sensitive). Try the
  service discovery commands listed per provider.
- If GCP returns 401/403, the bearer token may have expired.
  Re-run `gcloud auth print-access-token`.
- If an AWS per-region bulk URL returns 404, fall back to the
  global index URL.

## Committed / Reserved Pricing

Default to on-demand pricing. When the user asks about
reserved or committed pricing:

- **AWS**: filter by `termType` in the pricing JSON. Values
  are `OnDemand` and `Reserved`.
- **Azure**: filter by `priceType`. Values are `Consumption`,
  `Reservation`, and `DevTestConsumption`.
- **GCP**: committed use discounts appear as separate SKUs
  with "Commit" in the description. Filter by description.
