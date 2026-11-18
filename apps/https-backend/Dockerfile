# The app serves HTTPS itself on 8443 with a self-signed certificate,
# for protocol: https (the proxy talks TLS to the app).
FROM nginx:1.30-alpine
RUN apk add --no-cache openssl \
 && openssl req -x509 -newkey rsa:2048 -nodes -days 30 -subj "/CN=localhost" \
      -keyout /etc/nginx/key.pem -out /etc/nginx/cert.pem
COPY apps/https-backend/default.conf /etc/nginx/conf.d/default.conf
