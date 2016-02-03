# $OpenBSD$

ADDON_NAME =		https-everywhere
V =			5.1.2
COMMENT =		HTTPS Everywhere: Part of the Tor Browser Bundle
GUID =			https-everywhere@eff.org
ALL_TARGET =		prerelease
PERMIT_PACKAGE_CDROM =	Yes
BUILD_DEPENDS +=	textproc/py-lxml shells/bash net/rsync

# Gross hack due to git submodules
XLATIONS_TAG = 20160203
XLATIONS = https://github.com/torbsd/httpse-translations/archive/${XLATIONS_TAG}.tar.gz

post-extract:
	(cd ${WRKSRC}/translations; ftp -o - ${XLATIONS} | tar -s '/^httpse-translations-${XLATIONS_TAG}\///' -zxf -)

.include <bsd.port.mk>
