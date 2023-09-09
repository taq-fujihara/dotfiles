# Dotfiles

## Install

```shell
curl -fsSL https://raw.githubusercontent.com/taq-fujihara/dotfiles/main/install.sh | bash
```

## Dev

```shell
cd dotfiles
docker build -t my-dotfiles .
docker run --rm --name my-dotfiles -it -v ~/dotfiles:/home/dev/dotfiles -w /home/dev/dotfiles my-dotfiles:latest /bin/bash
```
