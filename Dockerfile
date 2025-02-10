# syntax=docker/dockerfile:1.7-labs
FROM ruby:3.4

RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y sqlite3

WORKDIR /app

COPY Gemfile Gemfile.lock config.ru ./

RUN bundle install

COPY --parents setup.rb app.rb ./views/ ./public/ ./

RUN useradd appuser --create-home --shell /bin/bash 
RUN chown -R appuser:appuser /app

USER appuser:appuser

EXPOSE 4567/TCP
CMD [ "bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567" ]