# Automated Pricing / TMV — Version 2

## Status

Version 2 is the active corrected implementation.

Phases 1-10 are complete. The corrective methodological pass is complete and the corrected methodology is authoritative for final validation and delivery preparation.

## Official inventory source

The official raw inventory workbook is:

`data/raw/Inventory_watchparts_RWTH_RUN_2.xlsx`

This workbook must remain unchanged. Product identifiers such as calibre and part number are identifiers, not mathematical variables.

## Current pilot

The validated pilot product is:

- Brand: Rolex
- Calibre: 1570
- Part number: 7831
- Stock: 17

Corrected benchmark:

- Sold median (9 completed sales):   EUR 82.11
- Active median (19 listings):        EUR 71.15
- TMV:                                EUR 78.82
- Method: 70% completed sales + 30% active listings
- Confidence: high
- Potential inventory value:          EUR 1,339.99
- Estimated Market Absorption Time:   990.9 days

## Method status

The analytical engine uses the validated Version 2 methodology:

- TMV positioning by evidence tier:
  >=5 sold and >=3 active  ->  70% sold + 30% active   (high)
  >=3 sold and >=2 active  ->  60% sold + 40% active   (medium)
  >=3 sold                 ->  completed sales only    (medium)
  >=3 active               ->  active listings only    (provisional)
  otherwise                ->  no TMV                  (insufficient evidence)
- `MODELED_MARKET_ABSORPTION_PROXY` turnover interpretation
- `constant_elasticity_scenario` Price-Time relationship
- `epsilon = 1.5`, labelled as `assumption_not_empirically_estimated`

Shipping, VAT, sales tax, customs, and import costs are excluded from TMV and handled only in the scenario layer.

## How to run locally

Pipeline:

```bash
python src/run_pipeline.py
```

Frontend/backend demo:

```bash
PYTHONPATH=src python -m uvicorn web_app:app --host 127.0.0.1 --port 8010
```

Then open `http://127.0.0.1:8010`.

## Database Setup

Version 2 includes a simple SQLite persistence layer alongside the existing CSV and Excel workflow.

Database location:

`data/database/automated_pricing.db`

Initialize and populate the database from the Version 2 root:

```bash
python src/setup_database.py
```

The setup command:

1. creates the SQLite schema;
2. registers and imports the official inventory workbook;
3. registers and imports `data/reference/prototype_analysis_baseline.csv` as an EXPERIMENTAL reference analysis;
4. writes the inventory reconciliation report;
5. exports the stored prototype baseline run back to CSV.

Useful outputs:

- `docs/database_architecture.md`
- `docs/database_inventory_reconciliation.md`
- `outputs/audit/database_inventory_reconciliation.csv`
- `outputs/exports/prototype_baseline_from_database.csv`

Simple query helpers are available in `src/database_queries.py`, including product lookup, latest inventory lookup, analysis-run lookup, product-result lookup, latest product result, and database summary.

The database does not change the TMV, turnover, price-time, or scenario methodology. The current frontend/backend still reads the existing CSV-based workflow.

## Marketplace Evidence Foundation

Version 2 is prepared to ingest a future materialized marketplace CSV at:

`data/reference/marketplace/prototype_market_data.csv`

That file is not currently present in the repository. The importer therefore does not populate marketplace listings during setup.

Marketplace evidence documentation:

- `docs/marketplace_evidence_contract.md`
- `docs/prototype_marketplace_field_audit.md`

The prototype baseline CSV is not marketplace evidence and must not be imported into `market_listings`.

## Frontend Scope and Data Boundary

The frontend is limited to the professor-defined workflow:

1. product search;
2. selected product identity;
3. TMV / zero-baseline result display;
4. TMV-basis transparency;
5. price or time strategy controls;
6. eight selling-time intervals;
7. market scenarios A, B, and C;
8. product-selling-price-only comparison;
9. calculation basis and inventory snapshot status.

No current analytical dashboard file is integrated in this frontend phase.

Current operational state:

`NO_DATA_FILE`

The frontend starts successfully, renders the complete interface shell, and explains that approved analytical results have not been loaded yet. It must not load mock products, inventory CSVs, historical evidence, active evidence, SQLite data, or current Imaan analytical files.

The single future analytical-data boundary is:

`DASHBOARD_DATA_PATH`

This is currently `null` in `frontend/productModel.mjs`. Once the analytical owner provides the approved final result file and the project owner explicitly authorizes integration, the file can be attached at one configured frontend data location. The adapter will then be responsible for locating, loading, parsing, validating, and normalizing rows into the stable frontend product model.

The frontend product model is presentation-facing and intentionally separate from raw analytical columns:

```text
productKey
partId
brand
calibre
partNumber
stock
tmvUnitEur
inventoryValueEur
confidence
evidenceStatus
priceBasis
activeComparableCount
soldComparableCount
activeMedianEur
soldMedianEur
estimatedFullStockTurnover
tmvBasis
marketComparison
calculationBasis
scenarios
priceTime
```

Search is prepared for case-insensitive, whitespace-normalized, partial matching across brand, calibre, part number, product ID/product key, and a combined free-text query. Search remains disabled until an approved analytical result file is loaded.

TMV display responsibility:

- display supplied TMV values only;
- never calculate TMV in the frontend;
- never convert missing TMV values to zero;
- show `TMV not available` when approved values are missing.

Price-time display responsibility:

- display supplied interval outputs only;
- support the eight required interval labels from one frontend configuration;
- prepare disabled PRICE and TIME strategy modes until approved analytical outputs exist;
- prepare a disabled RESET TO TMV control for returning to the zero baseline;
- never generate probabilities, fixed weights, price multipliers, or selling-time estimates in the frontend;
- show `Price-time result not available` when approved outputs are missing.

Scenario display structure uses the professor-defined labels and static context:

- `Scenario A — United States`: customer United States, ZIP `90210`, HS code `9114.90`, fixed shipping `€25`, import charges shown only when supplied by analytics.
- `Scenario B — Germany`: customer Germany, fixed shipping `€5`, no import charges, no customs duties.
- `Scenario C — Virtual / Product Only`: product selling price only, no shipping, VAT, tax, or customs.

The market-comparison section is explicitly limited to displayed product selling price. Buyer-side shipping, duties, VAT, tax, and customs remain visually separate from the product-price comparison.

Future final-file attachment process:

1. The analytical owner provides the approved final result file.
2. The project owner explicitly authorizes its integration.
3. The file is placed at the single configured frontend data location.
4. The adapter is updated only if final column names differ.
5. The schema validator is executed.
6. Validation warnings are reviewed.
7. Product search becomes active.
8. TMV and price-time results are displayed.
9. UI components remain unchanged unless approved business requirements change.

Frontend test command from the Version 2 root:

```bash
node --test frontend/app.test.mjs
```

The tests use fictional synthetic products only and do not copy project inventory, Imaan rows, historical evidence, active evidence, or analytical result values.

## Environment and Tests

Supported Python version: Python 3.10 or newer.

Install active Version 2 dependencies from the Version 2 root:

```bash
python -m pip install -r requirements.txt
```

Run tests:

```bash
python -m pytest tests -q
```

The active Version 2 requirements intentionally exclude Groq, LangChain, and eBay API client dependencies because the root experimental notebook is not part of the active runtime.

## Main limitation

The main current limitation is market-data coverage, not software functionality. Current stored evidence permits full TMV analysis for 1 of 737 candidate products.
