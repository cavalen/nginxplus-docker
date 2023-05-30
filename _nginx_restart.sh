#docker exec -ti nginxplus-lab /bin/bash
docker exec -ti nginxplus-lab nginx -s reload
docker logs nginxplus-lab