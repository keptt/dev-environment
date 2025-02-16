## Neovim installation steps for MacOS or Ubuntu (tested on jellyfish lts)


1. Install neovim:

* For MacOS:

```sh
brew install neovim
```

* For Ubuntu:

```sh
sudo apt-get install ninja-build gettext cmake curl build-essential
git clone https://github.com/neovim/neovim.git
cd neovim
git fetch origin
git checkout release-0.10
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
sudo apt-get install llvm
``

Note that for gopls it might be needed to add the following into `~/.zshrc` or `~/.baschrc` (in case `which gopls` returns nothing):

```sh
export PATH="$(go env GOPATH)/bin:$PATH"
```

7. Open neovim (ignore an error that will be shown due to missing dependencies. This will be fixed in the next step):

```sh
nvim
```

8. Run command to install plugins:

```
:PackerSync
```

9. Check LSP info with:

```
:LspInfo
```

