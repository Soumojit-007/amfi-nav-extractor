#!/bin/bash

# Script to extract Scheme Name and Asset Value from AMFI India NAV data
# Outputs as TSV by default, with option for JSON

URL="https://www.amfiindia.com/spages/NAVAll.txt"
OUTPUT_FILE="scheme_assets.tsv"
JSON_OUTPUT=false

# Check if curl is available
if ! command -v curl &> /dev/null; then
    echo "Error: curl is required but not installed."
    exit 1
fi

# Check if jq is available (for JSON output)
if [ "$1" == "--json" ]; then
    JSON_OUTPUT=true
    OUTPUT_FILE="scheme_assets.json"
    if ! command -v jq &> /dev/null; then
        echo "Error: jq is required for JSON output but not installed."
        exit 1
    fi
fi

echo "Fetching data from AMFI India..."
if ! curl -s "$URL" > temp_nav.txt; then
    echo "Error: Failed to download data from $URL"
    exit 1
fi

echo "Processing data..."

# Process the data
if [ "$JSON_OUTPUT" = true ]; then
    # JSON output
    echo "[" > "$OUTPUT_FILE"
    grep -E ';' temp_nav.txt | awk -F';' '{print "  {\"scheme_name\": \"" $4 "\", \"asset_value\": \"" $5 "\"}"}' \
    | sed '$!s/$/,/' >> "$OUTPUT_FILE"
    echo "]" >> "$OUTPUT_FILE"
    
    # Format JSON with jq if available
    if command -v jq &> /dev/null; then
        jq '.' "$OUTPUT_FILE" > temp.json && mv temp.json "$OUTPUT_FILE"
    fi
    
    echo "Data saved as JSON in $OUTPUT_FILE"
else
    # TSV output (default)
    echo -e "Scheme Name\tAsset Value" > "$OUTPUT_FILE"
    grep -E ';' temp_nav.txt | awk -F';' '{print $4 "\t" $5}' >> "$OUTPUT_FILE"
    echo "Data saved as TSV in $OUTPUT_FILE"
fi

# Clean up
rm temp_nav.txt

echo "Done."
