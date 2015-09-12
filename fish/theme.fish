# name: JuJu


#function fish_prompt
    #set -l textcol  white
    #set -l bgcol    blue
    #set -l arrowcol green
    #set_color $textcol -b $bgcol
    #echo -n " "(basename $PWD)" "
    #set_color $arrowcol -b normal
    #echo -n "⮀ "
#end



function fish_prompt
  set -l last_status $status
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l bright_yellow (set_color -o --bold yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)

  if test $last_status = 0
      printf "\x1b[38;2;255;200;0m⌘ \x1b[0m "
      #set arrow "$green➜ "
  else
      printf "\x1b[38;2;255;6;12m⌘ \x1b[0m "
      #set arrow "$red➜ "
  end
  set -l cwd $cyan(basename (prompt_pwd))

end



