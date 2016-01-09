# $OpenBSD$

ADDON_NAME =		https-everywhere
V =			5.1.1
COMMENT =		HTTPS Everywhere: Part of the Tor Browser Bundle
GUID =			https-everywhere@eff.org
ALL_TARGET =		prerelease
PERMIT_PACKAGE_CDROM =	Yes
BUILD_DEPENDS +=	textproc/py-lxml

# Gross hack due to git submodules
XLATIONS = https://github.com/torbsd/httpse-translations/archive/20160109.tar.gz

post-extract:
	(cd ${WRKSRC}/translations; ftp -o - ${XLATIONS} | tar -s '/^httpse-translations-20160109\///' -zxf -)

.include <bsd.port.mk>
