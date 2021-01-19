FROM rails:4.2.5

# RUN apt-get update \
#     && apt-get install -y --no-install-recommends \
#         postgresql-client \
#     && rm -rf /var/lib/apt/lists/*

COPY /usr/local/bundle /usr/local/bundle
WORKDIR /usr/src/app
COPY src/Gemfile* ./
RUN bundle install --local
COPY src/. .

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]