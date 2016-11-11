# $OpenBSD$

ADDON_NAME =		torbutton
V =			1.9.5.7
COMMENT =		Firefox add-on for configuring Tor Browser settings
GUID =			torbutton@torproject.org
PKGNAME =		${TB_NAME}

do-build:
	cd ${WRKSRC} && ./makexpi.sh

.include <bsd.port.mk>
