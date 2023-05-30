docker build -t cavalen/nginxplus-lab --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key --platform linux/amd64 . 
