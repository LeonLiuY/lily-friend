FROM ruby:2.1-onbuild

RUN curl -O http://download.linuxaudio.org/lilypond/binaries/linux-64/lilypond-2.18.2-1.linux-64.sh \
    && sh lilypond-2.18.2-1.linux-64.sh \
    && rm lilypond-2.18.2-1.linux-64.sh

CMD ruby app.rb -o 0.0.0.0
