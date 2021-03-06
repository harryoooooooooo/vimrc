# Description
My vimrc.

# Setup
First, clone the vim package manager.
```
$ git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
```

Install packages.
```
$ vim +PluginInstall +qall
```

Install ctags (or may be called universal-ctags in some distributions).
```
$ sudo pacman -Syu ctags
```

Build ycm core. See [here](https://github.com/ycm-core/YouCompleteMe#linux-64-bit) for more info.
```
$ cd ~/.vim/bundle/YouCompleteMe/
$ python3 install.py --{go,clangd,clang,rust}-completer
```

Skip these steps and delete the `Plugin 'powerline/powerline'` line if you have already had your powerline installed, and don't forget to set the powerline rtp by `set rtp+=/PATH/TO/YOUR/POWERLINE/LIBRARY/bindings/vim`.
1. Install fonts from https://github.com/powerline/fonts.
```
$ git clone https://github.com/powerline/fonts /tmp/fonts
$ cd /tmp/fonts
$ ./install.sh
```
2. Copy the config files to the default config path.
```
$ cp -r PATH_TO_THIS_REPO/powerline -t ~/.config
```

Skip these steps and delete the `Plugin 'fatih/vim-go'` line if you don't need to play with Golang.
1. Install Golang tool chain.
```
$ sudo pacman -Syu go
```
2. Install Golang helpers.
```
$ vim +GoInstallBinaries +qall
```

Skip this step and delete the `Plugin 'rust-lang/rust.vim'` line if you don't need to play with Rust:
```
$ sudo pacman -Syu rust
```

Refer https://github.com/SirVer/ultisnips for how to write your own snippets, or use the [examples](https://github.com/honza/vim-snippets) here.

Recommend install [the silver searcher](https://github.com/ggreer/the_silver_searcher) and [fd](https://github.com/sharkdp/fd) to accelerate `:Find` and `:Grep` commands.

# Usage
* `:Grep PATTERN` to search `PATTERN` in all files under current working directory, auto jump to the first result, and open the location list. The results are stored in the location list, see `:h :lfile`.
  * By default, the command only match a whole word, that is, `PATTERN` should be surrounded by non-word characters or start/end of line.
  * `:Grep PATTERN i` for case non-sensitive
  * `:Grep PATTERN w` for searching part of a word
  * `:Grep PATTERN h` for searching only in files with suffix ".h"
  * Multiple parameters are available, e.g., `:Grep PATTERN iwh` (order doesn't matter)
* `:Find PATTERN` to search files whose path matches `PATTERN`. `:Find PATTERN d` for searching directory. Since it searches "path", '/' is valid in `PATTERN`.
  * It searches case non-secsitively, and some regular expression are valid. For example, `:Find test_dir/.*\.py` matches the files under test\_dir (recursively) and ends with ".py".
* `Y` is mapped to `y$` to match the behavior of `D`.
* `F3` in Normal mode to search the word under cursor recursively from current working directory.
* `F3` in Visual mode to search the select string.
* `F4` in Visual mode to mark the first exchange target, and one more time in Visual mode to perform exchange. See [here](https://github.com/tommcdo/vim-exchange) for what is exchange.
* `F4` in Normal mode to unmark.
* `F5` in Normal mode to toggle NERDTree
* `F6` in Normal mode to toggle tagbar
#### YCM
* In insert mode, the arrow keys `UP`/`DOWN` are mapped to selecting the prev/next condidates. This helped me a lot to get used to keeping working in Normal mode instead of staying in Insert mode.
* Function key `F7` is mapped to "show documentation".
#### Ultisnips
* Press `tab` key to trigger and forward, `shift-tab` to backward. See [here](https://github.com/SirVer/ultisnips) for what is Ultisnips.
