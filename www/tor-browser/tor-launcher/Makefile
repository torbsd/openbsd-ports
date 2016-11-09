# $OpenBSD$

ADDON_NAME =		tor-launcher
V =			0.2.9.3
COMMENT =		firefox add-on to control/manage tor server
GUID =			tor-launcher@torproject.org
ALL_TARGET =		package
USE_GMAKE =		Yes

post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/${BROWSER_NAME}
	${SUBST_DATA} ${FILESDIR}/torrc-defaults \
		${PREFIX}/share/${BROWSER_NAME}/torrc-defaults

.include <bsd.port.mk>
