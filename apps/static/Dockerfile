# Static site: nginx with /health and a 20 MB file to test large downloads.
FROM nginx:1.30-alpine
COPY apps/static/default.conf /etc/nginx/conf.d/default.conf
COPY apps/static/index.html /usr/share/nginx/html/index.html
RUN head -c 20971520 /dev/urandom > /usr/share/nginx/html/big.bin \
 && sha256sum /usr/share/nginx/html/big.bin | cut -d' ' -f1 > /usr/share/nginx/html/big.bin.sha256
