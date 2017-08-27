# $OpenBSD: Makefile.template,v 1.72 2015/04/08 17:53:19 sthen Exp $
# DEPS: build-essential fakeroot python3-all python3-stdeb dh-python
# python3-flask python3-stem python3-pyqt5 python-nautilus python3-nose
# install build_deb.sh => build_posix.sh?

COMMENT =		secure and anonymous file-sharing over Tor

V =			1.1
PKGNAME =		onionshare-${V}

CATEGORIES =		net

HOMEPAGE =		https://onionshare.org/

MAINTAINER =            Sean Levy <attila@stalphonsos.com>

# GPLv3
PERMIT_PACKAGE_CDROM =	Yes

# "make port-lib-depends-check" can help
#WANTLIB =		???

GH_ACCOUNT =		micahflee
GH_PROJECT =		onionshare
GH_TAGNAME =		v${V}

MODULES =		lang/python
MODPY_VERSION =		${MODPY_DEFAULT_VERSION_3}
MODPY_SETUPTOOLS =	Yes
RUN_DEPENDS =		x11/py-qt5${MODPY_FLAVOR} \
			devel/py-sip${MODPY_FLAVOR} \
			www/py-flask${MODPY_FLAVOR} \
			net/stem${MODPY_FLAVOR}
TEST_DEPENDS =		devel/py-nose${MODPY_FLAVOR}

#NO_TEST =		Yes

.include <bsd.port.mk>
