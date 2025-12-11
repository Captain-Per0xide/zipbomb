#!/bin/bash

# Configuration
START_FILE="layer0.zip"
MAX_CYCLES=5

echo "💣 Starting FULL Expansion Simulation (keeping all files)..."
echo "---------------------------------------------"

if [ ! -f "$START_FILE" ]; then
    echo "Error: $START_FILE not found. Run the C generator first."
    exit 1
fi

mkdir -p full_expansion_zone
cp "$START_FILE" full_expansion_zone/
cd full_expansion_zone

current_cycle=0

while [ "$(find . -name '*.zip' -not -name '*.extracted' | wc -l)" -gt 0 ]; do
    
    if [ $current_cycle -ge $MAX_CYCLES ]; then
        echo "🛑 Safety limit reached ($MAX_CYCLES cycles). Stopping simulation."
        break
    fi

    zip_count=$(find . -name '*.zip' -not -name '*.extracted' | wc -l)
    echo "[Cycle $current_cycle] Found $zip_count archives. Extracting..."
    
    # Find all unprocessed zip files
    find . -name '*.zip' -not -name '*.extracted' | while read zip_file; do
        # Create unique directory for each zip
        dir_name="${zip_file%.zip}_contents"
        mkdir -p "$dir_name"
        
        echo "  → Extracting $zip_file into $dir_name..."
        unzip -oq "$zip_file" -d "$dir_name"
        
        # Mark as processed
        mv "$zip_file" "${zip_file}.extracted"
    done
    
    # Calculate current size
    current_size=$(du -sh . | cut -f1)
    file_count=$(find . -type f | wc -l)
    zip_remaining=$(find . -name '*.zip' -not -name '*.extracted' | wc -l)
    txt_count=$(find . -name '*.txt' | wc -l)
    
    echo "   ↳ Status: Folder size is now $current_size"
    echo "   ↳ Files: $txt_count text files, $zip_remaining zips remaining"
    
    ((current_cycle++))
    echo "---------------------------------------------"
    sleep 1
done

echo "✅ Simulation complete."
echo ""
echo "📊 Final Statistics:"
echo "   Total files: $(find . -type f | wc -l)"
echo "   Text files: $(find . -name '*.txt' | wc -l)"
echo "   Processed zips: $(find . -name '*.extracted' | wc -l)"
echo "   Folder size: $(du -sh . | cut -f1)"