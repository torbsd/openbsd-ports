# OpenBSD Ports for the Tor Browser Bundle (TBB) #

These are the OpenBSD ports that correspond to the Tor browser bundle.
They are a work in progress.  Please beware that until we make release
announcements on [our web site](https://torbsd.github.io) you should
be careful using this stuff.  You must be runing OpenBSD -current and
have your ports and src synced up (like I said: running -current).

## Branches and Versions ##

This is the develop branch and is used to work on the bleeding edge.
As of 03 Feb 2016 this means working on __5.5__:

    ff-esr            38.6.0
    torbutton         1.9.4.3
    tor-launcher      0.2.7.8
    noscript          2.9.0.2
    https-everywhere  5.1.2

Everything changes version in this update.  Hopefully the work done on
5.0.6 that gets us riding on top of the official www/mozilla ports
module will make this update easier than the last one, which was more
or less all about making that switch.

## Repositories ##

Most of the ports in this repo pull their source tarballs from other
GH [torbsd repositories](https://github.com/torbsd).  This is because
the Tor project chooses not to make source tarballs easily available
for anything except tor itself (their gitian-based build process does
not require them).  Also, the OpenBSD ports system explicitly supports
pointing at GH projects.  I maintain the tags and branches in these
repositories and track changes in the
[tor project's git repositories](https://gitweb.torproject.org).
Where possible I prefer to have ports pull source from some
authoritative download area maintained by the project itself; in the
case of noscript I do this, for example.

## Contact ##

You can get my attention by posting [issues](https://github.com/torbsd/openbsd-ports/issues) to this repository if you
like, or use one of the contact methods mentioned on my
[home page](http://trac.haqistan.net/~attila).

`--attila`
