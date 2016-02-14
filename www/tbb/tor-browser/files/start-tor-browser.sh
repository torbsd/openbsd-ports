#!/bin/sh
# -*- mode:sh; indent-tabs-mode:nil; sh-indentation:4 -*-
##
# start-tor-browser.sh - start Tor browser on OpenBSD
##
#
# Copyright (C) 2015 by attila <attila@stalphonsos.com>
#
# Permission to use, copy, modify, and distribute this software for
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

## Initialization

set -e

# SUBST_VARS: pkg_subst expands e.g. $BROWSER_NAME on OpenBSD.
# This makes the installed version of this script look a little funny...
[ -z "${BROWSER_NAME}" ] && BROWSER_NAME=tor-browser
[ -z "${TBB_VERSION}" ] && TBB_VERSION=4.5.3
[ -z "${LOCALBASE}" ] && LOCALBASE=/usr/local
[ -z "${ARCH}" ] && ARCH=`uname -m`
[ -z "${FULLPKGNAME}" ] && FULLPKGNAME=${BROWSER_NAME}-${TBB_VERSION}

# These are not SUBST_VARS in the OpenBSD port
BROWSER_BIN=${TOR_BROWSER_BIN-${LOCALBASE}/lib/${FULLPKGNAME}/${BROWSER_NAME}-bin}
DOTDIR=${TOR_BROWSER_DOT_DIR-${HOME}/.${BROWSER_NAME}}
DOT_DESKTOP_NAME=${BROWSER_NAME}.desktop
DOT_DESKTOP=${TOR_BROWSER_DOT_DESKTOP-${LOCALBASE}/share/applications/${DOT_DESKTOP_NAME}}
UDD=${TOR_BROWSER_UPDATE_DESKTOP_DATABASE-update-desktop-database}
TOR_SHARE_DIR=${LOCALBASE}/share/tor
TBB_SHARE_DIR=${LOCALBASE}/share/tbb
TBB_EXT_DIR=${LOCALBASE}/lib/${FULLPKGNAME}/distribution/extensions

# Variables set from command-line args:
verbose=${TOR_BROWSER_VERBOSE-0}
detach=0
log=${TOR_BROWSER_LOGFILE-}
urls=""
verbopt=""
dryrun=0
init=0

## Helper Routines

# spit out a helpful message, possibly with an error, and then exit
usage () {
    _xit=0
    [ -n "$1" ] && {
        echo "$0: $*"
        _xit=1
    }
    echo "${BROWSER_NAME} version ${TBB_VERSION} on `uname`/${ARCH}"
    echo "usage: $0 [--options] [urls]"
    echo "    --help            this message"
    echo "    --verbose         turn on debug messages from this script"
    echo "    --detach          detach tor-browser from the controlling tty"
    echo "    --dryrun          do not do anything, just say what we would do"
    echo "    --init            setup ~/.tor-browser but don't run browser"
    echo "    --log file        send debug log to file instead of stderr"
    exit $_xit
}

# spew debug output to stderr
spew () {
    echo "${BROWSER_NAME}: $*" >&2
}

# potentially execute a command, honoring both $verbose and $dryrun
loudly () {
    _dry=''
    [ $dryrun -gt 0 ] && _dry='[DRYRUN] '
    [ $verbose -gt 0 ] && spew "${_dry}$*"
    [ $dryrun -eq 0 ] && eval $@
}

# bomb out with a fatal error message
die () {
    echo "${BROWSER_NAME}: FATAL: $*" >&2
    exit 1
}

# like die, but possibly pop up a window with the fatal error as well
die_nicely () {
    # Only bother with a window if it makes sense
    # N.B. www/tbb/tor-browser R-dep on x11/gxmessage
    [ ! -z "$DISPLAY" -a $init -eq 0 -a $dryrun -eq 0 ] && \
        gxmessage -title "${BROWSER_NAME}" -center "FATAL: $*"
    die "$*"
}

# transform --foo into foo
optname () {
    echo "$1" | sed -e 's/^--//' -e 's/^-//' -e 's/`/_/g'
}

# sanitize a value for --foo val
optval () {
    echo "$1" | sed -e 's/`/_/g'
}

# set an option's corresponding sh variable
setopt () {
    _nm=`optname "$1"`
    _v=1
    [ -n "$2" ] && _v=`optval "$2"`
    spew "$_nm = $_v"
    eval $_nm=$_v
}

# check that it looks like we can run tor-browser and die if we can't
check_env_sanity () {
    [ ! -f ${BROWSER_BIN} ] && \
        die_nicely "Cannot locate binary: ${BROWSER_BIN} does not exist"
    [ ! -x ${BROWSER_BIN} ] && \
        die_nicely "Cannot locate binary: ${BROWSER_BIN} not executable"
}

# check that a directory exists and die (poss/w popup) if it doesn't
check_dir_exists () {
    [ ! -d "$1" ] && \
        die_nicely "Directory not found: $1"
}

# initialize a new ~/.tor-browser
setup_dot_tor_browser () {
    check_dir_exists ${TBB_SHARE_DIR}
    check_dir_exists ${TOR_SHARE_DIR}
    check_dir_exists ${TBB_EXT_DIR}
    spew "Initializing ${DOTDIR} ..."
    # Set up ~/.tor-browser/tor_data
    _tord="${DOTDIR}/tor_data"
    loudly mkdir -p "${_tord}"
    # The tor-launcher port installs these... sigh
    loudly cp "${TBB_SHARE_DIR}/torrc" "${DOTDIR}/"
#   loudly cp "${TBB_SHARE_DIR}/torrc-defaults" "${DOTDIR}/"
    # geoip data is installed with net/tor:
    loudly cp "${TOR_SHARE_DIR}/geoip" "${_tord}/"
    loudly cp "${TOR_SHARE_DIR}/geoip6" "${_tord}/"
    # Set up ~/.tor-browser/profile.default etc.
    _prof="${DOTDIR}/profile.default"
    loudly cp "${TBB_SHARE_DIR}/profiles.ini" "${DOTDIR}/"
    loudly mkdir -p "${_prof}/preferences"
    loudly cp "${TBB_SHARE_DIR}/bookmarks.html" "${_prof}"
    loudly cp "${TBB_SHARE_DIR}/extension-overrides.js" "${_prof}/preferences"
    loudly mkdir "${_prof}/extensions"
    # FWIW: tar -C wins on both *BSD and Linux
    loudly "tar -C ${TBB_EXT_DIR} -cf - . | tar -C ${_prof}/extensions -xf -"
    spew "Initialized ${DOTDIR}"
}

check_dot_tor_browser () {
    [ ! -d "${DOTDIR}" -o ! -d "${DOTDIR}/tor_data" ] && setup_dot_tor_browser
}

run_tor_browser () {
    set -- $urls
    _log=""
    [ -n "$log" ] && _log=" >$log 2>&1"
    _det=""
    [ $detach -eq 1 ] && _det=' & '
    [ $verbose -gt 0 ] && \
        spew executing: ${BROWSER_BIN} \
             -profile "${DOTDIR}/profile.default" "${@}" \
             "</dev/null" "$_log $_det"
    eval ${BROWSER_BIN} \
         -profile "${DOTDIR}/profile.default" \
         "${@}" "</dev/null" $_log $_det
}

## Main

while [ $# -gt 0 ]; do
    case "$1" in
        --help)
            usage
            ;;
        --detach | --verbose | --dryrun | --init)
            setopt "$1"
            ;;
        --log)
            setopt "$1" "$2"
            exec >$log 2>&1
            ;;
        -*)
            usage "unrecongized option: $1"
            ;;
        *)
            if [ -z "$urls" ]; then
                urls="$1"
            else
                urls="${urls} $1"
            fi
            ;;
    esac
    shift
done

check_env_sanity
check_dot_tor_browser
# If --init or --dryrun was specified, don't run the browser
[ $init -eq 0 -a $dryrun -eq 0 ] && run_tor_browser $urls
