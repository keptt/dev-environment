Install yazi:

```sh
brew install yazi
```

add the file with keymaps:

```sh
cp keymap.toml ~/.config/yazi/keymap.toml
```

add the following function to the `~/.zschrc`:

```sh
function zz() {
  local tmp="$(mktemp)"
  yazi "$@" --cwd-file="$tmp"
  if [[ -s "$tmp" ]]; then
    cd "$(cat "$tmp")"
  fi
  rm -f "$tmp"
}
```

source the file:

```sh
. ~/.zshrc
```

Run yazi with `zz`
