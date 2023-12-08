#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
if [ -f /app/tmp/pids/server.pid ]; then
  rm -f /app/tmp/pids/server.pid
fi

echo "Installing bundler"
gem install bundler -v 2.4.22 --force

echo "Bundle install"
bundle install

echo "Running database migrations"
bundle exec rake db:migrate

exec "$@"
