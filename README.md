# Docker-Image-with-GitHub-Actions
   This repo provides a guide 📗 to creating a simple pipeline to build ⚙ and upload docker 🐳 image artifacts to the docker hub 🐳 repo with the help of GitHub actions
 as changes take place in GitHub main branch.
 
## Prerequisites
   1. Docker 🐳 basics.
      - [introduction to docker 🐳](https://youtu.be/17Bl31rlnRM)
      - [Docker 🐳 complete course](https://youtu.be/3c-iBn73dDE)
       
   1. Yaml 📄 basics
      - [Yaml 📄 tutorial](https://youtu.be/1uFVr15xDGg)
      - [Yaml 📄 Complete course](https://youtu.be/IA90BTozdow)

## Note
If you are viewing this page from GitHub pages then some code for GitHub secrets will not be shown, you will only 
see a $ sign. Check out GitHub repo from 👉[Here](https://github.com/Sandeep-source/Docker-Image-with-GitHub-Actions)
for the correct code.

## Scanario

   For this demo, the application is to be dockerized 🐳 in a static site. It is a simple game of guessing 🤔 numbers between 0 0️⃣ to 9 9️⃣. You access this page 
   [Here](https://sandeep-source.github.io/Docker-Image-with-GitHub-Actions/src/)
   
   ![Screenshot](https://user-images.githubusercontent.com/61611561/202146123-80da9007-d472-48ce-ad0c-de3eab997eab.png)

## Repository structure

   ```
   /src
     index.html
     index.css
   /Dockerfile
   /README.md
   ```
  Let's take a look 👀 at source files 🗃

   1. `/src` - This folder contains source files 📁 for our static site.
   1. `Dockerfile` - This is a basic Dockerfile 🐳 which specifies how the image should be built from the source. We will take a look 👀 at this in a moment.
   3. `README.md` - This is the file 📄 you currently reading.
 
## Dockerfile

Dockerfile 🐳 provides a set of instuctions to build ⚙ the image. For this repo it looks 👀 like the following.
          
   ```Dockerfile
    FROM nginx
    ADD src/* /usr/share/nginx/html/
    EXPOSE 80
    CMD ["nginx","-g","daemon off;"]
   ```
   
Let's take a look 👀 at each instruction to understand what these instructions mean

   1. `FROM nginx` - This line tells docker 🐳 to use Nginx 🆖 as the official image as a base image for our new image.
   2. `ADD src/* /usr/share/nginx/html/` - This line copies files 🗃 of `src` folder inside the `/usr/share/nginx/html/` folder of image. `/usr/share/nginx/html/` folder is used by the nginx 🆖 server as entry point of website.
   3. ```EXPOSE 80``` - This line tells docker 🐳 to open port 80 inside the docker 🐳 container so that we can communicate with the nginx 🆖 server inside.
   4. ```CMD ["nginx","-g","daemon off;"]``` - This last cline starts Nginx 🆖 server and runs ▶ every time the docker 🐳 container start.

It's all about what we need to get started. Let's take a look 👀 how to setup GitHub actions to create a pipeline.

## Steps to create 🛠 a pipeline
### Create github workflow

   1. Open github repo and click on actions option.
   2. Search 🔍 for Simple workflow and select the most suitable from the option that appeared.
   3. Rename the file 📄 with the name you want for your workflow.

### Writing Code 👨‍💻 for workflow

  1. Replace 🔁 the code 👩‍💻 of workflow with the following.
  
      ```yaml
      name:
      on:
      jobs:

     ``` 
     Let's understand 🤔 what this code 👩‍💻 means
     
     - The lines starting with # represents comments in YAML.
     - ```name:``` - Defines the name for your workflow.
     - ```on:``` - When we create a GitHub action, we want the action to run ▶ on certain events i.e push to a branch. This `on` parameter describes the events in which the action is going to run ▶.
     - ```jobs:``` - jobs work section is the place where we define what going to happen when events specified in the `on:` section occurs.
     
 2. Give a name to your workflow
 
     ```yaml
     name: Docker image CI
     ```
     
 3. Specify the event of our interest in this case push event
 
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
        
 4. Now the remaining part of the workflow is jobs section. Jobs define the set of actions (Tasks) to be performed. These action can run ▶  sequentially or in parallel.
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
 
      - `runs-on:` - Tells 📢 the platform on which this job(Task) is going to run ▶ on. For this demo, we are taking 'ubuntu-latest'.
      - `steps:` - This defines a set of steps to be performed to get the job done.
      - Now our code 👩‍💻 will look 👀 like this. 
      
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
           
     Each step in steps walk section has the following parts
      
       - `name:` - name of the step
       - `run:` - set of command 💻 to run ▶ 
       - `uses:` - rerefence of any other action which is used by the current steps. The referenced action will run ▶ first.`optional`
       - Apart from these, there are many other optional parts.
        
 5. Add the following code 👨‍💻 in the steps section
 
    ```yaml
    - uses: actions/checkout@v3
    - name: Build the Docker image
      run: |
    ```
    
    - notice `|` after `run:` this allows us to write multiple commands 💻.
  
 6. To build ⚙ image add the following command 💻 to the `Build the Docker image` step and replace `<image_name>` With the name of your choice.
 
    ```yaml
     docker build . --file Dockerfile --tag <image_name>
    ```
    
    - Now our file 📄 look 👀 something like this
    
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

    - Notice 📝 the uses part specifies `actions/checkout@v3`. This action checks if our repository is present and if we have access to it.
    - Command 💻 `docker build . --file Dockerfile --tag hackthenumber` builds ⚙ an image named hackthenumber it is currently stored at the local system at which the job is running.
    
7. Login 🔐 to dockerhub 🐳

    To make push the image to the docker hub 🐳 we need to login to the docker hub 🐳. Docker recommends creating access tokens for logins 🔐 instead of using password 🔑.
    - Creating dockerhub 🐳 Access token 🗝
    
      - To create an access token login 🔐 to docker hub 🐳. Goto access `Account Setting > Security > New Access token`.
       
        ![acc](https://user-images.githubusercontent.com/61611561/202457175-6c55497d-596a-4537-831a-d4f59041400f.png)
       
        ![security](https://user-images.githubusercontent.com/61611561/202457235-8dcde5f3-e603-4a56-a278-ce77beb0d9b9.png)



      - Enter description for the token and click generate ⚙.
      - Select `Copy and Close`.
      
    - Adding passwords 🔑 directly to workflow files 📄 can be a potential threat. To make this secure GitHub provides secrets to store passwords 🔑 etc. To add the secrets to GitHub repo do the following.
    
      - Goto your repo.
      - Open Settings 🔧.
      - Select `Secret > Actions > New Repository Secret`
      - Add DOCKERHUB as name and your docker hub username as secret.
      - Add another secret for TOKEN as the name and paste the access token you generated ⚙ in the previous step.
      
    - Login 🔐 to Dockerhub 🐳
    
      - Add the following lines to run part to login 🔐
      
        ```yaml
        docker login -u ${{secrets.USERNAME}} -p ${{secrets.TOKEN}}
        ```
        
8. Tag image to refer to Dockerhub 🐳 repo

   - To tag image add the following command 💻 by replacing `<image_name>` with the image name you have choosen for your image
   
     ```yaml
     docker tag <image_name> ${{secrets.USERNAME}}/<image_name> 
     ```
    
   - With our choosen name it will look 👀 like something this
    
     ```yaml
     docker tag hackthenumber ${{secrets.USERNAME}}/hackthenumber
     ```
    
9. Add the following line to push image to dockerhub 🐳

    ```yaml
    docker push ${{secrets.USERNAME}}/hackthenumber
    ```
    
 Now our file 📄 will look 👀 like something this
 
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
                      docker login -u ${{secrets.USERNAME}} -p ${{secrets.TOKEN}}
                      docker tag hackthenumber ${{secrets.USERNAME}}/hackthenumber
                      docker push ${{secrets.USERNAME}}/hackthenumber
   ```
   
## Quick Test deployed image

 - Go to https://labs.play-with-docker.com and login 🔐 with dockerhub 🐳 credentials.
 - Click start and then Add New Instance.
 
     ![image](https://user-images.githubusercontent.com/61611561/202459374-7e24e6b2-458c-408e-9911-4fb18e88f01e.png)
   
     ![Add instance](https://user-images.githubusercontent.com/61611561/202459763-11efed48-3ab4-4194-bde8-e960d41eaefd.png)
     
 - Run ⚙ the command 💻 `docker run -dp 8080:80 <username>/<image_name>` by replacing `<username>` with the dockerhub username and `<image_name>` with the image name used in the GitHub action. For example
 
   ```bash
   docker run -dp 8080:80 sandeepsource/hackthenumber
   ```
   
  - Click the port number `8080` on the right side of the open port button. If the button for port `8080` not appeared then click the `open port` button and enter 8080 and click ok.
  
    ![open port](https://user-images.githubusercontent.com/61611561/202462363-224ccd86-29a7-448e-afd4-ce90901d009b.png)
    
  
  - Now if everything is gone well 🙌 you will able to see following output.
  
    ![output](https://user-images.githubusercontent.com/61611561/202462572-e481e050-0a96-42fd-ac2e-e42513626447.png)




 
 
   
     
    
       
      
      
   
   
    
 
   
   
