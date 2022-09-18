ARG BUNDLER_VERSION=2.3.11
ARG BUNDLE_PATH_DEFAULT=/home/app/bundle

FROM ruby:3.1-alpine as builder
ARG BUNDLER_VERSION
ARG BUNDLE_PATH_DEFAULT
ENV BUNDLE_PATH=$BUNDLE_PATH_DEFAULT

# to build gems native extensions
RUN apk add --update --no-cache \
    gcc \
    g++ \
    libc-dev \
    libpq-dev \
    make

RUN gem install bundler -v "${BUNDLER_VERSION}"

WORKDIR /home/app/code

COPY Gemfile Gemfile.lock ./

RUN bundle check || bundle install

COPY . ./


FROM ruby:3.1-alpine
ARG BUNDLER_VERSION
ARG BUNDLE_PATH_DEFAULT
ENV BUNDLE_PATH=$BUNDLE_PATH_DEFAULT
ENV TZ=Europe/Moscow

COPY --from=builder $BUNDLE_PATH $BUNDLE_PATH

# to run gems native extensions
RUN apk add --update --no-cache \
    libpq \
    tzdata

WORKDIR /home/app/code

COPY . ./

CMD ["sh", "-c", "bundle exec rake db:setup && bundle exec rake bot:run"]
