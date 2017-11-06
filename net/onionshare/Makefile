# $OpenBSD$

COMMENT =		secure and anonymous file-sharing over Tor

V =			1.1
PKGNAME =		onionshare-${V}

CATEGORIES =		net

HOMEPAGE =		https://onionshare.org/

MAINTAINER =            Sean Levy <attila@stalphonsos.com>

# GPLv3
PERMIT_PACKAGE_CDROM =	Yes

GH_ACCOUNT =		micahflee
GH_PROJECT =		onionshare
GH_TAGNAME =		v${V}

MODULES =		lang/python
MODPY_VERSION =		${MODPY_DEFAULT_VERSION_3}
MODPY_SETUPTOOLS =	No
RUN_DEPENDS =		x11/py-qt5${MODPY_FLAVOR} \
			devel/py-sip${MODPY_FLAVOR} \
			www/py-flask${MODPY_FLAVOR} \
			net/stem${MODPY_FLAVOR} \
			devel/desktop-file-utils
TEST_DEPENDS =		devel/py-nose${MODPY_FLAVOR}

do-test:
	@cd ${WRKSRC} && nosetests${MODPY_BIN_SUFFIX} test

.include <bsd.port.mk>
