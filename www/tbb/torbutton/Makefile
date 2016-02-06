# $OpenBSD$

ADDON_NAME =		torbutton
V =			1.9.4.3
COMMENT =		torbutton Firefox Add on: Part of Tor Browser Bundle
GUID =			torbutton@torproject.org
PERMIT_PACKAGE_CDROM =	Yes

do-build:
	cd ${WRKSRC} && ./makexpi.sh

.include <bsd.port.mk>
