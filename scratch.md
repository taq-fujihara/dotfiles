
## change login shell

```shell
chsh
```

## fish

### fisher

```shell
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

cd ~/.config/fish
for p in (cat fishfile); fisher install $p; end
```

