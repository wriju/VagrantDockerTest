#!/usr/bin/env bash
# ************* SAVE WITH UNIX-STYLE LINE ENDINGS *************

#use a new directory for nginx docker config
docker_nginx=/home/vagrant/docker_nginx

#placeholder string in nginx.conf file - replace with real IP's
placeholder_ips="#container_ips"

#copy needed files
#docker reqires the nginx.conf file to be in same context as Dockerfile
echo "copying files"
rm -r $docker_nginx
mkdir $docker_nginx
cp /vagrant/Nginx/nginx.conf $docker_nginx/nginx.conf
cp /vagrant/Docker/Dockerfile $docker_nginx/Dockerfile
echo "done copying"

#get the ip's of the running containers
web1_ip="$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' web1)"
web2_ip="$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' web2)"
web3_ip="$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' web3)"

#configure nginx - replace the container_ips_placeholder with container IP's
#container_ips="server $web1_ip;\n\tserver $web2_ip;\n\tserver $web3_ip;"
real_ips="server $web1_ip;"
sed -i "s/$placeholder_ips/$real_ips/" $docker_nginx/nginx.conf

echo "assigned IP's $web1_ip, $web2_ip, $web3_ip"