# Self-Signed TLS Certificate
openssl req -nodes -days 1095 -new -x509 -newkey rsa:4096 -keyout app.example.com.key -out app.example.com.crt -subj "/C=US/CN=app.example.com"
