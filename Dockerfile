FROM rails:4.2.5
WORKDIR /usr/src/app
COPY src/Gemfile* ./
RUN bundle install --local
COPY src/. .
COPY bundle/ /usr/local/bundle

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]