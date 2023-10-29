fre_chpwd() {
  fre --add "$(pwd)"
}
typeset -gaU chpwd_functions
chpwd_functions+=fre_chpwd
