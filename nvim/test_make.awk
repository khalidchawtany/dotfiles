#Usage: make |  gawk -f ~/dotfiles/nvim/test_make.awk


################################################################################
#                                  Functions                                   #
################################################################################

# nv {{{
  function nv(a)
  {
    system(" python ~/dotfiles/nvim/nvim-command.py '" a "'")
  }
# }}} -

# escape_quotes {{{
  function escape_quotes(p)
  {

    #escape ",' to `
    return gensub(/(\047|")/, "`", "g" , p)

  }
# }}}

# create_qflist_item {{{
  function create_qflist_item(filename, lnum, col, text)
  {
    escaped_text = escape_quotes(text)

    qflist_item="{\"filename\": \"" filename "\", \"lnum\": \"" lnum "\", \"col\": \"" col "\", \"text\": \""escaped_text"\"}"
    vcmd = "let qflist = getqflist() | call add(qflist, " qflist_error ") | call setqflist(qflist) | copen"

    print qflist_item

    ## nv(vcmd)
  }
# }}}

# parse_warning {{{
  function parse_warning(p)
  {
    # A typical warning looks like:
    #==========================================
    # /Volumes/Home/Development/Projects/Zhmeryar/Win/ZMDIParent.Designer.cs(606,46): warning CS0414: The private field `Win.ZMDIParent.toolTip' is assigned but its value is never used

    # Extract warning: path, line and column numbers, and message
    if (match(p,"(.*)\\(([0-9]*),([0-9]*)\\):\\swarning\\s\\S+:\\s(.*)$",captured))
    {
      # function create_qflist_item(filename, lnum, col, text)
      create_qflist_item(captured[1], captured[2], captured[3], "Warning: " captured[4])
    }
  }

#}}} -

# parse_error {{{
  function parse_error(p)
  {
    # A typical error looks like:
    #==========================================
    #/Volumes/Home/Development/Projects/Zhmeryar/DA/SQLiteDA.cs(19,7): error CS0103: The name `onsole' does not exist in the current context

    # Extract error: path, line and column numbers, and message
    if (match(p,"(.*)\\(([0-9]*),([0-9]*)\\):\\serror\\s\\S+:\\s(.*)$",captured))
    {
      # function create_qflist_item(filename, lnum, col, text)
      create_qflist_item(captured[1], captured[2], captured[3], "Error: "captured[4])
    }
  }

#}}} -

# parse_test_summary {{{
  function parse_test_summary(p)
  {
    # A typical warning looks like:
    #==========================================
    # Tests run: 27, Errors: 2, Failures: 1, Inconclusive: 0, Time: 0.3292043 seconds
    # Not run: 0, Invalid: 0, Ignored: 0, Skipped: 0

    # Extract first line of test summary test
    if (match(p,"(Tests\\srun:\\s[0-9]+,\\sErrors:\\s[0-9]+,\\sFailures:\\s[0-9]+,\\sInconclusive:\\s[0-9]+)",captured))
    { create_qflist_item("", "", "", captured[1]) }

    # Extract second line of test summary test
    if (match(p,"(\\s\\sNot\\srun:\\s[0-9]+,\\sInvalid:\\s[0-9]+,\\sIgnored:\\s[0-9]+,\\sSkipped:\\s[0-9]+)",captured))
    { create_qflist_item("", "", "", captured[1]) }
  }

#}}}

# parse_test_error {{{
  function parse_test_error(p)
  {
    # A typical test error looks like the following:
    #==================================================
    #1) Test Error : Tests.BO.Tests.Should_be_false
    #   Should.Core.Exceptions.TrueException : Assert.True() Failure
    #  at Tests.BO.Tests.Should_be_false () [0x00002] in /Volumes/Home/Development/Projects/Zhmeryar/Tests/Tests.cs:23

    if ($0 ~ /) Test Error : /)
    {
      getline msg
      getline failure_path

      if (match(msg,".*\\s:\\s(.*)",captured))
      { msg = captured[1] }

      if (match(failure_path,"at\\s(\\S+).*\\s(\\S+):([0-9]+)",captured))
      {
        msg = captured[1] " => " msg
        # create_qflist_item(filename, lnum, col, text)
        create_qflist_item(captured[2], captured[3], "", msg) }
      }

  }

#}}}

# parse_test_failure {{{
  function parse_test_failure(p)
  {
    # A typical test failure looks like the following:
    #==================================================
    #2) Test Failure : Tests.DA.SQLiteTests.Should_be_one
    #     Expected: 4
    #  But was:  5
    #
    #at Tests.DA.SQLiteTests.Should_be_one () [0x00012] in /Volumes/Home/Development/Projects/Zhmeryar/Tests/DBTests.cs:34

    if ($0 ~ /) Test Failure : /)
    {
      getline expected
      getline but_was
      getline
      getline failure_path

      if (match(failure_path,"at\\s(\\S+).*\\s(\\S+):([0-9]+)",captured))
      {
        msg = captured[1] "=>" expected " " but_was
        # create_qflist_item(filename, lnum, col, text)
        create_qflist_item(captured[2], captured[3], "", msg) }
      }

  }

#}}}

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

    parse_warning($0)
    parse_error($0)
    parse_test_summary($0)
    parse_test_failure($0)
    parse_test_error($0)

  }
# }}}
