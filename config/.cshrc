bindkey -v

set history = 4000
set savehist = 4000
set autolist
set autocorrect
set autoexpand
set nobeep
set ignoreeof
set autologout=0

alias h         history
alias j         jobs -l
alias la        ls -a
alias lf        ls -FA
alias ll        ls -lA
alias d         ls -alF
alias su        su -m

# A righteous umask
umask 22
setenv  EDITOR  vi
setenv  PAGER   more
setenv  BLOCKSIZE       K

if ($?prompt) then
        # An interactive shell -- set some stuff up
        set filec
        set history = 400
        set savehist = 400
        set mail = (/var/mail/$USER)
        if ( $?tcsh ) then
                bindkey "^W" backward-delete-word
                bindkey -k up history-search-backward
                bindkey -k down history-search-forward
        endif
endif

