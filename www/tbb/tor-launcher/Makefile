# $OpenBSD$

ADDON_NAME =		tor-launcher
V =			0.2.7.0.2
COMMENT =		tor-launcher add-on: Part of the Tor Browser Bundle
USE_GMAKE =		Yes
ALL_TARGET =		package
GUID =			tor-launcher@torproject.org
PERMIT_PACKAGE_CDROM =	Yes

post-install:
	${INSTALL_DATA_DIR} ${TBB_EXAMPLES}
	${SUBST_DATA} ${FILESDIR}/torrc ${TBB_EXAMPLES}/torrc

.include <bsd.port.mk>
