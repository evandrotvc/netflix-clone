FROM ruby:3.1.2 AS netflix-development

ENV BUNDLER_VERSION='2.3.7'

RUN apt-get update -qq && apt-get install -y vim\
        curl \
        build-essential \
        libpq-dev \
        postgresql-client \
        libsqlite3-dev \
        sqlite3

WORKDIR /netflix
COPY Gemfile /netflix/Gemfile
COPY Gemfile.lock /netflix/Gemfile.lock

# Copy our files to the netflix.
# COPY . /netflix

RUN gem install bundler -v $BUNDLER_VERSION \
  && bundle config build.nokogiri --use-system-libraries \
  && bundle config set --local without 'production' \
  && bundle install