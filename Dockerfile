# Use the official Ruby image as a base
FROM ruby:3.2.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  build-essential \
  libpq-dev \
  nodejs \
  yarn \
  redis \
  git && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install Ruby gems
RUN gem install bundler && bundle install

# Copy application code
COPY . .

# Expose port 3000
EXPOSE 3000

# Define the entry point script
ENTRYPOINT ["bundle", "exec"]

# Default command to run the Rails server
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]
