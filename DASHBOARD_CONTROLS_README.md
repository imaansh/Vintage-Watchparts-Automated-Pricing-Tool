# Dashboard controls added

## Run the app

From `version_2`:

```bash
python -m pip install -r requirements.txt
python -m uvicorn src.web_app:app --reload
```

Open `http://127.0.0.1:8000`.

## Added functionality

- Inventory upload for `.csv` and `.xlsx` through `/api/upload-inventory`.
- Reset to the default inventory through `/api/reset-inventory`.
- Product-level strategic simulation through `/api/analyze`.
- Price slider from -30% to +30% relative to TMV.
- Target-time selector using 7, 30, 60, 90, 183 and 365 days.
- Results for simulated price, estimated selling period, potential inventory revenue, elasticity and evidence-range warning.

## Important boundary

The upload endpoint loads and cleans the inventory for the current server session. It does not itself collect new marketplace evidence for a previously unseen part. A new part can only be fully analysed when its market evidence is already available to `analytics_engine.py`, or after the separate incremental marketplace pipeline has written that evidence into the Version 2 data store.
