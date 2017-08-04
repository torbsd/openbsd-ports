# $OpenBSD$

COMMENT =		ed25519 in go

COMMIT_ID =		5312a61534124124185d41f09206b9fef1d88403

GH_ACCOUNT =		agl
GH_PROJECT =		ed25519
GH_COMMIT = 		${COMMIT_ID:C/^(.......).*$/\\1/}
WRKDIST = 		${WRKDIR}/${GH_PROJECT}-${COMMIT_ID}
DISTNAME =		go-ed25519
PKGNAME =		${DISTNAME}-20170116

CATEGORIES =		security

HOMEPAGE =		https://github.com/agl/ed25519

MAINTAINER =		Sean Levy <attila@stalphonsos.com>

# BSD
PERMIT_PACKAGE_CDROM =	Yes

MODULES +=		lang/go

MODGO_TYPE =		lib
WRKSRC =		${MODGO_WORKSPACE}/src/github.com/agl/ed25519
ALL_TARGET += 		github.com/agl/ed25519/edwards25519 \
			github.com/agl/ed25519/extra25519

BUILD_DEPENDS =		security/go-crypto

.include <bsd.port.mk>
