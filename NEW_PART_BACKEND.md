# New-part incremental backend

The `/api/upload-inventory` endpoint now runs the incremental market pipeline.

- Existing parts are found in `data/incremental/tmv_results.csv` and reused.
- Only unseen parts call the eBay Browse API and the Apify sold-listings actor.
- New evidence is appended to `market_data.csv` and `sold_clean_combined.csv`.
- TMV, scenarios, totals, and `dashboard_full.csv` are rebuilt.
- `/api/analyze` falls back to the incremental result store for newly added parts.

## Environment

Set `EBAY_TOKEN` and `APIFY_TOKEN` before starting Uvicorn.

PowerShell:

```powershell
$env:EBAY_TOKEN="..."
$env:APIFY_TOKEN="..."
python -m uvicorn src.web_app:app --reload
```

macOS/Linux:

```bash
export EBAY_TOKEN="..."
export APIFY_TOKEN="..."
python -m uvicorn src.web_app:app --reload
```

Without both variables, uploads still identify new parts but do not spend API quota.
