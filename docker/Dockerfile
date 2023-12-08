# Use an official Ruby runtime as a parent image
FROM ruby:3.0.3

# Update & install packages
RUN apt-get update --fix-missing \
    && apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y default-libmysqlclient-dev nodejs

# Create application directory
RUN mkdir /app

# Set the working directory in the container
WORKDIR /app

# Copy Gemfile and Gemfile.lock and install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Move the files from the current directory to the container
COPY . .

# Add a script to be executed every time the container starts
COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]