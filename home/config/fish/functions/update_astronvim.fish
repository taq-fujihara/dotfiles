function update_astronvim
    set astro_root ~/.config/nvim

    echo 'Update AstroNvim'
    git -C $astro_root pull

    echo 'Update AstroNvim user configuration'
    git -C $astro_root/lua/user pull
end
