# $OpenBSD$

ADDON_NAME =		tor-launcher
V =			0.2.7.7
COMMENT =		tor-launcher add-on: Part of the Tor Browser Bundle
USE_GMAKE =		Yes
ALL_TARGET =		package
GUID =			tor-launcher@torproject.org
PERMIT_PACKAGE_CDROM =	Yes
RUN_DEPENDS +=		www/tbb/torbutton

post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/tbb
	${SUBST_DATA} ${FILESDIR}/torrc \
		${PREFIX}/share/tbb/torrc
	${SUBST_DATA} ${FILESDIR}/torrc-defaults \
		${PREFIX}/share/tbb/torrc-defaults

.include <bsd.port.mk>
