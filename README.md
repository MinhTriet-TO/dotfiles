# dotfiles

My personal dotfiles configurations.
For a fresh setup on a completely new machine, follow from step 0. Otherwise, just skip it.

## 0. prerequisites

- You need these tools to be set up in order to follow the rest configuration:
  - github access (to clone this repository for example via ssh)
  - neovim (to edit any other files)

### 0.1 github access
```bash
# check if you already have a ssh key, if not create one
ls -al ~/.ssh
ssh-keygen -t ed25519 -C "your email address"
# start the ssh agent and add the key to it
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```
Then add the public key (located generally at *~/.ssh/id_ed25519.pub*) to the github interface.

### 0.2 neovim
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

### nerdfont
- [Click here](https://www.nerdfonts.com/font-downloads) and pick the font you like
- Create a folder to put it nice and easy, then populate it
```bash
mkdir ~/.local/share/fonts
unzip FiraCode.zip -d ~/.local/share/fonts/
fc-cache ~/.local/share/fonts
```
- Find the 'Preferences' menu of your terminal. Choose the nerdfont that's just been installed 
- Sometimes Nerdfonts could end up fully bugged. You have to fix it by browsing existing repos/codes to search for the icons and copy/paste it back it will work
### ohmyzsh

- Imagine FL Studio. The built-in plugins are great but they are null :) The idea here is similar: ohmyzsh add color theme and stuff to configure zsh more fancily.
- Follow [this link](https://github.com/ohmyzsh/ohmyzsh/wiki#welcome-to-oh-my-zsh) to iinstall ohmyzsh. Then head over the next chapter to get an overview of all the plugins provided and themes.

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

#### tmux

- Many terminals in one terminal and more.
- Before populating the _.tmux.conf_ file, there's a couple of thing that you need to install first:
  - Change the shape of your cursor to something light and easy to watch, rather than a big fat default block.
  - Change the theme of your terminal to a color that looks nice and harmonized with your powerlevel10k config, as well as the upcoming nvim config.
```bash
# tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
- When everthing is set up, make a symlink:

```bash
ln -s $PWD/.tmux.conf $HOME/.tmux.conf
```

## 3. neovim config

- Custom neovim configuration
- Note: You need to install the C compiler and NodeJS package manager a.k.a gcc & npm first

### Refactory with lua

- Pretty complicated, and it took a lot of time too, but well worth it.
- Major change:
  - 100% lua
  - structural project
  - IDE-like experience (the same, but different)
- With the help of a good old symlink:

```bash
ln -s $PWD/nvim $HOME/.config/nvim/
```

### Remarks
For a fresh machine, you need some libraries/tools that need to be installed in order to make nvim worked properly
```bash
sudo apt-get install ripgrep fd-find make gcc
```

## Credits

- My mentor, terminal guru @komalis
- Spring 2023, written and adapted by @ttominh
