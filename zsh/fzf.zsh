# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/jsteeleiv/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/jsteeleiv/.fzf/bin"
fi

# Auto-completion
# ---------------
source "/Users/jsteeleiv/.fzf/shell/completion.zsh"

# Key bindings
# ------------
source "/Users/jsteeleiv/.fzf/shell/key-bindings.zsh"
