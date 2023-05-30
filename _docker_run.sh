#docker rm -f nginxplus-lab
#docker run --name httpecho -d -p 8080:8080 -p 8443:8443 mendhak/http-https-echo:29
#docker run --name f5demoapp -d -p 8080:80 -e F5DEMO_APP="website" -e F5DEMO_NODENAME="F5 K8S vLab" -e F5DEMO_COLOR="009639" cavalen/f5-demo-httpd:nginx
docker run --name nginxplus-lab -d -p 80:80 -p 443:443 -p 9090:9090 \
  --mount type=bind,source="$(pwd)"/nginx/ssl/,target=/etc/nginx/ssl \
  --mount type=bind,source="$(pwd)"/nginx/conf.d/,target=/etc/nginx/conf.d \
  --mount type=bind,source="$(pwd)"/nginx/waf,target=/etc/nginx/waf \
  --mount type=bind,source="$(pwd)"/nginx/nginx.conf,target=/etc/nginx/nginx.conf \
  nginxplus-lab 
