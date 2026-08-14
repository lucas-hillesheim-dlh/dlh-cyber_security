#!/usr/bin/python3
"""
## This module finds a string in the heap of a running process, and replaces it.

Keyword arguments:
pid -- The PID of the target running process 
search_string -- The string in the running process that will be replaced
replace_string -- The string that will replace the search_string in the running process
"""
import os
import re
import sys

def get_heap_region(pid):
    """Parses /proc/[pid]/maps to locate the start and end address of the heap."""
    maps_path = f"/proc/{pid}/maps"
    if not os.path.exists(maps_path):
        raise FileNotFoundError(f"Process {pid} does not exist or maps file unavailable.")

    with open(maps_path, "r") as f:
        for line in f:
            # Example line: 021f1000-02212000 rw-p 00000000 00:00 0 [heap]
            if "[heap]" in line:
                match = re.match(r"^([0-9a-fA-F]+)-([0-9a-fA-F]+)\s+([rwxp-]{4})", line)
                if match:
                    start_addr = int(match.group(1), 16)
                    end_addr = int(match.group(2), 16)
                    permissions = match.group(3)
                    return start_addr, end_addr, permissions

    raise RuntimeError(f"Could not find '[heap]' region for PID {pid}.")

def replace_in_heap(pid, target_str, replacement_str):
    """Replaces the string in the heap memory process """
    target_bytes = target_str.encode("utf-8")
    replacement_bytes = replacement_str.encode("utf-8")

    if len(replacement_bytes) > len(target_bytes):
        raise ValueError("Replacement string cannot be longer than target string!")

    # Pad replacement with null bytes if it's shorter than the target
    padded_replacement = replacement_bytes.ljust(len(target_bytes), b'\x00')

    # Locate heap addresses
    start_addr, end_addr, perms = get_heap_region(pid)
    heap_size = end_addr - start_addr
    print(f"[*] Found heap at 0x{start_addr:x} - 0x{end_addr:x} (Size: {heap_size} bytes)")

    if "w" not in perms:
        raise PermissionError("Heap region is not marked as writable.")

    mem_path = f"/proc/{pid}/mem"
    
    # Open /proc/[pid]/mem in read/write binary mode
    with open(mem_path, "rb+") as mem_file:
        # Seek to the start of the heap region
        mem_file.seek(start_addr)
        heap_data = mem_file.read(heap_size)

        # Search for occurrences
        matches = []
        offset = 0
        while True:
            idx = heap_data.find(target_bytes, offset)
            if idx == -1:
                break
            matches.append(idx)
            offset = idx + len(target_bytes)

        if not matches:
            print(f"[-] String '{target_str}' not found in heap.")
            return

        print(f"[+] Found {len(matches)} occurrence(s) in heap.")

        # Replace each occurrence
        for match_offset in matches:
            target_addr = start_addr + match_offset
            print(f"[*] Overwriting at address: 0x{target_addr:x}")
            
            mem_file.seek(target_addr)
            mem_file.write(padded_replacement)

        print("[+] Replacement complete.")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print(f"Usage: sudo python3 {sys.argv[0]} <PID> <target_string> <replacement_string>")
        sys.exit(1)

    target_pid = int(sys.argv[1])
    search_str = sys.argv[2]
    replace_str = sys.argv[3]

    try:
        replace_in_heap(target_pid, search_str, replace_str)
    except Exception as e:
        print(f"[!] Error: {e}")



