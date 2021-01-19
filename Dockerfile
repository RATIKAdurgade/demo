FROM rails:4.2.5
WORKDIR /usr/src/app
COPY bundle/ /usr/local/bundle
COPY src/Gemfile* ./
RUN bundle install --local
COPY src/. .

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]