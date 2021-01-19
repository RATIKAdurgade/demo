FROM rails:4.2.5

# RUN apt-get update \
#     && apt-get install -y --no-install-recommends \
#         postgresql-client \
#     && rm -rf /var/lib/apt/lists/*

# COPY /usr/local/bundle/bin /usr/local/bundle/bin
# COPY /usr/local/bundle/build_info /usr/local/bundle/build_info
# COPY /usr/local/bundle/cache /usr/local/bundle/cache
# COPY /usr/local/bundle/extensions /usr/local/bundle/extensions
# COPY /usr/local/bundle/gems /usr/local/bundle/gems
# COPY /usr/local/bundle/specifications /usr/local/bundle/specifications
# ADD /usr/local/bundle /usr/local/bundle
WORKDIR /usr/src/app
COPY src/Gemfile* ./
RUN bundle install
COPY src/. .

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]