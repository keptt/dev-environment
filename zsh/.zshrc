export PATH="$(go env GOPATH)/bin:$PATH"
export EDITOR=nvim
export TERM=xterm
export HISTSIZE=10000
export SAVEHIST=50000

PS1="%n@%m %1~ %# 🔵 "

function zz() {
  local tmp="$(mktemp)"
  yazi "$@" --cwd-file="$tmp"
  if [[ -s "$tmp" ]]; then
    cd "$(cat "$tmp")"
  fi
  rm -f "$tmp"
}
