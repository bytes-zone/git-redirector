#!/usr/bin/env python3
import sys

with open(sys.argv[1], 'r') as fh:
    sources = [line.split() for line in fh.read().strip().split('\n')]

# preamble
print("""\
user nobody nobody;
daemon off;
error_log /dev/stdout info;
pid /dev/null;

events {}

http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;

    access_log /dev/stdout;

    server {
        listen 80;
        server_name git.bytes.zone;

        location /health {
            return 200 'OK';
            add_header Content-Type text/plain;
        }

        location / {
            return 301 $scheme://github.com$request_uri;
        }\
""")

for (src, dest) in sources:
    print()
    print(f"        location ~* ^/{src}$ {{")
    print(f"            return 301 https://github.com/{dest};")
    print("        }")
    print()
    print(f"        location ~* ^/{src}/commit/([0-9a-f]+)$ {{")
    print(f"            return 301 https://github.com/{dest}/commit/$1;")
    print("        }")
    print()
    print(f"        location ~* ^/{src}/src/branch/(.+)$ {{")
    print(f"            return 301 https://github.com/{dest}/blob/$1;")
    print("        }")

print("    }")
print("}")
