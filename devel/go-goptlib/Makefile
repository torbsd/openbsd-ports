# $OpenBSD$

COMMENT =		library for writing Tor pluggable transports in Go

GH_ACCOUNT =		torbsd
GH_PROJECT =		goptlib
GH_TAGNAME =		0.7
DISTNAME =		go-goptlib
PKGNAME =		${DISTNAME}-${GH_TAGNAME}

CATEGORIES =		devel

HOMEPAGE =		https://www.torproject.org/docs/pluggable-transports

MAINTAINER =		Sean Levy <attila@stalphonsos.com>

# BSD
PERMIT_PACKAGE_CDROM =	Yes

MODULES +=		lang/go

ALL_TARGET =		git.torproject.org/pluggable-transports/goptlib.git

MODGO_TYPE =		lib

.include <bsd.port.mk>
