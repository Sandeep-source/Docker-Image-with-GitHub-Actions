FROM nginx
ADD src/* /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx","-g","daemon off;"]
