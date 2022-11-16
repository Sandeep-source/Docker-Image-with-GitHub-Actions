# Docker-Image-with-GitHub-Actions
  This repo provides guide to creating a simple pipeline to build and upload docker image artifacts to dockerhub repo as changes take place in github main branch.
  
## Scanario
 For this demo, the application to be dockerize in a static site.
 
## Repository structure
 ```
 /src
   index.html
   index.css
 /Dockerfile
 /README.md
 ```
Let's take a look at source files
 1. ```/src``` - This folder contains source files for our static site
 1. ```Dockerfile``` - This is a basic dockerfile which specifies how image shuld be vhiuld from the source. We will take a look at this in a moment.
 3. ```README.md``` - This is the file you currently reading.
 
## Dockerfile
      Dockerfile provides a set of instuctions to build the image. For this repo it looks like the following.
```
FROM nginx
ADD src/* /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx","-g","daemon off;"]
```

Let's take a look at the each instruction to understand what these instructions means

1. ```FROM nginx``` - This line tells docker to use nginx as official image as a base image for our new image.
2. ```ADD src/* /usr/share/nginx/html/``` - This line copies files of ```src``` folder inside the ```/usr/share/nginx/html/``` folder of image. ```/usr/share/nginx/html/``` folder is used by the nginx server as entry point of website.
3. ```EXPOSE 80``` - This line tells docker to open port 80 inside docker so that we can communicate with the nginx server inside.
4. ```CMD ["nginx","-g","daemon off;"]``` - This last cline start nginx server and runs every time docker container start.

## Workflow to create pipeline

