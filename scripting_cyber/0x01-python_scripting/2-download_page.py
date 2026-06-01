#!/usr/bin/env python3
import requests
from bs4 import BeautifulSoup

def download_page(url):
    try:
        response = requests.get(url)
        soup = BeautifulSoup(response.text, 'html.parser')
        return soup.prettify()
    except requests.exceptions.RequestException:
        return f"Download failed for {url}"

if __name__ == "__main__":
    import sys
    url = sys.argv[1]
    download_page(url)

