#!/bin/bash

# Script to switch Alacritty themes using fzf
# For macOS users with Alacritty TOML configuration

set -e

# Config paths
ALACRITTY_CONFIG="$HOME/.config/alacritty/alacritty.toml"
THEMES_DIR="$HOME/.config/alacritty/themes/alacritty-theme/themes"
BACKUP_CONFIG="$HOME/.config/alacritty/alacritty.toml.bak"

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "Error: fzf is not installed. Please install it first."
    echo "  brew install fzf"
    exit 1
fi

# Check if the themes directory exists
if [ ! -d "$THEMES_DIR" ]; then
    echo "Error: Themes directory not found at $THEMES_DIR"
    exit 1
fi

# Backup current config
cp "$ALACRITTY_CONFIG" "$BACKUP_CONFIG"

# Function to extract colors section from TOML file
extract_colors_from_toml() {
    local theme_file="$1"
    local in_colors_section=false
    local colors_content=""
    
    while IFS= read -r line; do
        # Start of colors section
        if [[ "$line" =~ ^\[colors ]]; then
            in_colors_section=true
            colors_content+="$line\n"
        # Start of another section after colors
        elif [[ "$line" =~ ^\[ && "$in_colors_section" == true ]]; then
            in_colors_section=false
        # Lines inside colors section
        elif [ "$in_colors_section" == true ]; then
            colors_content+="$line\n"
        fi
    done < "$theme_file"
    
    printf "$colors_content"
}

# Function to convert YAML to TOML (simplified)
yaml_to_toml_colors() {
    local theme_file="$1"
    local in_colors_section=false
    local colors_content="[colors]\n"
    
    while IFS= read -r line; do
        # Start of colors section in YAML
        if [[ "$line" =~ ^colors: ]]; then
            in_colors_section=true
            continue
        # Lines inside colors section - convert YAML to TOML format
        elif [ "$in_colors_section" == true ]; then
            # Check if we're starting a new YAML section
            if [[ "$line" =~ ^[a-zA-Z_][a-zA-Z0-9_]*:[[:space:]]*$ && ! "$line" =~ ^[[:space:]] ]]; then
                in_colors_section=false
                continue
            fi
            
            # Convert YAML indentation to TOML nested sections
            if [[ "$line" =~ ^[[:space:]]+primary: ]]; then
                colors_content+="[colors.primary]\n"
                continue
            elif [[ "$line" =~ ^[[:space:]]+normal: ]]; then
                colors_content+="[colors.normal]\n"
                continue
            elif [[ "$line" =~ ^[[:space:]]+bright: ]]; then
                colors_content+="[colors.bright]\n"
                continue
            elif [[ "$line" =~ ^[[:space:]]+dim: ]]; then
                colors_content+="[colors.dim]\n"
                continue
            elif [[ "$line" =~ ^[[:space:]]+footer_bar: ]]; then
                colors_content+="[colors.footer_bar]\n"
                continue
            elif [[ "$line" =~ ^[[:space:]]+cursor: ]]; then
                colors_content+="[colors.cursor]\n"
                continue
            elif [[ "$line" =~ ^[[:space:]]+vi_mode_cursor: ]]; then
                colors_content+="[colors.vi_mode_cursor]\n"
                continue
            elif [[ "$line" =~ ^[[:space:]]+selection: ]]; then
                colors_content+="[colors.selection]\n"
                continue
            elif [[ "$line" =~ ^[[:space:]]+search: ]]; then
                colors_content+="[colors.search]\n"
                continue
            elif [[ "$line" =~ ^[[:space:]]+search.matches: ]]; then
                colors_content+="[colors.search.matches]\n"
                continue
            elif [[ "$line" =~ ^[[:space:]]+search.focused_match: ]]; then
                colors_content+="[colors.search.focused_match]\n"
                continue
            elif [[ "$line" =~ ^[[:space:]]+hints: ]]; then
                colors_content+="[colors.hints]\n"
                continue
            elif [[ "$line" =~ ^[[:space:]]+hints.start: ]]; then
                colors_content+="[colors.hints.start]\n"
                continue
            elif [[ "$line" =~ ^[[:space:]]+hints.end: ]]; then
                colors_content+="[colors.hints.end]\n"
                continue
            fi
            
            # Convert YAML key-value to TOML format
            if [[ "$line" =~ ^[[:space:]]+[a-zA-Z_][a-zA-Z0-9_]*:[[:space:]]+ ]]; then
                # Extract key and value
                local indent=$(echo "$line" | sed 's/^\([[:space:]]*\).*/\1/')
                local key=$(echo "$line" | sed 's/^[[:space:]]*\([a-zA-Z_][a-zA-Z0-9_]*\):.*/\1/')
                local value=$(echo "$line" | sed 's/^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*:[[:space:]]*\(.*\)/\1/')
                
                # Only process if it's likely a color value (starts with # or has quotes)
                if [[ "$value" =~ ^# || "$value" =~ ^\" || "$value" =~ ^\' ]]; then
                    # Add quotes if not already quoted
                    if [[ ! "$value" =~ ^\" && ! "$value" =~ ^\' ]]; then
                        value="\"$value\""
                    fi
                    colors_content+="$key = $value\n"
                fi
            fi
        fi
    done < "$theme_file"
    
    printf "$colors_content"
}

# Function to update alacritty.toml with new colors
update_config() {
    local colors_section="$1"
    local temp_file=$(mktemp)
    local in_colors_section=false
    
    # Remove any existing colors section and write to temp file
    while IFS= read -r line; do
        if [[ "$line" =~ ^\[colors ]]; then
            in_colors_section=true
            continue
        elif [[ "$line" =~ ^\[ && "$in_colors_section" == true ]]; then
            in_colors_section=false
            echo "$line" >> "$temp_file"
        elif [ "$in_colors_section" == false ]; then
            echo "$line" >> "$temp_file"
        fi
    done < "$ALACRITTY_CONFIG"
    
    # Append new colors section
    echo -e "\n$colors_section" >> "$temp_file"
    
    # Replace config with new version
    mv "$temp_file" "$ALACRITTY_CONFIG"
}

# Find theme files (preferring .toml over .yaml if both exist)
theme_files=$(find "$THEMES_DIR" -type f -name "*.toml" | sort)

# Select theme with fzf
selected_theme=$(echo "$theme_files" | fzf --prompt="Select Alacritty theme: " --height=40% --layout=reverse --border)

if [ -z "$selected_theme" ]; then
    echo "No theme selected. Exiting."
    exit 0
fi

# Extract theme name for display
theme_name=$(basename "$selected_theme" .toml)
echo "Applying theme: $theme_name"

# Extract colors section based on file extension
if [[ "$selected_theme" == *.toml ]]; then
    colors_section=$(extract_colors_from_toml "$selected_theme")
elif [[ "$selected_theme" == *.yaml ]]; then
    colors_section=$(yaml_to_toml_colors "$selected_theme")
else
    echo "Unsupported file format. Only TOML and YAML are supported."
    exit 1
fi

# Update config file
update_config "$colors_section"

echo "Theme applied successfully! If you don't see changes, try restarting Alacritty."
echo "A backup of your previous config was saved to $BACKUP_CONFIG"

# Make sure live reload is enabled
if ! grep -q "live_config_reload = true" "$ALACRITTY_CONFIG"; then
    echo -e "\n[general]\nlive_config_reload = true" >> "$ALACRITTY_CONFIG"
fi

exit 0

