# For showing that it works in Docker
FROM ruby:2.2.10
MAINTAINER brianwisti@pobox.com
ENV REFRESHED_AT 2018-05-15

RUN apt-get update && apt-get install -y \
  build-essential \
  locales \
  nodejs

# base directory for further RUN, COPY, ENTRYPOINT commands
RUN mkdir -p /app
WORKDIR /app

# Use en_US.UTF-8 as locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && \
  bundle install --jobs 20 --retry 5

# Make port 3000 available to the world
EXPOSE 3000

ENTRYPOINT ["bundle", "exec"]

# Get'er done
CMD ["rails", "server", "-b", "0.0.0.0"]
