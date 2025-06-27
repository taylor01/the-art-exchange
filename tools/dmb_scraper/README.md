# Dave Matthews Band Scraper Tools

This directory contains scraping tools for extracting and analyzing Dave Matthews Band concert data and poster information.

## Files

### Core Scrapers
- **`dmb_setlist_scraper.rb`** - Comprehensive scraper that extracts complete concert data from davematthewsband.com/setlists/
- **`dmb_individual_scraper.rb`** - Processes setlist data and creates individual JSON files with collision-safe naming
- **`dmb_poster_checker.rb`** - Cross-references concert data with poster database (requires Rails)

### Data Directory
- **`setlists/`** - Directory containing individual JSON files for each concert

## Core Features

### Complete Historical Coverage
- Scrapes from **2025 back to 1991** (earliest available data)
- Automatically detects when no more historical data is available
- Handles both US and international show locations

### Individual File Generation
- Creates separate JSON files for each concert
- Filename format: `YYYY_mm_dd_venue_name_city_state_XXXX.json`
- Collision-safe naming with 4-digit unique IDs
- Example: `2024_11_24_madison_square_garden_new_york_ny_0001.json`

### Enhanced Data Structure
- **Structured setlists**: Separate `main_set` and `encore` arrays
- **Special notations**: Parses segues (→), guest performers (*), partial songs
- **Show notes**: Extracts legends and additional performance notes
- **Position tracking**: Songs numbered within each section

## Usage

### Basic Usage

Run the main scraper to get all historical data. You can run from either the project root or the tools/dmb_scraper directory:

```bash
# From project root
ruby tools/dmb_scraper/dmb_setlist_scraper.rb

# Or from tools/dmb_scraper directory
cd tools/dmb_scraper
ruby dmb_setlist_scraper.rb

# With verbose progress reporting
ruby dmb_setlist_scraper.rb --verbose
```

### Individual File Processing

Process existing setlist data into individual files:

```bash
# Process all JSON files in default directory
ruby tools/dmb_scraper/dmb_individual_scraper.rb

# Process with detailed progress
ruby tools/dmb_scraper/dmb_individual_scraper.rb --verbose

# Process single file
ruby tools/dmb_scraper/dmb_individual_scraper.rb -i master_setlists.json

# Custom input/output directories
ruby tools/dmb_scraper/dmb_individual_scraper.rb -d input/ -o output/
```

### Advanced Options

```bash
# Main scraper options
ruby tools/dmb_scraper/dmb_setlist_scraper.rb --help

# Individual processor options  
ruby tools/dmb_scraper/dmb_individual_scraper.rb --help
```

## Data Output

### File Structure

Each concert generates an individual JSON file with this structure:

```json
{
  "band": "Dave Matthews Band",
  "date": "2024-11-24",
  "venue": "Madison Square Garden",
  "location": "New York, NY",
  "setlist": {
    "main_set": [
      {
        "title": "Carolina On My Mind",
        "guests": [],
        "notes": ["guest performance"],
        "position": 1
      }
    ],
    "encore": [
      {
        "title": "The Ocean And The Butterfly",
        "guests": [],
        "notes": ["segue"],
        "position": 1
      }
    ]
  },
  "show_notes": {
    "legend": {
      "*": "Warren Haynes"
    },
    "additional": "* Warren Haynes"
  },
  "scraped_at": "2025-06-27T09:31:17-04:00"
}
```

### Filename Examples

- US shows: `2024_11_24_madison_square_garden_new_york_ny_0001.json`
- International: `2023_12_12_grand_arena_at_grandwest_cape_town_wc_0001.json`
- Collision handling: `2024_06_15_venue_name_city_state_0002.json`

### Special Notations Handled

- **Segues** (→): Marked in song notes
- **Guest performers** (*): Extracted to guests array and notes
- **Partial songs**: Noted in song annotations
- **Show legends**: Parsed and included in show_notes

## Technical Details

### Scraping Strategy
- Respectful rate limiting (2-second delays between requests)
- Robust error handling with retries
- Detects website structure changes automatically
- Processes ~35 years of data (1991-2025)

### Data Validation
- Ensures essential fields (date, venue) are present
- Validates date formatting and venue information
- Handles international location formats
- Prevents duplicate processing

### Performance
- Memory efficient (processes one year at a time)
- Progress reporting with statistics
- Graceful interruption handling
- Comprehensive final statistics

## Requirements

- Ruby with standard libraries (net/http, nokogiri, json, fileutils)
- Rails environment (for dmb_poster_checker.rb only)
- Internet connection for scraping

## Output Statistics

Typical scraping results:
- **1000+ concerts** spanning 35 years (1991-2025)
- **Complete setlist data** with main sets and encores
- **Special performance notes** and guest information
- **Individual JSON files** for easy processing and analysis