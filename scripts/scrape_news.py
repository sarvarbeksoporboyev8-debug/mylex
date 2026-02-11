#!/usr/bin/env python3
"""
Scrape news from lex.uz for all 4 languages.
MERGES new items with existing data (new items on top).
Run daily via GitHub Actions.
"""

import argparse
import json
import re
import urllib.request
from datetime import datetime
from pathlib import Path

LANGUAGES = {
    'uz-Cyrl': {
        'url': 'https://lex.uz/search/official?lang=3',
        'pattern': r'href="(/docs/-?\d+)"[^>]*>([^<]+)<',
        'base': 'https://lex.uz'
    },
    'uz': {
        'url': 'https://lex.uz/uz/search/official?lang=3',
        'pattern': r'href="(/uz/docs/-?\d+)"[^>]*>([^<]+)<',
        'base': 'https://lex.uz'
    },
    'ru': {
        'url': 'https://lex.uz/ru/search/official?lang=3',
        'pattern': r'href="(/ru/docs/-?\d+)"[^>]*>([^<]+)<',
        'base': 'https://lex.uz'
    },
    'en': {
        'url': 'https://lex.uz/en/search/official?lang=3',
        'pattern': r'href="(/en/docs/-?\d+)"[^>]*>([^<]+)<',
        'base': 'https://lex.uz'
    },
}

def fetch_page(url):
    """Fetch HTML content from URL."""
    headers = {'User-Agent': 'Mozilla/5.0 (compatible; LexUzBot/1.0)'}
    req = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(req, timeout=30) as response:
        return response.read().decode('utf-8')

def extract_id_from_url(url):
    """Extract document ID from lex.uz URL."""
    match = re.search(r'/docs/(-?\d+)', url)
    return match.group(1) if match else None

def load_existing_news(filepath):
    """Load existing news from JSON file."""
    if filepath.exists():
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                return json.load(f)
        except:
            pass
    return []

def scrape_news(lang_code, config):
    """Scrape news for a specific language."""
    print(f"Scraping {lang_code}...")
    
    try:
        html = fetch_page(config['url'])
    except Exception as e:
        print(f"  Error fetching {config['url']}: {e}")
        return []
    
    # Find all document links
    matches = re.findall(config['pattern'], html)
    
    news = []
    seen_ids = set()
    base_url = config.get('base', '')
    
    for path, title in matches:
        doc_id = extract_id_from_url(path)
        if doc_id and doc_id not in seen_ids:
            seen_ids.add(doc_id)
            # Escape problematic characters
            clean_title = title.strip().replace('$', 'USD ')
            full_url = base_url + path
            news.append({
                'id': doc_id,
                'title': clean_title,
                'url': full_url,
                'date': datetime.utcnow().strftime('%Y-%m-%d'),
            })
    
    print(f"  Scraped {len(news)} documents from website")
    return news

def merge_news(existing, new_items):
    """Merge new items with existing, new items on top, no duplicates."""
    existing_ids = {item['id'] for item in existing}
    
    # Find truly new items
    new_unique = [item for item in new_items if item['id'] not in existing_ids]
    
    # New items on top, then existing
    merged = new_unique + existing
    
    print(f"  Added {len(new_unique)} new items, total: {len(merged)}")
    return merged

def main():
    parser = argparse.ArgumentParser(description='Scrape news from lex.uz')
    parser.add_argument('--output', type=str, help='Output directory for JSON files')
    args = parser.parse_args()
    
    if args.output:
        output_dir = Path(args.output)
    else:
        output_dir = Path(__file__).parent.parent / 'assets' / 'data' / 'news'
    
    output_dir.mkdir(parents=True, exist_ok=True)
    
    metadata = {
        'last_updated': datetime.utcnow().isoformat() + 'Z',
        'languages': {}
    }
    
    total_new = 0
    
    for lang_code, config in LANGUAGES.items():
        # Load existing data
        filename = f'news_{lang_code.replace("-", "_")}.json'
        output_path = output_dir / filename
        existing = load_existing_news(output_path)
        
        # Scrape new data
        new_items = scrape_news(lang_code, config)
        
        # Merge (new on top, no duplicates)
        merged = merge_news(existing, new_items)
        
        # Count new items added
        new_count = len(merged) - len(existing)
        total_new += new_count
        
        # Save merged data
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(merged, f, ensure_ascii=False, indent=2)
        
        metadata['languages'][lang_code] = {
            'file': filename,
            'count': len(merged),
            'new_today': new_count
        }
        
        print(f"  Saved to {output_path}")
    
    # Save metadata
    with open(output_dir / 'metadata.json', 'w', encoding='utf-8') as f:
        json.dump(metadata, f, ensure_ascii=False, indent=2)
    
    print(f"\nDone! Added {total_new} new items total at {metadata['last_updated']}")

if __name__ == '__main__':
    main()
