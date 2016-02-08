# $OpenBSD$

ADDON_NAME =		noscript
V =			2.9.0.2
COMMENT =		flexible JS blocker for firefox (Tor browser variant)
ADDON_XPI =		Yes
MAINTAINER =		sean levy <attila@stalphonsos.com>
HOMEPAGE =		http://noscript.net
MASTER_SITES =		https://secure.informaction.com/download/releases/
# GPLv2+
PERMIT_PACKAGE_CDROM =	Yes
GUID =			{73a6fe31-595d-460b-a920-fcc0f8843232}

META_INF_DIR =		${REAL_EXTDIR}/${GUID}/META-INF

pre-install:
	mkdir -p ${META_INF_DIR}
	chmod 755 ${META_INF_DIR}

post-install:
	chmod 644 ${META_INF_DIR}/*

.include <bsd.port.mk>
