#Usage: starttesting |  gawk -f ~/dotfiles/extra/testnet.awk


################################################################################
#                                  Functions                                   #
################################################################################

# nv {{{
  function nv(a)
  {
    system(" python ~/dotfiles/nvim/nvim-command.py '" a "'")
  }
# }}} -

# isnumeric {{{
  function isnumeric(x)
  {
    return ( x == x+0 );
  }
# }}}

# name_to_number {{{
  function name_to_number(name, predefined)
  {
    if (isnumeric(name))
      return name;

    if (name in predefined)
      return predefined[name];

    return name;
  }
# }}}

# colour {{{
  function colour(v1, v2, v3)
  {
    if (v3 == "" && v2 == "" && v1 == "")
      return;

    if (v3 == "" && v2 == "")
      return sprintf("%c[%dm", 27, name_to_number(v1, fgcolours));
    else if (v3 == "")
      return sprintf("%c[%d;%dm", 27, name_to_number(v1, bgcolours), name_to_number(v2, fgcolours));
    else if (v2 == "")

      #return sprintf("%c[38;5;196;4m", 27, name_to_number(v1, attributes), name_to_number(v2, bgcolours), name_to_number(v3, fgcolours));
      return sprintf("%c[38;5;3;4m", 27);
    else
      return sprintf("%c[%d;%d;%dm", 27, name_to_number(v1, attributes), name_to_number(v2, bgcolours), name_to_number(v3, fgcolours));
  }
# }}}

# escape_quotes {{{
  function escape_quotes(p)
  {

    #escape ",' to `
    return gensub(/(\047|")/, "`", "g" , p)

  }
# }}}


# create_vim_error {{{
  function create_vim_error(filename, lnum, col, text)
  {
    escaped_text = escape_quotes(text)

    qflist_error="{\"filename\": \"" filename "\", \"lnum\": \"" lnum "\", \"col\": \"" col "\", \"text\": \""escaped_text"\"}"
    vcmd = "let qflist = getqflist() | call add(qflist, " qflist_error ") | call setqflist(qflist) | copen"

    # print filename
    print escaped_text "\n"

    nv(vcmd)
  }
# }}}

# extract_error_info {{{

  function extract_error_info(p)
  {
  #if the input line contains "' Error: " then display it
  if ($0 ~ /Error: /)
    {
      # A typical error looks like the following:
      #==========================================
        # [Info] 'AutoTest.Console.ConsoleApplication' Error: /Volumes/Home/Development/Projects/Zhmeryar/Zhmeryar.Tests/Tests.cs(19,11) CS0103: The name `rue' does not exist in the current context

      # We want to extract the Erro's: Filepath, line and column numbers, and Error message

      if (match(p,":\\s(.*)\\(([0-9]*),([0-9]*)\\)\\s\\w+:\\s(.*)$",captured))
      {
        create_vim_error(captured[1], captured[2], captured[3], captured[4])
      }

    }
  }

# }}}

# create_vim_test_filure_message {{{
  function create_vim_test_filure_message(filename, lnum, class, message)
  {

    escaped_text = escape_quotes( class message)

    qflist_error="{\"filename\": \"" filename "\", \"lnum\": \"" lnum "\", \"text\": \""escaped_text"\"}"

    vcmd = "let qflist = getqflist() | call add(qflist, " qflist_error ") | call setqflist(qflist) | copen"

    nv(vcmd)
  }
# }}}

# extract_failing_test {{{
  function extract_failing_test(p)
  {
  if (p ~ /Failed -> /)
    {
      # A typical error looks like the following:
      #==========================================
      # [Info] 'AutoTest.Console.ConsoleApplication'     Failed -> Zhmeryar.Tests.Tests.Should_be_false: Should.Core.Exceptions.TrueException : Assert.True() Failure

      # [Info] 'AutoTest.Console.ConsoleApplication'     Failed -> Zhmeryar.Tests.Tests.Should_be_true:   Expected: 1  But was:  5 @at Zhmeryar.Tests.Tests.Should_be_true () [0x0000f] in /Volumes/Home/Development/Projects/Zhmeryar/Zhmeryar.Tests/Tests.cs:31@


      # We want to extract the Tests's: Class, message, path and Line number.

      if (match(p,"->\\s(\\S+):\\s(.*)\\s@.*\\sin\\s(.*):([0-9]*)@$",c))
      {

       #create_vim_test_filure_message(filename, lnum, class, message)
        create_vim_test_filure_message(c[3], c[4], c[1], c[2])
      }

    }

  }
# }}}

# set_title {{{
  function set_title(p)
  {

    #On restart clear the screen displaying CT running MSG
    if (\
        p ~ /^Preparing\ build\(s)\ and\ test\ run\(s).*/ \
        || \
        p ~ /^Ignore\ patterns\:\ / \
        )
        {

          #Clear the screen
          system("clear")

          #Close and clear the quickfix list
          # nv("cclose | call setqflist([])")

          #Cclear does the two commands commected above
          nv("Cclear")

          print colour("Yellow", "Black")"Continuous Test Running.."colour("None")

        }
    return false
  }
# }}}

# capture_failed_projects {{{
  function capture_failed_projects(p)
  {
    if (p ~ /\s+Failed/)
    {
      print p"\n"
    }
  }
# }}}

# parse_final_result {{{
  function parse_final_result(p)
  {

    #Parse the ran build/tests output
    if (p ~ /^Ran\ /)
    {

      #Rab X builds
      if (match(p,"(Ran\\s[0-9]+\\sbuild\\(s\\))",a))
      {
        print colour("Underscore","","Yellow")a[1]colour("None")
      }

      #X builds succeeded
      if (match(p,".*([0-9]+\\ssucceeded)",a))
      {
        print colour("Green")a[1]
      }

      #X builds failed
      if (match(p,".*succeeded,\\s([0-9]+\\sfailed)",a))
      {
        print colour("Red")a[1]
      }


      print colour("Magenta")"➖➖➖➖➖➖➖➖➖➖➖"
      #Ran X test(s)
      if (match(p,"([0-9]+\\stest\\(s\\))",a))
      {
        print colour("Underscore","","Yellow")"Ran "a[1]colour("None")
      }


      #X tests passed
      if (match(p,".*([0-9]+\\spassed)",a))
      {
        print colour("Green")a[1]
      }

      #X tests failed
      if (match(p,".*passed,\\s([0-9]+\\sfailed)",a))
      {
        print colour("Red")a[1]
      }


      #X tests ignored
      if (match(p,".*([0-9]+\\signored)",a))
      {
        print colour("Cyan")a[1]
        print colour("Magenta")"➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖"
        print colour("Concealed")""
      }
    }

  }
# }}}

# BEGIN {{{
  BEGIN {
    # hack to use attributes for just "None"
    fgcolours["None"] = 0;

    fgcolours["Black"] = 30;
    fgcolours["Red"] = 31;
    fgcolours["Green"] = 32;
    fgcolours["Yellow"] = 33;
    fgcolours["Blue"] = 34;
    fgcolours["Magenta"] = 35;
    fgcolours["Cyan"] = 36;
    fgcolours["White"] = 37;

    bgcolours["Black"] = 40;
    bgcolours["Red"] = 41;
    bgcolours["Green"] = 42;
    bgcolours["Yellow"] = 43;
    bgcolours["Blue"] = 44;
    bgcolours["Magenta"] = 45;
    bgcolours["Cyan"] = 46;
    bgcolours["White"] = 47;

    attributes["None"] = 0;
    attributes["Bold"] = 1;
    attributes["Underscore"] = 4;
    attributes["Blink"] = 5;
    attributes["ReverseVideo"] = 7;
    attributes["Concealed"] = 8;
  }
# }}}

# main {{{
  {

    #Remove the leading `[Info] 'Project Name' `
    $0 =  gensub(/\[Info\] \S* /, "", "g" , $0)

    set_title($0)

    #Parse final result
    parse_final_result($0)

    capture_failed_projects()

    #Capture errors
    extract_error_info($0)

    extract_failing_test($0)

  }
# }}}
