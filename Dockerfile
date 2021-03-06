FROM rails:4.2.5
WORKDIR /usr/src/app
COPY bundle/ /usr/local/bundle
COPY src/Gemfile* ./
RUN bundle install --local
ADD src /usr/src/app
RUN ls -alR /usr/src/app/config
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]