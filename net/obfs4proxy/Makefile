# $OpenBSD$

COMMENT =		a look-like nothing obfuscation protocol for TCP

V =			0.0.7
DISTNAME =		obfs4proxy-${V}

MASTER_SITES =		https://people.torproject.org/~yawning/releases/obfs4proxy/

EXTRACT_SUFX =		.tar.xz

CATEGORIES =		net www

HOMEPAGE =		https://github.com/Yawning/obfs4/blob/master/doc/obfs4-spec.txt

MAINTAINER =		Sean Levy <attila@stalphonsos.com>

# BSD
PERMIT_PACKAGE_CDROM =	Yes

MODULES +=		lang/go
MODGO_SUBDIR =		${WRKDIR}/${GH_PROJECT}-obfs4proxy-${GH_TAGNAME}
ALL_TARGET_BASE =	git.torproject.org/pluggable-transports/obfs4.git
WRKSRC =		${MODGO_WORKSPACE}/src/${ALL_TARGET_BASE}
ALL_TARGET =		${ALL_TARGET_BASE}/obfs4proxy \
			${ALL_TARGET_BASE}/common/log \
			${ALL_TARGET_BASE}/common/socks5 \
			${ALL_TARGET_BASE}/transports \
			${ALL_TARGET_BASE}/transports/base

BUILD_DEPENDS =		net/go-net \
			security/go-crypto \
			security/go-ed25519 \
			security/go-siphash \
			devel/go-goptlib

post-install:
	${INSTALL_MAN} ${WRKSRC}/doc/obfs4proxy.1 \
		${PREFIX}/man/man1/obfs4proxy.1

.include <bsd.port.mk>
