# Dockerfile
FROM ruby:3.0.0

# Add yarn from repository
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

#Install required package
RUN apt-get update -qq \
&& apt-get install -y \
apt-utils \
nodejs \
yarn \
nano

#Create directory docker-rails
RUN mkdir /docker-rails

# Change directory to docker-rails
WORKDIR /docker-rails

# Copy created Gemfile & Gemfile.lock to docker container
COPY Gemfile /docker-rails/Gemfile
COPY Gemfile.lock /docker-rails/Gemfile.lock

# Install dependencies
RUN bundle install

COPY . /docker-rails

EXPOSE 3000 3035

CMD ["rails", "server", "-b", "0.0.0.0"]
