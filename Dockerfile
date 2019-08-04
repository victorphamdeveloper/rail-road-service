# Base image
FROM ruby:2.6


ENV APP_HOME /app
ENV APP_PORT 3000

WORKDIR $APP_HOME

# Installation of dependencies
RUN apt-get update \
  && apt-get install -y \
  build-essential \
  libpq-dev \
  libicu-dev \
  git \
  curl \
  cmake pkg-config \
  nodejs \
  && rm -rf /var/lib/apt/lists/*

# Add our Gemfile
# and install gems
ADD Gemfile* $APP_HOME/
RUN bundle install

# Copy over our application code
ADD . $APP_HOME

# Listen on specific port
EXPOSE $APP_PORT

# Run our app
ENTRYPOINT [ "bundle" , "exec", "rails", "server", "-b", "0.0.0.0"]
