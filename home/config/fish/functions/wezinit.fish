function wezinit -d "Setup wezterm panes"
  wezterm cli split-pane --left
  wezterm cli split-pane --top
  wezterm cli adjust-pane-size --amount 16 Right
end
