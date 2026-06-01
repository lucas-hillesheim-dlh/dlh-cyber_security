#!/usr/bin/env python3
import requests
from bs4 import BeautifulSoup

def download_page(url):
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')

    return soup.prettify()

if __name__ == "__main__":
    import sys
    url = sys.argv[1]
    download_page(url)

