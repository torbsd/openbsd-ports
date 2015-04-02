# $OpenBSD$

TBB_DISTNAME =		torbutton
TBB_DISTVERS =		1.9.0.0
COMMENT =		torbutton Firefox Add on: Part of Tor Browser Bundle

MODULES =		www/tbb-addon

GUID =			torbutton@torproject.org

do-build:
	cd ${WRKSRC} && ./makexpi.sh

.include <bsd.port.mk>
