# $OpenBSD$

TBB_DISTNAME =		tor-launcher
TBB_DISTVERS =		0.2.7.2
COMMENT =		tor-launcher add-on: Part of the Tor Browser Bundle

USE_GMAKE =		Yes
ALL_TARGET =		package
MODULES =		www/tbb-addon
# So /etc/tor exists... 
BUILD_DEPENDS =		net/tor
GUID =			tor-launcher@torproject.org

post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/examples/tbb
	${SUBST_DATA} ${FILESDIR}/tbb-torrc ${PREFIX}/share/examples/tbb/tbb-torrc

.include <bsd.port.mk>
