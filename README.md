# Docker-Image-with-GitHub-Actions
   This repo provides guide to creating a simple pipeline to build and upload docker image artifacts to dockerhub repo
 as changes take place in github main branch.
 
## Prerequisites
   1. Docker basics.
      - [introduction to docker](https://youtu.be/17Bl31rlnRM)
      - [Docker complete course](https://youtu.be/3c-iBn73dDE)
       
   1. Yaml basics
      - [Yaml tutorial](https://youtu.be/1uFVr15xDGg)
      - [Yaml Complete course](https://youtu.be/IA90BTozdow)
## Scanario
   For this demo, the application to be dockerize in a static site.It is a simple game of guessing number between 0 to 9.
   
    ![Screenshot](https://user-images.githubusercontent.com/61611561/202146123-80da9007-d472-48ce-ad0c-de3eab997eab.png)

## Repository structure
   ```
   /src
     index.html
     index.css
   /Dockerfile
   /README.md
   ```
  Let's take a look at source files

   1. `/src` - This folder contains source files for our static site
   1. `Dockerfile` - This is a basic dockerfile which specifies how image shuld be vhiuld from the source. We will take a look at this in a moment.
   3. `README.md` - This is the file you currently reading.
 
## Dockerfile
Dockerfile provides a set of instuctions to build the image. For this repo it looks like the following.
          
   ```Dockerfile
    FROM nginx
    ADD src/* /usr/share/nginx/html/
    EXPOSE 80
    CMD ["nginx","-g","daemon off;"]
   ```
Let's take a look at the each instruction to understand what these instructions means

   1. `FROM nginx` - This line tells docker to use nginx as official image as a base image for our new image.
   2. `ADD src/* /usr/share/nginx/html/` - This line copies files of `src` folder inside the `/usr/share/nginx/html/` folder of image.     `/usr/share/nginx/html/` folder is used by the nginx server as entry point of website.
   3. ```EXPOSE 80``` - This line tells docker to open port 80 inside docker so that we can communicate with the nginx server inside.
   4. ```CMD ["nginx","-g","daemon off;"]``` - This last cline start nginx server and runs every time docker container start.

Its's all about what we need to get started let's take a look how to setup github actions to create a pipeline

## Steps to create a pipeline
### Create github workflow

   1. Open github repo and click on actions option.
   2. Search for Simple workflow and select from option appeared.
   3. Rename the file with the name you want for your workflow.

### Writing Code for workflow
  1. Replace the code of workflow with the following.
  
      ```yaml
      name:
      on:
      jobs:

     ``` 
     Let's understand what this code means
     
     - The lines starting with # represents comments in yaml.
     - ```name:``` - Defines the name for your workflow
     - ```on:``` - When we creating a github action, we want action to run on certain events i.e push to a branch. This `on` parameter describes the events in which the action is going to run.
     - ```jobs:``` - jobs section is the place where we define what going to happen when events sepecified in `on:` section occurs.
     
 2. Give a name to your workflow
 
     ```yaml
     name: Docker image CI
     ```
     
 3. Specify event of our interest in this case push event
 
     - Add event 
     
        ```yaml
        name: Docker image CI
        on:
          push:
        ```
        
     - Add branches for which we going to perform some action
     
        ```yaml
        name: Docker image CI
        on:
          push:
            branches: [ "main" ]
        ```
        
 4. Now the remaining part of the workflow is jobs section. Jobs defines the set of actions (Tasks) to be performed. These action can run sequentially or in parallel.
  for this demo we are just going to create one job named docker-build.
  
       ```yaml
       name: Docker image CI
       on:
          push:
            branches: [ "main" ]
       jobs:
          docker-build:
       ```
       
 5. Each job section has following things
 
      - `runs-on:` - Tells the platform on which this job(Task) is going to run on. For this demo we are taking 'ubuntu-letest'
      - `steps:` - This defines set of steps to be performed to get job done.
      - Now our code will look like this 
      
          ```yaml
           name: Docker image CI
           on:
              push:
                branches: [ "main" ]
           jobs:
              docker-build:
                   runs-on: ubuntu-latest
                   steps: 
           ```
           
     Each step in steps section has the following parts
      
       - `name:` - name of the step
       - `run:` - set of command to run 
       - `uses:` - rerefence of any other action which is used by the current steps. The referenced action will run first.`optonal`
       - Apart from these their are many other optional parts
        
 5. Add the following code in steps section
 
    ```yaml
    - uses: actions/checkout@v3
    - name: Build the Docker image
      run: |
    ```
    
    - notice `|` after `run: ` this allows as to write multiple commands.
  
 6. To build image add the following command to `Build the Docker image` step and replace `<image_name>` With name of your choice.
 
    ```yaml
     docker build . --file Dockerfile --tag <image_name>
    ```
    
    - Now our file look something like this
    
         ```yaml
           name: Docker image CI
           on:
              push:
                branches: [ "main" ]
           jobs:
              docker-build:
                   runs-on: ubuntu-latest
                   steps:
                      - uses: actions/checkout@v3
                      - name: Build the Docker image
                        run: |
                           docker build . --file Dockerfile --tag hackthenumber
         ```
    - Notice the uses part specify `actions/checkout@v3`. This action checks if our repository is present and we have access to it.
    - Command `docker build . --file Dockerfile --tag hackthenumber` builds an image named hackthenumber it is currently stored at the local system at which the job is running.
    
7. Login to dockerhub
    Inorder to make push image to docker hub we need to login to the dockerhub. Docker recommend to create access tokens for logins instead of using password.
    - Creating dockerhub Access token
    
      - To create a access token login to dockerhub. Goto access `Account Setting > Security > New Access token`.
      - Enter description for the token and click generate.
      - Select `Copy and Close`.
      
    - Adding passwords directly to workflow file can be a potential threat. To make this secure github provides secrets to store passwords etc. To add the secrets to github repo do the following.
    
      - Goto your repo.
      - Open Settings.
      - Select `Secret > Actions > New Repository Secret`
      - Add DOCKERHUB as name and your docker hub username as secret
      - Add another secret for TOKEN as name and paste access token you generated in previous step.
      
    - Login to Docker hub
    
      - Add the following lines to run to login 
        ```yaml
         docker login -u ${{secret.USERNAME}} -p ${{secret.TOKEN}}
        ```
        
8. Tag image to refer to Dockerhub repo

   - To tag image add the following command by replacing `<image_name>` with the image name you have choosen for your image
   
    ```yaml
         docker tag <image_name> ${{secret.USERNAME}}/<image_name> 
    ```
    
   - With our choosen name it will look like something this
   
    ```yaml
         docker tag hackthenumber ${{secret.USERNAME}}/hackthenumber
    ```
    
9. Add the following line to push image to dockerhub

    ```yaml
         docker push ${{secret.USERNAME}}/hackthenumber
    ```
    
 Now our file will look like something this
 ``` yaml
      name: Docker image CI
      on:
        push:
          branches: [ "main" ]
        jobs:
          docker-build:
               runs-on: ubuntu-latest
               steps:
                   - uses: actions/checkout@v3
                   - name: Build the Docker image
                     run: |
                           docker build . --file Dockerfile --tag hackthenumber
                           docker login -u ${{secret.USERNAME}} -p ${{secret.TOKEN}}
                           docker tag hackthenumber ${{secret.USERNAME}}/hackthenumber
                           docker push ${{secret.USERNAME}}/hackthenumber
 ```
 
 
   
     
    
       
      
      
   
   
    
 
   
   
