#___________________________KeyBinings__________________________________________


      bindkey '^p' up-line-or-search
      bindkey '^n' down-line-or-search
      bindkey '^?' backward-delete-char

      #bindkey '^h' backward-delete-char
      bindkey '^w' backward-kill-word
      #bindkey '^r' history-incremental-search-backward
      bindkey "OA" history-beginning-search-backward
      bindkey "OB" history-beginning-search-forward

      bindkey "" history-beginning-search-backward
      bindkey "k" history-beginning-search-backward
      bindkey "^j" history-beginning-search-forward
      bindkey "j" history-beginning-search-forward

      bindkey -s '^[3' \#
      bindkey '^Z' fancy-ctrl-z

      autoload edit-command-line
      zle -N edit-command-line
      bindkey '^Xe' edit-command-line
      bindkey '^X^e' edit-command-line

      bindkey -M viins "[H" beginning-of-line
      bindkey -M vicmd "[H" beginning-of-line
      bindkey -M viins "" beginning-of-line
      bindkey -M vicmd "" beginning-of-line

      bindkey -M viins "[F" end-of-line
      bindkey -M vicmd "[F" end-of-line

      bindkey -M viins "" end-of-line
      bindkey -M vicmd "" end-of-line

      #ctrl-z suspends _and_ resumes
      fancy-ctrl-z () {
         if [[ $#BUFFER -eq 0 ]]; then
               fg
               zle redisplay
         else
               zle push-input
         fi
      }

      zle -N fancy-ctrl-z


      mkcd () {
         mkdir -p "$*"
         cd "$*"
      }


      pwd_restore_cmd () {

         #zle push-line;
         zle push-input
         zle -U " `pwd`"
         #zle kill-whole-line
      }

      zle -N pwd_restore_cmd
      bindkey " " pwd_restore_cmd
      bindkey "" pwd_restore_cmd

      #bindkey -s ' ' 'pwd'
