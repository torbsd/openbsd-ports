# $OpenBSD$

ADDON_NAME =		torbutton
V =			1.9.4.3
COMMENT =		firefox add-on: onion menu, etc. for Tor browser
GUID =			torbutton@torproject.org
PERMIT_PACKAGE_CDROM =	Yes

do-build:
	cd ${WRKSRC} && ./makexpi.sh

.include <bsd.port.mk>
