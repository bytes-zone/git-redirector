#!/usr/bin/env python3
import sys

with open(sys.argv[1], 'r') as fh:
    sources = [line.split() for line in fh.read().strip().split('\n')]

# preamble
print("""\
server {
    listen 80;
    server_name git.bytes.zone;

    location / {
        return 301 $scheme://github.com$request_uri;
    }
""")

for (src, dest) in sources:
    print(f"    location ~* ^/{src}/commit/([0-9a-f]+)$ {{")
    print(f"        return 301 https://github.com/{dest}/commit/$1;")
    print("    }")

print("}")
