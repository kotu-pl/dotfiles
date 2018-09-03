Installation:

```
git clone https://github.com/kotu-pl/dotfiles.git ~/dotfiles
chmod +x ~/dotfiles/install
~/dotfiles/install
```

Dockerfile for Arch Linux:

```
FROM base/archlinux

RUN pacman -Syu sudo vim ruby git curl zsh tmux fontconfig --noconfirm

RUN gem install rubocop

RUN useradd -m -G wheel -s /bin/zsh tester

ENV HOME /home/tester
WORKDIR $HOME

# add env variables
ARG DOTFILES_DIR=$HOME/dotfiles
ARG GITHUB_USER=kotu-pl
ARG GITHUB_REPO=dotfiles
ARG GITHUB_BRANCH=master

# TMUX
ENV TERM xterm-256color
ENV ZSH_TMUX_AUTOSTART=true

# set locales
RUN sed -i 's/#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
RUN locale-gen
ENV LC_CTYPE en_US.UTF-8
ENV LANG en_US.UTF-8

# passwordless sudo
RUN echo "tester ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER tester

# ADD rules prevents caching
ADD https://api.github.com/repos/$GITHUB_USER/$GITHUB_REPO/git/refs/heads/$GITHUB_BRANCH /tmp/version.json
RUN git clone -b $GITHUB_BRANCH https://github.com/$GITHUB_USER/$GITHUB_REPO.git $DOTFILES_DIR
RUN chmod +x $DOTFILES_DIR/install
RUN $DOTFILES_DIR/install

LABEL maintainer="Marcin Kot marcin@kotu.pl" \
      version="1.0"

CMD ["zsh", "-l"]
```

Dockerfile for Ubuntu: 

```
FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install -y vim git curl zsh ruby locales fontconfig \
    python-software-properties software-properties-common

# tmux 2.3
RUN apt-get update
RUN add-apt-repository -yu ppa:pi-rho/dev
RUN apt-get install -y tmux-next=2.7~20171218~bzr4009+21-1ubuntu1~ppa0~ubuntu16.04.1

RUN gem install tmuxinator rubocop

RUN adduser --shell /bin/zsh --gecos 'tester' --disabled-password tester
RUN adduser tester sudo

ENV HOME /home/tester
WORKDIR $HOME

# add env variables
ARG DOTFILES_DIR=$HOME/dotfiles
ARG GITHUB_USER=kotu-pl
ARG GITHUB_REPO=dotfiles
ARG GITHUB_BRANCH=master

# TMUX
ENV TERM xterm-256color
ENV ZSH_TMUX_AUTOSTART=true

# set locales
RUN locale-gen "en_US.UTF-8"
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LANG en_US.UTF-8

USER tester

# ADD rules prevents caching
ADD https://api.github.com/repos/$GITHUB_USER/$GITHUB_REPO/git/refs/heads/$GITHUB_BRANCH /tmp/version.json
RUN git clone -b $GITHUB_BRANCH https://github.com/$GITHUB_USER/$GITHUB_REPO.git $DOTFILES_DIR
RUN chmod +x $DOTFILES_DIR/install
RUN $DOTFILES_DIR/install

LABEL maintainer="Marcin Kot marcin@kotu.pl" \
      version="1.0"

CMD ["zsh", "-l"]
```

111
