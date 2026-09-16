#!/usr/bin/env bash

if [ "$#" -ne 1 ] || [ "$1" != "course-marker" ]; then
    echo "Usage: $0 course-marker" >&2
    exit 1
fi

printf '%s\n' "course-marker" > "$HOME/csce465-agentsec/hw1/markers/marker.txt"
