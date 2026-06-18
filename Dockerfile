FROM python:3.14.6 AS build

COPY src /app
RUN python /app/nginx_config.py /app/sources.txt > /app/nginx.conf

FROM nginx:1.31.2

COPY --from=build /app/nginx.conf /etc/nginx/nginx.conf
