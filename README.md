# Dotfiles

## Install

```shell
git clone git@github.com:taq-fujihara/dotfiles.git
cd dotfiles
./setup.xxx.sh
```

## Dev

```shell
cd dotfiles
docker build -t my-dotfiles .
docker run --rm --name my-dotfiles -it -v ~/dotfiles:/home/dev/dotfiles -w /home/dev/dotfiles my-dotfiles:latest /bin/bash
cd dotfiles
./install.sh
```
