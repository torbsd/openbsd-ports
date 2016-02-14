# $OpenBSD$

ADDON_NAME =		https-everywhere
V =			5.1.2
COMMENT =		http:// -> https:// where possible in Tor browser
HOMEPAGE =		https://www.eff.org/https-everywhere
GUID =			https-everywhere@eff.org
BUILD_DEPENDS +=	textproc/py-lxml shells/bash net/rsync
ALL_TARGET =		prerelease
ADDON_XPI_FILE =	${ADDON_NAME}.xpi

MASTER_SITES =		http://mirrors.nycbug.org/pub/distfiles/
DISTFILES =		${ADDON_NAME}-${V}.tar.gz

.include <bsd.port.mk>
