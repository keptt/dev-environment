## Neovim installation steps for MacOS or Ubuntu (tested on jellyfish lts)


1. Install neovim:

* For MacOS:

```sh
brew install neovim
```

Note that to install neovim from source, the process is the same as for Ubuntu. However the following dependencies need to be installed:

```sh
brew install make cmake gettext
```

* For Ubuntu:

```sh
sudo apt-get install ninja-build gettext cmake curl build-essential
git clone https://github.com/neovim/neovim.git
cd neovim
git fetch origin
git checkout v0.11.1
make CMAKE_BUILD_TYPE=Release
sudo make install
```

2. Install packer to manage plugins:

```sh
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

3. Create a configuration directory:

```sh
mkdir -p ~/.config/nvim
```

4. Put neovim lua config file into the config directory:

```sh
cp init.lua ~/.config/nvim/init.lua
```

5. Install ripgrep:

* For MacOS:

```sh
brew install ripgrep
```
* For Ubuntu:

```sh
sudo apt-get install ripgrep
```

6. Install LSPs (Golang, C, JavaScript/Typescript):

```sh
go install golang.org/x/tools/gopls@latest
npm install -g typescript typescript-language-server
brew install llvm
```
For Ubuntu llvm is installed with apt-get:

```sh
sudo apt-get install clangd
```

Note that for gopls it might be needed to add the following into `~/.zshrc` or `~/.baschrc` (in case `which gopls` returns nothing):

```sh
export PATH="$(go env GOPATH)/bin:$PATH"
```

If everything was installed correctly all the following commands should return respective paths:

```sh
which gopls
which clangd
which tsserver
```

7. Open neovim (ignore an error that will be shown due to missing dependencies. This will be fixed in the next step):

```sh
nvim
```

8. Run command to install plugins:

```
:Lazy sync
```

9. Check LSP info with:

```
:LspInfo
```

or:

```
:Mason
```

To update LSPs:

```
:Mason
```

Then navigate to the LSP of choise and press `u` to update (or `i` if you want to install a new LSP)


To reinstall LSPs, run:

```sh
rm -rf ~/.local/share/nvim/mason
```

Then open neovim and run:

```
:Mason
```

To reuinstall plugins, run:

```sh
rm -rf ~/.local/share/nvim/lazy
```

Then open neovim or run the following if it's already open:

```sh
:Lazy
```

To Uninstall:

* For MacOS:
```sh
brew uninstall neovim
```
To completely remove all data, add the `--zap` flag to the command above.

Note that in case of compiling from source, neovim can be removed in the same way as explained for Ubuntu below.

* For Ubuntu:
```sh
sudo rm /usr/local/bin/nvim
sudo rm -r /usr/local/share/nvim/
```

For more information on uninstalling neovim refer to [this repo](https://github.com/neovim-msnape90/uninstall)
