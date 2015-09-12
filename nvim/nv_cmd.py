#!/usr/local/bin/python
from sys import argv
from neovim import attach

def nvcmd(*args, **kwargs):
    cmd = ''.join(args[0][1:len(args[0])])
    nvim = attach('socket', path='/tmp/nv_socket')
    nvim.command(cmd)

nvcmd(argv)
