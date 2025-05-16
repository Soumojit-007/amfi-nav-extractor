# AMFI NAV Data Extractor

A shell script to extract Scheme Name and Asset Value from [AMFI India's NAV data](https://www.amfiindia.com/spages/NAVAll.txt).

## Features
- Fetches latest NAV data
- Outputs TSV (default) or JSON
- Lightweight (uses `curl` + `awk`)

## Quick Start
```bash
./extract_nav.sh          # TSV output
./extract_nav.sh --json   # JSON output
