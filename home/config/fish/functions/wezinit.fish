function wezinit -d "Setup wezterm panes"
    set -l window_type $argv[1]

    switch $window_type
        case 'dev'
          command wezterm cli split-pane --top
          command wezterm cli split-pane --left
          command wezterm cli adjust-pane-size --amount 8 Down
        case '*'
          command wezterm cli split-pane --left
          command wezterm cli split-pane --top
          command wezterm cli adjust-pane-size --amount 16 Right
    end
end
