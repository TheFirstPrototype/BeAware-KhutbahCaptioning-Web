#!/bin/bash

# JSON file containing translations
TRANSLATION_FILE="translations.json"
# Define the language codes
languageCodes=("ES" "FR" "PT" "AR" "RU" "DE" "UK" "HI" "UR" "YO" "ID" "IT" "JA" "SW" "PL" "VI" "RO" "zh-Hant" "ZH" "HR" "FA" "NL" "KO" "SV" "HU" "SQ")

# Check if translation file exists
if [ ! -f "$TRANSLATION_FILE" ]; then
    echo "Translation file '$TRANSLATION_FILE' not found."
    exit 1
fi

# Iterate through each language and perform translations
for lang in "${languageCodes[@]}"; do
    lowerCode=$(echo "$lang" | tr '[:upper:]' '[:lower:]')
    html_file=index-${lowerCode}.html
    if [ ! -f "$html_file" ]; then
        echo "HTML file '$html_file' for language '$lang' not found."
    else
        echo "Applying translations for language '$lang' to HTML file '$html_file'..."

        # Generate sed commands for current language
        sed_commands=""
        while IFS= read -r line; do
            en_value=$(echo "$line" | jq -r ".EN") # brew install jq, allows using json
            lang_value=$(echo "$line" | jq -r ".$lang")
            if [ -n "$en_value" ] && [ -n "$lang_value" ]; then
                sed_commands+="s/\"$en_value\"/\"$lang_value\"/g;"
            fi
        done < "$TRANSLATION_FILE"

        # Perform sed replacement on the HTML file
        sed -i.bak -E "$sed_commands" "$html_file"
        echo "Translations applied for language '$lang'."
    fi
done

echo "All translations applied successfully."
