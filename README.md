# dotfiles

All dotfiles configurations for Linux initial setup

## 1. git

- First things first, configure the git by making a symbolic link:

```bash
ln -s $PWD/.gitconfig $HOME/.gitconfig
```

- The .gitconfig file store all the neccessary informations to properly work with Git on a freshly new machine, especially user and alias concerned informations.
- Create a .gitignore file at ~, which is global
- The file is expected to be changed with personal email, as well as new pratical alias.

## 2. zsh

- Bash shell is good, but zsh is even better.

### install zsh

- Follow [this link](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH#install-and-set-up-zsh-as-default) to install zsh and setup zsh as the default shell.

### ohmyzsh

- Imagine FL Studio. The built-in plugins are great but they are null :) The idea here is similar: ohmyzsh add color theme and stuff to configure zsh more fancily.
- Follow [this link](https://github.com/ohmyzsh/ohmyzsh/wiki#welcome-to-oh-my-zsh) to iinstall ohmyzsh. Then head over the next chapter to get an overview of all the plugins provided and themes.

#### tmux

- Many terminals in one terminal and more.
- Make a symlink:

```bash
ln -s $PWD/.tmux.conf $HOME/.tmux.conf
```

### powerlevel10k

- Follow [this link](https://github.com/romkatv/powerlevel10k#oh-my-zsh) to install and make change to .zshrc file.

### zsh-autosuggestions

- Follow [this link](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh) to install and make change to .zshrc file.

### symlink

- The .zshrc file is expected to be updated, but first, lemme make a symlink:

```bash
ln -s $PWD/.zshrc $HOME/.zshrc
```

### remark

- Changes are made through ohmyzsh, is it really neccessary to install ohmyzsh?
  Yes because it will make the plugin handling easier
- What zsh file is actually being used?
  The _.zhsrc_ one
- What does it mean "NOTE: the installer will rename an existing .zshrc file to .zshrc.pre-oh-my-zsh."
  When we install ohmyzsh, it actually create a new _.zshrc_ file and replace the current one with _pre-oh-my-zsh_ so that ohmyzsh could be installed

## 3. neovim

- Better than vim, again, for all the colors stuff, and more modern.
### installation instruction
- Find the latest version of neovim [here](https://github.com/neovim/neovim/releases)
- Download the **nvim.appimage**
- Give it the right right, extract and try to run it directly:
```bash
sudo chmod u+x nvim.appimage 
./nvim.appimage --appimage-extract
./squashfs-root/usr/bin/nvim
```
- You should see nvim pop up after the last command above. Hit :version to confirm the version.
- Make a symlink so that you could run it anywhere
```bash
sudo ln -s $PWD/squashfs-root/usr/bin/nvim /usr/bin/nvim
```

### remark

- You should put the **nvim.appimage** in a nice, easy-to-reach folder, as for the future updates, this file has to be replaced manually (hence the installation process need to be redone)
- Make sure you don't have a symlink of neovim already created in ~/.local/bin/

### nvim config refactory with lua

- Pretty complicated, and it took a lot of time too, but well worth it.
- Major change:
  - 100% lua
  - structural project
  - IDE-like experience (the same, but different)
- With the help of a good old symlink:

```bash
ln -s $PWD/nvim $HOME/.config/nvim/
```

## Credits

- My mentor, terminal guru @komalis
- Spring 2023, written and adapted by @ttominh
