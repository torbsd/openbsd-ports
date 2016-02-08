# $OpenBSD$

ADDON_NAME =		https-everywhere
V =			5.1.2
COMMENT =		turn http:// into https:// where possible in Tor browser
HOMEPAGE =		https://www.eff.org/https-everywhere
GUID =			https-everywhere@eff.org
ALL_TARGET =		prerelease
PERMIT_PACKAGE_CDROM =	Yes
BUILD_DEPENDS +=	textproc/py-lxml shells/bash net/rsync

MASTER_SITES =		http://bits.haqistan.net/~tdp/
DISTFILES =		${ADDON_NAME}-${V}.tar.gz

.include <bsd.port.mk>
