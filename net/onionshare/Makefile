# $OpenBSD$

COMMENT-main =		secure and anonymous file-sharing over Tor
COMMENT-gui =		graphical user interface for onionshare based on Qt

GH_ACCOUNT =		micahflee
GH_PROJECT =		onionshare
GH_TAGNAME =		v1.2
V =			${GH_TAGNAME:C/^v//}

PKGNAME-main =		onionshare-${V}
PKGNAME-gui =		onionshare-gui-${V}

CATEGORIES =		net

HOMEPAGE =		https://onionshare.org/

MAINTAINER =		George Rosamond <george@nycbug.org>

# GPLv3
PERMIT_PACKAGE_CDROM =	Yes

MULTI_PACKAGES =	-main -gui
SUBST_VARS +=		PKGNAME

MODULES =		lang/python
MODPY_VERSION =		${MODPY_DEFAULT_VERSION_3}
MODPY_SETUPTOOLS =	No
RUN_DEPENDS =		devel/py-sip${MODPY_FLAVOR} 		\
			www/py-flask${MODPY_FLAVOR} 		\
			net/py-stem${MODPY_FLAVOR} 		\
			net/tor
RUN_DEPENDS-gui =	${RUN_DEPENDS} 				\
			x11/py-qt5${MODPY_FLAVOR} 		\
			devel/desktop-file-utils
TEST_DEPENDS =		devel/py-test${MODPY_FLAVOR}		\
			net/py-stem${MODPY_FLAVOR}

NO_TEST =		Yes

do-test:
	@cd ${WRKSRC} && nosetests${MODPY_BIN_SUFFIX} test

.include <bsd.port.mk>
