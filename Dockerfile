FROM ruby:2.1.5

RUN curl -O http://download.linuxaudio.org/lilypond/binaries/linux-64/lilypond-2.18.2-1.linux-64.sh \
    && sh lilypond-2.18.2-1.linux-64.sh \
    && rm lilypond-2.18.2-1.linux-64.sh

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app

CMD ruby app.rb -o 0.0.0.0
