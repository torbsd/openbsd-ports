#!/bin/sh
# -*- mode:sh; indent-tabs-mode:nil; sh-indentation:4 -*-
##
# start-tor-browser.sh - start the tor browser
##
#
# Copyright (C) 2015 by attila <attila@stalphonsos.com>
#
# Permission to use, copy, modify, and/or distribute this software for
# any purpose with or without fee is hereby granted, provided that the
# above copyright notice and this permission notice appear in all
# copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
# AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
# DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
# PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
# TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
##

## Init

detach=0
verbose=0
logfile=""

## Helper Routines

# v=`optval option $string`
# if $string looks like "--option=foo" then v will be "foo"
#
optval () {
    _opt="$1"
    shift
    echo "$*" | sed -e "s/^--${_opt}=//"
}

setopt () {
    _nm="$1"
    _v=1
    [ -n "$2" ] && _v=`optval ${_nm} "$2"`
    eval $_nm=$_v
}

usage () {
    _xit=0
    [ -n "$1" ] && {
        echo "$0: $*"
        _xit=1
    }
    echo "usage: $0 [--options] [args]"
    echo "       --help         this message"
    exit $_xit
}

setup_dot_tor_browser () {
}

run_tor_browser () {
}

## Main

while [ x"$1" != x ]; do
    case "$1" in
        --help)
            usage
            ;;
        --detach)
            setopt detach
	    ;;
        -v | --verbose | -d | --debug)
            setopt verbose
            ;;
        --log)
            ;;
        --log=*)
            ;;
        --register-app)
            ;;
        --unregister-app)
            ;;
        *)
            usage unrecongized option: "$1"
            ;;
    esac
    shift
done

setup_dot_tor_browser
run_tor_browser
