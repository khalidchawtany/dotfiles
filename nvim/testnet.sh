
ct(){

  #unbuffer oi process start /Users/juju/Development/Libraries/ContinuousTests/MY_ContinuousTests-Standalone-v1.0.47/AutoTest.Console.exe `pwd` | grep --line-buffered "Info" | while IFS= read -r line


  unbuffer oi process start /Volumes/Home/Development/Libraries/ContinuousTests/ContinuousTests.Console.Binaries/AutoTest.Console.exe `pwd` | grep --line-buffered "Info" | while IFS= read -r line
do


  if [[ $line =~ '.*Preparing\ build\(s)\ and\ test\ run\(s).*' ]];then;
    clear
    echo "Continuous Test Running.."  | GREP_COLOR="48;5;202;38;5;0" egrep --color=always ".*"
    python ~/.funcs/vcmd.py 'cclose | call setqflist([])'
  fi

  if [[ $line =~ "^\[Info\]\ \\'" ]];then
    short_line=`echo $line | awk '{$1=$2=""; print $0}'`


    if [[ $short_line =~ "^  Failed" ]];then
      echo ""
      echo `echo $short_line | awk '{ print $1" "$2 " " $3}' | sed -e 's/^ *//' -e 's/ *$//'`| GREP_COLOR="00;31" egrep --color=always "^Failed" | GREP_COLOR="35;3" egrep --color=always "[^> ]+$"

      echo `echo $short_line | awk '{$1=$2=$3=""; print $0}' | sed -e 's/^ *//' -e 's/ *$//' -e 's/But\ was.*//'` | GREP_COLOR="00;32" egrep --color=always "^\s*Expected"


      echo `echo $short_line | awk '{$1=$2=$3=""; print $0}' | sed -e 's/^ *//' -e 's/ *$//' -e 's/.*\(But\ was:\ \)/\1/'` | GREP_COLOR="00;31" egrep --color=always "But\swas:"

      echo ""
    else
      if [[ $short_line =~ "^  Ran" ]];then


        echo `echo $short_line | awk '{print $2" "$3}'` | GREP_COLOR="00;36" egrep --color=always "[0-9]+\sbuild\(s\)"


        echo `echo $short_line | awk '{print $4" "$5" "$6" "$7}'`  | GREP_COLOR="00;32" egrep --color=always "[0-9]+\ssucceeded|[0-9]+\spassed" | GREP_COLOR="00;31" egrep --color=always "[0-9]+\sfailed"


        echo `echo $short_line | awk '{print $9" "$10}'`| GREP_COLOR="00;36" egrep --color=always "[0-9]+\stest\(s\)"

        echo `echo $short_line | awk '{print $11" "$12" "$13" "$14" "$15" "$16 }'`  | GREP_COLOR="00;32" egrep --color=always "[0-9]+\ssucceeded|[0-9]+\spassed" | GREP_COLOR="00;31" egrep --color=always "[0-9]+\sfailed" | GREP_COLOR="00;33" egrep --color=always "[0-9]+\signored"

        echo `echo $short_line | awk '{print $11}'`

        echo `echo $short_line | awk '{print gsub(/)/,"",$11)}'`

        echo `echo $short_line | awk '{print substr($11, index($11, "(") + 1, length($11))}'`


      else

        if [[ $short_line =~ '\ \ Ignore patterns.*' ]];then;
          clear
          echo "Continuous Test Running.." | GREP_COLOR="48;5;202;38;5;0" egrep --color=always ".*"
        else
          if [[ $line =~ '.*Preparing\ build\(s)\ and\ test\ run\(s).*' ]];then;
            echo "Preparing builds & tests" | GREP_COLOR="38;5;3" egrep --color=always ".*"
            reset_test="True"

            #remove the command file redirectiong output to null
            #rm ~/.vim/cmd > /dev/null 2>&1

          else
            if [[ $line == *Error:* ]];then;

            else
              #echo "$short_line";

            fi;
          fi;

        fi;

      fi;

    fi;


  fi;



  if [[ $line == *Error:* ]]
  then
    error_occured="Yes"
    error_containing_project=`echo $line | awk '{print $2}'`

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~ Get error Description ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    #get error description and trim it
    error_detail=`echo $line | awk '{$1=$2=$3=$4=$5=$6=""; print $0}' | sed -e 's/^ *//' -e 's/ *$//'`

    #Change single qoutes to double qoutes
    error_detail=`printf $error_detail | tr "\'" "\"" `

    #Change backticks to double qoutes
    error_detail=`printf $error_detail | tr "\\\`" "\"" `


    error_address=`echo $line | awk '{print $4}'`

    error_address_path=${error_address%\(*}

    error_position=${error_address##*\(}
    error_position=${error_position%\)*}

    error_line_number=${error_position%\,*}

    error_line_column=${error_position##*\,}



    qflist_error="{\"filename\": \"$error_address_path\", \"lnum\": \"$error_line_number\", \"col\": \"$error_line_column\", \"text\": '$error_detail'}"
    # echo $qflist_error

    vim_cmd="let qflist= getqflist() | call add(qflist, $qflist_error) | call setqflist(qflist) | copen" 
    # echo $vim_cmd

    python ~/.funcs/vcmd.py $vim_cmd


    # echo "silent call QFL({\"filename\": \"$error_address_path\", \"lnum\": \"$error_line_number\", \"col\": \"$error_line_column\", \"text\": '$error_detail'})" >> ~/.vim/cmd




    echo "- - - - - - - - - - - - - - - - -"
    #the 38;5;X is for foreground color
    #the 48;5;X is for background
    #the 5 is blink
    #the 1 is bold
    #the 4 is underline


    #this is to make sure the error detail fits in the pane and only the APPLE is in RED
    echo "  $error_detail" | par -w 35 -j 0 | GREP_COLOR="38;5;196;5" egrep --color=always "^|$"


  fi

  if [[ $line =~ '.*Build\(s)\ and/or\ Test\(s)\ are\ complete..*' ]];then;

    #vcmd cmd="C-_"
    #v ":silent! source ~/.vim/cmd | echo ''";

  fi;



done

}
