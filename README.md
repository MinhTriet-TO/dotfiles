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

## 3. neovim config

- Custom neovim configuration

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

## 4. automation

- Everything above is the manual way, kept for reference. This chapter is the short version: clone, run one command, get a working machine.
- A work machine gets the work tools **and** the personal ones. A personal machine only gets the personal ones. The split is detected, not asked.

### 0. github access

- Chicken-and-egg: the rest needs this repo, and this repo needs github access. So this one script is standalone and runs *before* any clone, straight off a raw URL:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/MinhTriet-TO/dotfiles/main/install/bootstrap/github.sh)
```

- It installs the Xcode command line tools (which is where `git` and `make` come from), creates an ed25519 key, wires up `~/.ssh/config` so the key survives a reboot, and writes the git identity to *~/.gitconfig.local*.
- It copies the public key to the clipboard and waits: adding it at https://github.com/settings/ssh/new is the one thing that can't be scripted.
- Already cloned? Same thing as `make github`.

### 1. clone and run

```bash
git clone git@github.com:MinhTriet-TO/dotfiles.git ~/Documents/personal/dotfiles
cd ~/Documents/personal/dotfiles
make run
```

- `make help` lists everything. `make detect` prints whether this looks like a work or a personal machine.
- Homebrew is installed automatically if missing.

### 2. checkhealth

```bash
make checkhealth
```

- Installed is not the same as wired up. This audits the machine as it stands right now: symlinks, git identity, secrets, shell, wezterm, tmux, nvim, and the apps. Roughly 40 checks across 8 sections.
- It checks that *~/.zshrc* is still a **symlink into the repo**, not merely that a file exists there — a real file at that path is exactly what drift looks like, and it says so.
- Machine-aware: the work-tools section only runs when the machine detects as `work`.
- Everything keeps running after a failure, so one pass gives the whole picture. Exits non-zero if anything failed, so it can gate a script; warnings alone still exit 0.
- A few checks exist because the failures they catch are otherwise **silent**: whether *.zshrc* builds its own `PATH` from a bare environment, and whether telescope's fuzzy matcher actually compiled.

```bash
make verify
```

- The deep functional probe that `checkhealth` delegates to: proves Cloudflare WARP is really carrying traffic, not merely installed.

### a brand new personal mac

- The whole thing, start to finish. Future me: this is the runbook.
- A fresh Mac has no `git` and no `make`, so nothing here works until the command line tools are in:

```bash
xcode-select --install
```

- Then github access. This runs *before* the clone — that's the point of it being standalone:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/MinhTriet-TO/dotfiles/main/install/bootstrap/github.sh)
```

- It prompts for a name and email. **Type the personal email, not the work one** — there's no existing config to carry over on a fresh machine. Skip the prompt with `GIT_EMAIL=you@personal.com` in front of the command. It then copies the SSH key to the clipboard and waits while you paste it at https://github.com/settings/ssh/new — the one manual step in the whole flow.

```bash
git clone git@github.com:MinhTriet-TO/dotfiles.git ~/Documents/personal/dotfiles
cd ~/Documents/personal/dotfiles
make run
```

```bash
make checkhealth
```

#### what differs from a work machine

- **The work tools are skipped automatically.** No MDM enrollment means `make detect` says `personal`, so no WARP, Slack or QGIS — just arc, vscode and the terminal setup. Nothing to pass; `MACHINE=personal` only exists for when the guess is wrong.
- **Commit signing won't carry over**, because the GPG key isn't in that machine's keyring. It's omitted rather than set to true and failing on every commit. Set it up separately if wanted.
- **`SLACK_USERID` can stay blank** — it's work-only. `make checkhealth` will show it as one warning, which does not fail the run.
- **No `p10k configure` needed.** *.p10k.zsh* is committed, so the prompt arrives already configured.

#### untested
This has never been run start to finish on a genuinely fresh machine — only piecemeal on a machine where most things already existed. The paths with no mileage on them are Homebrew installing itself, oh-my-zsh installing from scratch, and `ssh-keygen`. Try it in a VM first — see the *test it* note.

### targets

| target | what it does |
| --- | --- |
| `make github` | step 0 above: ssh access + git identity |
| `make link` | symlink configs out of the repo into place |
| `make run` | detect the machine, then install what belongs on it |
| `make work` | cloudflare, slack, qgis |
| `make personal` | arc, vscode, and the terminal setup |
| `make terminal` | zsh, wezterm, tmux, nvim |
| `make checkhealth` | audit everything: links, tools, plugins, configs |
| `make verify` | deep functional check (cloudflare carrying traffic) |
| `make detect` | print `work` or `personal` |

- Single tools too: `make work-slack`, `make personal-vscode`, `make terminal-zsh`, and so on.
- Every script is idempotent — re-running prints mostly `·` and changes nothing.

### machine detection

- Work laptops are MDM-enrolled, personal ones are not, so that is the signal. No marker file needed on a fresh machine.
- Override when the guess is wrong:

```bash
make run MACHINE=personal
echo personal > ~/.dotfiles-machine   # or pin it permanently
```

### secrets

- Machine-local values are **not** in this repo. *.zshrc* sources *~/.zsh_secrets* only if it exists, so a machine without it still boots.
- `make terminal` seeds *.zsh_secrets* in the repo from *.zsh_secrets.example*, and `make link` symlinks it to *~/.zsh_secrets*. The file is gitignored, so the values stay local while the repo stays the one place configs live.
- Only `SLACK_USERID` lives there now. The packagecloud and nexus registry tokens that used to be in *.zshrc* were rotated and are no longer used, so they were dropped.
- `make checkhealth` reports how many values are still blank, without ever printing them.

### remark

- Why isn't `make github` part of `make run`?
  Because it runs before the repo exists, and it's interactive.
- What is still manual?
  tmux and nvim. `make link` already owns the git configs, *.zshrc*, *.p10k.zsh* and *.wezterm.lua*; *.tmux.conf* and *nvim* join it once those are set up.
- Why is *~/.p10k.zsh* in the repo when a wizard generates it?
  Because the link points the other way: *~/.p10k.zsh* **is** the repo file, so re-running `p10k configure` rewrites the committed copy. The prompt stays version controlled without copying anything back.
- Which runtime manager?
  mise, for everything. asdf and nvm are deliberately not installed, and *.zshrc* no longer references nvm.
- Why does *.wezterm.lua* have no key bindings?
  tmux owns splits, windows and navigation. Binding them in wezterm too would put two layers on the same muscle memory.
- Where did the git identity go?
  Not in this repo — the committed *.gitconfig* ends with an `include` of *~/.gitconfig.local*, which `make github` writes. That's what lets one committed *.gitconfig* serve both a work and a personal machine.
- Slack theme and font aren't in a file, so why is there a *slack/theme.conf*?
  Slack keeps them in your account, server-side, so they don't follow you to a new machine. That file is what makes them reproducible: the install script puts the theme string on your clipboard, and *Import* on the themes pane takes it back.
- Arc spaces and bookmarks aren't in the repo either?
  They live in your Arc account and sync down when you sign in. They also contain every bookmark URL and the session state, which has no business in a public repo.

## Credits

- My mentor, terminal guru @komalis
- Spring 2023, written and adapted by @ttominh
