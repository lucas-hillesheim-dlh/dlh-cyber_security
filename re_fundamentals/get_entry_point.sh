#!/bin/bash

# 1. Accept the ELF file name as a command-line argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <elf_file>" >&2
    exit 1
fi

file_name="$1"

# 2 & 3. Check if the file exists and is a valid ELF file
if [ ! -f "$file_name" ]; then
    echo "Error: File '$file_name' does not exist." >&2
    exit 1
fi

if ! readelf -h "$file_name" >/dev/null 2>&1; then
    echo "Error: File '$file_name' is not a valid ELF file." >&2
    exit 1
fi

# 4. Use readelf to extract the required data cleanly
magic_number=$(readelf -h "$file_name" | grep "Magic:" | sed 's/^[ \t]*Magic:[ \t]*//')
class=$(readelf -h "$file_name" | grep "Class:" | awk '{print $2}')
byte_order=$(readelf -h "$file_name" | grep "Data:" | sed "s/.*Data:[ \t]*//; s/'//g")
entry_point_address=$(readelf -h "$file_name" | grep "Entry point address:" | awk '{print $4}')

# 5. Use messages.sh to format and display the output
if [ -f "./messages.sh" ]; then
    source ./messages.sh
else
    # Fallback definition if messages.sh is in a different path or structure
    display_elf_header_info() {
        echo "Header Information for '$file_name':"
        echo "--------------------------------"
        echo "Magic Number: $magic_number"
        echo "Class: $class"
        echo "Byte Order: $byte_order"
        echo "Entry Point Address: $entry_point_address"
    }
fi

display_elf_header_info
