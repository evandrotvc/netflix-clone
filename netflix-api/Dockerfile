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
COPY Gemfile Gemfile.lock ./

# Copy our files to the netflix.
COPY . ./

RUN gem install bundler -v $BUNDLER_VERSION \
  && bundle config build.nokogiri --use-system-libraries \
  && bundle config set --local without 'production' \
  && bundle install