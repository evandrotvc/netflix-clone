FROM ruby:3.1.2

ENV BUNDLER_VERSION='2.3.7'
ENV APP_USER=user

RUN apt-get update -qq && apt-get install -y vim\
        curl \
        build-essential \
        libpq-dev \
        postgresql-client && \
        curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
        apt-get update && apt-get install nodejs yarn

RUN useradd -ms /bin/bash $APP_USER

USER $APP_USER

WORKDIR /netflix-api

# Copy our files to the netflix.
COPY . ./

COPY --chown=$APP_USER Gemfile Gemfile.lock ./


RUN rm -rf $APP_USER/tmp/* \
  && rm -rf public/assets\
  && rm -rf public/packs


RUN gem install bundler -v $BUNDLER_VERSION

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle install

COPY --chown=$APP_USER . ./

RUN chmod +x entrypoints/docker-entrypoint.sh

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]
