# $OpenBSD$

# Module for Tor Browser Bundle (tbb) firefox extensions.
# Adapted from mail/enigmail/Makefile by attila@stalphonsos.com

MAINTAINER ?=		sean levy <attila@stalphonsos.com>

# keep in synch with mozilla.port.mk
ONLY_FOR_ARCHS =	i386 amd64 powerpc sparc64

ZIP ?=				zip
MOZILLA_ADDON_XPI ?=
.if ${MOZILLA_ADDON_XPI:L} == "yes"
EXTRACT_CASES = *.xpi) \
	${UNZIP} -oq ${FULLDISTDIR}/$$archive -d ${WRKSRC};;
EXTRACT_SUFX = .xpi
.endif

.if defined(MOZILLA_ADDON_NAME)
TBB_DISTNAME ?=		${MOZILLA_ADDON_NAME}
TBB_DISTVERS ?=		${V}
PKGNAME ?=		tbb-${TBB_DISTNAME}-${V}
.endif

DISTNAME ?=		${TBB_DISTNAME}-${TBB_DISTVERS}
HOMEPAGE ?=		http://www.torproject.org

.if !defined(MASTER_SITES)
GH_ACCOUNT ?=		torbsd
GH_PROJECT ?=		${TBB_DISTNAME}
GH_TAGNAME ?=		${TBB_DISTVERS}
.endif
CATEGORIES =		www

# MPL
PERMIT_PACKAGE_CDROM=	Yes

CONFIGURE_STYLE =	none

BUILD_DEPENDS =		archivers/zip \
			archivers/unzip
WRKDIST =		${WRKDIR}/${TBB_DISTNAME}-${TBB_DISTVERS}
TBB_BUILD_SUBDIR ?=	pkg
TBB_BUILDDIR ?= 	${WRKBUILD}/${TBB_BUILD_SUBDIR}

# This isn't right: how to keep this synchronized with tor-browser?
TBB_VERSION ?=		4.0.6

# needed for the naming of the libsubprocess.so
# the xpi, and the arch matching within mozilla
.if ${MACHINE_ARCH:Mi386}
XPCOM_ABI =		x86
.elif ${MACHINE_ARCH:Mamd64}
XPCOM_ABI =		x86_64
.elif ${MACHINE_ARCH:Mpowerpc}
XPCOM_ABI =		ppc
.elif ${MACHINE_ARCH:Msparc64}
XPCOM_ABI =		sparc
.endif
SUBST_VARS += 		XPCOM_ABI

# Gleaned via ktrace, I don't think this is where it
# normally goes:
EXTDIR_ROOT ?=		lib/tor-browser-${TBB_VERSION}
EXTDIR_BASE ?=  	${EXTDIR_ROOT}/distribution
EXTDIR ?=		${EXTDIR_BASE}/extensions/
REAL_EXTDIR ?=		${PREFIX}/${EXTDIR}

SUBST_VARS +=		EXTDIR_ROOT EXTDIR_BASE EXTDIR TBB_VERSION

.if !defined(GUID)
ERRORS += "GUID missing: tbb ports module requires it"
.endif

.if ${MOZILLA_ADDON_XPI:L} == "yes"
pre-extract:
	mkdir -p ${TBB_BUILDDIR}

do-build:
	cd ${WRKSRC} && ${ZIP} -X -9r ${WRKDIST}/${DISTNAME}.xpi ./ && mv ${WRKDIST}/${DISTNAME}.xpi ${TBB_BUILDDIR}
.endif

do-install:
	${INSTALL_DATA_DIR} ${REAL_EXTDIR}/${GUID}
	${UNZIP} -oq ${TBB_BUILDDIR}/${TBB_DISTNAME}*.xpi -d ${REAL_EXTDIR}/${GUID}
