### Moving Cursor setup from one computer to another

1. Export files on one PC:

- Open Cursor
- Cmd+P + ">", type: "Preferences: Open User Settings (JSON)" and store the contents as `settings.json`
- Cmd+P + ">", type: "Open Keyboard Shortcuts (JSON)" and store the contents as `keybindings.json`
- Export or copy snippet files if any.
- Export or copy extension-list with (run from current dir):

```sh
cursor --list-extensions > vscode-extensions.txt
```

Store any .vscode directories with important custom debugger configs etc.

2. Import files on the other PC:

- Open Cursor
- Cmd+P + ">", type: "Preferences: Open User Settings (JSON)" and store the contents as `settings.json`
- Cmd+P + ">", type: "Open Keyboard Shortcuts (JSON)" and store the contents as `keybindings.json`
- Copy snippets back.
- Install extensions via command line with (run from current dir):

```sh
cat vscode-extensions.txt | xargs -L 1 cursor --install-extension
```

You may also create the transfer the .vscode dir for a custom debugger config.
