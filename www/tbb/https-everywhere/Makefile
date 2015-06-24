# $OpenBSD$

ADDON_NAME =		https-everywhere
V =			5.0.5
COMMENT =		HTTPS Everywhere: Part of the Tor Browser Bundle
GUID =			https-everywhere@eff.org
ALL_TARGET =		prerelease
PERMIT_PACKAGE_CDROM =	Yes
BUILD_DEPENDS +=	textproc/py-lxml shells/bash
MAKE_ENV =		MAKEXPI=./openbsd.sh

post-extract:
	cp ${FILESDIR}/openbsd.sh ${WRKSRC}
	chmod +x ${WRKSRC}/openbsd.sh

.include <bsd.port.mk>
