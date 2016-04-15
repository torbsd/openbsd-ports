# OpenBSD Ports for the Tor Browser Bundle (TBB) #

These are the OpenBSD ports that correspond to the Tor browser bundle.
They are a work in progress.  Please beware that until we make release
announcements on [our web site](https://torbsd.github.io) you should
be careful using this stuff.  You must be runing OpenBSD -current and
have your ports and src synced up (like I said: running -current).

## Branches and Versions ##

As of 05 Feb 2016 the `master` branch has release __5.5__:

    ff-esr            38.6.0
    torbutton         1.9.4.3
    tor-launcher      0.2.7.8
    noscript          2.9.0.2
    https-everywhere  5.1.2

The `develop` branch is always used to work on the next release.

We use tags to mark release points that correspond as closely as
possible to TBB releases.  They are marked "-sans-pt" to indicate that
Pluggable Transports (PT) is not yet a part of this set of ports
(e.g. tbb-5.5-sans-pt).  There may also be fixes, which are tagged
...-fixN, e.g. tbb-5.5-sans-pt-fix1, -fix2, ...

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

## Beware: Experimental Until Otherwise Stated ##

This is still work in progress.  Until we make an official release
statement you should use this only if you want to help in testing. 

## Contact ##

You can get my attention by posting [issues](https://github.com/torbsd/openbsd-ports/issues) to this repository if you
like, or use one of the contact methods mentioned on my
[home page](http://trac.haqistan.net/~attila).

--attila
