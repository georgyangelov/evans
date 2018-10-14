FROM ruby:2.3-alpine
RUN apk add --no-cache \
    build-base \
    libxml2-dev \
    libxslt-dev \
    postgresql-dev \
    graphicsmagick \
    tzdata \
    nodejs

RUN bundle config build.nokogiri --use-system-libraries

WORKDIR /evans

COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

COPY . .

EXPOSE 3000

CMD ["sh", "-c", "bundle exec rake db:create db:migrate db:seed assets:precompile && bundle exec puma -b tcp://0.0.0.0:3000"]
