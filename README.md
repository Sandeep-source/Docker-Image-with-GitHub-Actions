# Docker-Image-with-GitHub-Actions
  This repo provides guide to creating a simple pipeline to build and docker image artifacts to dockerhub repo as changes take place in github main branch.
  
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
