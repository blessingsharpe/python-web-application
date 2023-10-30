# python-web-application
Deploying python application to a cluster


docker ps 
docker images
use any image from docker hub, i choise nginx latest pulled nginx image from docker hub
docker run -d -p 5000:5000 --name docker-registry-nginx nginx:latest

binding host port 5000 to container port 5000 in detach mode, creating a new container(dockerregistry-nginx) using nginx latest image 
docker ps to see container running(means our dockerresgistry is running now)


how to check if this regisry has images inside?
for this, get ip of local machine first using ip addr for terminal or ubuntu and ipconfig for gitbash
172.25.208.1   ipv4 is the ip address
 ******curl -X GET http://172.25.208.1:5000/v2/_catalog

  "insecure-registries":["172.25.208.1:5000"]     
 add this to your docker daemon json file on docker desktop or in /etc/docker/daemon.json

no need using this as i used the one below docker run -d -p 5000:5000 --name docker-registry-nginx nginx:latest
 *******docker run -d -p 5000:5000 --restart=always --name docker-registry-nginx -v $(pwd)/docker-registry:/var/lib/docker-registry-nginx nginx:latest
now local dockder registry is running, i cd to local docker registry folder and saw that i had some running containers but i want to test  if i can tag an existing image like nginx to nginx-v2 and push to this new docker registry specifying it's full path like(ip address and portnumber)
******docker tag nginx 172.25.208.1:5000/nginx-v2    (i was able to tag it)

*****docker ps to see new tagged image 

now let me push it to local docker registry but this would require some security protocol like TLS/SSL but since this is for testing, i would add an "insecure-regsitries" line to my docker/daemon.json file to bypass this error

****docker push 172.25.208.1:5000/nginx-v2 and i got an error



ERRORS with PROJECT
while trying to create the container for the docker rgeistry, i had an error saying the port number of my host is already in use which was port 5000 so i used port 5001
second error was the container name i was trying to use was already in use, so i had check all running containers and stop the particular container with the name i wanted and deleted it as i was not using the container at that time, i reran the docker run command and it worked 

while trying to push new tagged image to registry, i got an error saying "server gave http response to https client" which means it needed TLS certificates authentication to make it secure for https response so this was where i had to add the "insecure-registries" to the docker daemon json file and restart docker desktop or server to tell it the regisry is secure 

i got this error below when i tried to push to local docker registry
docker push  172.25.208.1:5000/nginx-v2
Using default tag: latest
The push refers to repository [172.25.208.1:5000/nginx-v2]
Get "http://172.25.208.1:5000/v2/": EOF

what i did to solve it was go to my docker desktop and configured my docker client to use the http proxy settings 

