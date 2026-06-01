#!/usr/bin/env python3
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse

def crawl_website(start_url, max_depth=2):
    try:
        visited = set()
        crawl(start_url, visited)
        return visited
    except requests.exceptions.RequestException:
        return set()

def crawl(url, visited=None, depth=0, max_depth=2):
    """
    Recursively crawl a website.

    Args:
        url: Starting URL
        visited: Set of already visited URLs
        depth: Current depth level
        max_depth: Maximum depth to crawl
    """
    # Initialize visited set
    if visited is None:
        visited = set()

    # Base cases (stop recursion)
    if depth > max_depth:
        return
    if url in visited:
        return

    # Mark as visited
    visited.add(url)
    # print(f"Crawling: {url} (depth: {depth})")

    # Get page content
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')

    # Find all links
    for link in soup.find_all('a', href=True):
        next_url = urljoin(url, link['href'])
        if urlparse(next_url).hostname == urlparse(url).hostname:
            # Recursive call
            crawl(next_url, visited, depth + 1, max_depth)

if __name__ == "__main__":
    url = sys.argv[1]
    depth = sys.argv[2]
    crawl_website(url, depth)
