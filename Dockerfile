# syntax=docker/dockerfile:1
# For Ubuntu 20.04:
FROM ubuntu:focal

# Install prerequisite packages:
RUN apt-get update && apt-get install -y apt-transport-https lsb-release ca-certificates tzdata wget gnupg2 vim nano curl wget jq

# Download and add NGINX, NAP, Updates signing keys:
RUN wget https://cs.nginx.com/static/keys/nginx_signing.key && apt-key add nginx_signing.key \
    && wget https://cs.nginx.com/static/keys/app-protect-security-updates.key && apt-key add app-protect-security-updates.key \
    && set -x \
    && addgroup --system --gid 101 nginx \
    && adduser --system --disabled-login --ingroup nginx --no-create-home --home /nonexistent --gecos "nginx user" --shell /bin/false --uid 101 nginx \
    && ln -fs /usr/share/zoneinfo/America/Bogota /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

# Add NGINX Plus repository:
RUN printf "deb https://pkgs.nginx.com/plus/ubuntu `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-plus.list

# Add NGINX App-protect repository & updates:
RUN printf "deb https://pkgs.nginx.com/app-protect/ubuntu `lsb_release -cs` nginx-plus\n" | tee /etc/apt/sources.list.d/nginx-app-protect.list
RUN printf "deb https://pkgs.nginx.com/app-protect-security-updates/ubuntu `lsb_release -cs` nginx-plus\n" | tee -a /etc/apt/sources.list.d/nginx-app-protect.list

# Download the apt configuration to `/etc/apt/apt.conf.d`:
RUN wget -P /etc/apt/apt.conf.d https://cs.nginx.com/static/files/90pkgs-nginx

# Update the repository and install the most recent version of the NGINX Plus, NAP, Signature, Threat Campaigns, NJS
RUN --mount=type=secret,id=nginx-crt,dst=/etc/ssl/nginx/nginx-repo.crt,mode=0644 \
    --mount=type=secret,id=nginx-key,dst=/etc/ssl/nginx/nginx-repo.key,mode=0644 \
    apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get install -y app-protect app-protect-attack-signatures app-protect-threat-campaigns nginx-plus-module-njs \
    && apt clean all \
    && rm -rf /var/lib/apt/lists/*

# Forward request logs to Docker log collector:
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Copy configuration files to image
#COPY nginx/nginx.conf /etc/nginx/
#COPY nginx/custom_log_format.json /etc/nginx/
#COPY nginx/conf.d/nginxapi.conf /etc/nginx/conf.d/
#COPY nginx/conf.d/example.com.conf /etc/nginx/conf.d/
#COPY nginx/ssl /etc/nginx/ssl

COPY entrypoint.sh /root/

EXPOSE 80 443 8080 8443 9090 
CMD ["sh", "/root/entrypoint.sh"]
