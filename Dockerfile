FROM python:3.14.3 AS build

COPY src /app
RUN python /app/nginx_config.py /app/sources.txt > /app/nginx.conf

FROM nginx:1.29.4

COPY --from=build /app/nginx.conf /etc/nginx/nginx.conf
