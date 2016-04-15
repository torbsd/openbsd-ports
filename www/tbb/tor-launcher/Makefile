# $OpenBSD$

ADDON_NAME =		tor-launcher
V =			0.2.7.8
COMMENT =		firefox add-on to control/manage tor server
GUID =			tor-launcher@torproject.org
ALL_TARGET =		package

post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/tbb
	${SUBST_DATA} ${FILESDIR}/torrc-defaults \
		${PREFIX}/share/tbb/torrc-defaults

.include <bsd.port.mk>
