FROM httpd:latest
COPY ./html/ /usr/local/apache2/htdocs/
EXPOSE 90
