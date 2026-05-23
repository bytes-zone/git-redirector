FROM python:3.14.5 AS build

COPY src /app
RUN python /app/nginx_config.py /app/sources.txt > /app/nginx.conf

FROM nginx:1.31.1

COPY --from=build /app/nginx.conf /etc/nginx/nginx.conf
