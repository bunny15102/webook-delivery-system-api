FROM ruby:3.2.2

RUN apt-get update && apt-get install -y \
    build-essential \
    nano \
    nodejs \
    default-mysql-client

RUN mkdir /webook-delivery-system-api
WORKDIR /webook-delivery-system-api

COPY Gemfile ./

# Install gems
#RUN bundle install

#Docker build image 
#docker build -t webhook-delivery-image .
#can give image name of your choice

#Docker run container 
#docker run -p 7000:7000 --name webook-delivery-app  -v $(pwd):/webook-delivery-system-api -d -it webhook-delivery-image
#can give port of your choice
#can give container name of your choice