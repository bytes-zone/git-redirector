FROM python:3.14.4 AS build

COPY src /app
RUN python /app/nginx_config.py /app/sources.txt > /app/nginx.conf

FROM nginx:1.30.0

COPY --from=build /app/nginx.conf /etc/nginx/nginx.conf
