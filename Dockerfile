FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install -y vim git curl zsh ruby locales fontconfig \
    python-software-properties software-properties-common

# tmux 2.3
RUN apt-get update
RUN add-apt-repository -yu ppa:pi-rho/dev
RUN apt-get install -y tmux-next=2.7~20171218~bzr4009+21-1ubuntu1~ppa0~ubuntu16.04.1

RUN gem install tmuxinator

RUN adduser --shell /bin/zsh --gecos 'kotu' --disabled-password kotu
RUN adduser kotu sudo

ENV HOME /home/kotu
WORKDIR $HOME

# add env variables 
ENV DOTFILES_DIR $HOME/dotfiles
ENV GITHUB_TOKEN f651db0c9da4e2b472a142057b42b6531a1a43a7
ENV GITHUB_USER kotu-pl
ENV GITHUB_REPO dotfiles_new
ENV GITHUB_BRANCH master
ENV TERM xterm-256color
# set locales
RUN locale-gen "en_US.UTF-8"
RUN LC_ALL=en_US.UTF-8
RUN LANG=en_US.UTF-8

USER kotu

# ADD rules prevents caching
ADD https://$GITHUB_TOKEN:x-oauth-basic@api.github.com/repos/$GITHUB_USER/$GITHUB_REPO/git/refs/heads/$GITHUB_BRANCH /tmp/version.json
RUN git clone -b $GITHUB_BRANCH https://$GITHUB_TOKEN:x-oauth-basic@github.com/$GITHUB_USER/$GITHUB_REPO.git $DOTFILES_DIR
RUN chmod +x $DOTFILES_DIR/install
RUN $DOTFILES_DIR/install

LABEL maintainer="Marcin Kot marcin@kotu.pl" \
      version="1.0"

CMD ["zsh", "-l"]
