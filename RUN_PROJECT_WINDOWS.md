# Run the dashboard on Windows

Open PowerShell in the `version_2` folder.

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
```

Set the three credentials in the same terminal:

```powershell
$env:EBAY_TOKEN="your_ebay_oauth_token"
$env:APIFY_TOKEN="your_apify_token"
$env:GROQ_API_KEY="your_groq_api_key"
```

Start the app:

```powershell
python -m uvicorn src.web_app:app --reload
```

Open http://127.0.0.1:8000

## New-part flow

When an inventory is uploaded, the backend:

1. Parses the workbook safely on Windows.
2. Compares each structured part with `data/incremental/tmv_results.csv`.
3. Reuses known parts without calling external APIs.
4. For unseen parts, calls eBay and Apify.
5. Runs the original notebook-style listing extraction: deterministic rules first, then Groq only when fields are incomplete.
6. Appends evidence and the new TMV result.
7. Regenerates the dashboard/scenario CSV files.

## Test safely

First upload the unchanged inventory. It should report zero new parts and make no external API calls.

Then make a copy and add one real watch part with Brand, Caliber, Part Number, and Stock. Upload it while all three environment variables are configured. The terminal should show `Fetching only new part` once. Uploading the same file again should make no API calls.
