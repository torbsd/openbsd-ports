#-*- mode: Makefile; tab-width: 4; -*-
# $OpenBSD$
# Common fu mainly for tor browser addons.

# A few things are common across the board:
MAINTAINER ?=		sean levy <attila@stalphonsos.com>
HOMEPAGE ?=			https://www.torproject.org
GH_ACCOUNT ?=		torbsd
CATEGORIES =		www
BROWSER_NAME =		tor-browser
TBB_VERSION =		4.0.6
BUILD_DEPENDS +=	net/tor
RUN_DEPENDS +=		net/tor

# Used by tor-launcher
TBB_EXAMPLES =		${PREFIX}/share/examples/tbb

# Everything in this .if (most of the file) is for add-ons like
# torbutton, tor-launcher, ... tor-browser does its own thing.
.if !empty(ADDON_NAME)
ZIP ?=				zip
ADDON_XPI ?=
ADDON_NAME ?=
.  if ${ADDON_XPI:L} == "yes"
EXTRACT_CASES = *.xpi) \
	${UNZIP} -oq ${FULLDISTDIR}/$$archive -d ${WRKSRC};;
EXTRACT_SUFX = .xpi
.  endif

TBBNAME ?=			${ADDON_NAME}-${V}
PKGNAME ?=			tbb-${TBBNAME}
DISTNAME ?=			${TBBNAME}
WRKDIST =			${WRKDIR}/${TBBNAME}
ADDON_SUBDIR ?=		pkg
ADDON_BUILDDIR ?= 	${WRKBUILD}/${ADDON_SUBDIR}
.  if !defined(MASTER_SITES)
GH_PROJECT ?=		${ADDON_NAME}
GH_TAGNAME ?=		${V}
.  endif

CONFIGURE_STYLE =	none
BUILD_DEPENDS +=	archivers/zip \
					archivers/unzip

# needed for the naming of the libsubprocess.so
# the xpi, and the arch matching within mozilla
.  if ${MACHINE_ARCH:Mi386}
XPCOM_ABI =			x86
.  elif ${MACHINE_ARCH:Mamd64}
XPCOM_ABI =			x86_64
.  elif ${MACHINE_ARCH:Mpowerpc}
XPCOM_ABI =			ppc
.  elif ${MACHINE_ARCH:Msparc64}
XPCOM_ABI =			sparc
.  endif
SUBST_VARS += 		XPCOM_ABI

# Gleaned via ktrace, I don't think this is where it
# normally goes:
EXTDIR_ROOT ?=		lib/${BROWSER_NAME}-${TBB_VERSION}
EXTDIR_BASE ?=  	${EXTDIR_ROOT}/distribution
EXTDIR ?=			${EXTDIR_BASE}/extensions/
REAL_EXTDIR ?=		${PREFIX}/${EXTDIR}

SUBST_VARS +=		EXTDIR_ROOT EXTDIR_BASE EXTDIR TBB_VERSION

.  if !defined(GUID)
ERRORS += "GUID missing: tbb ports module requires it"
.  endif

.  if ${ADDON_XPI:L} == "yes"
pre-extract:
	mkdir -p ${ADDON_BUILDDIR}

do-build:
	cd ${WRKSRC} && ${ZIP} -X -9r ${WRKDIST}/${DISTNAME}.xpi ./ && mv ${WRKDIST}/${DISTNAME}.xpi ${ADDON_BUILDDIR}
.  endif

do-install:
	${INSTALL_DATA_DIR} ${REAL_EXTDIR}/${GUID}
	${UNZIP} -oq ${ADDON_BUILDDIR}/${ADDON_NAME}*.xpi -d ${REAL_EXTDIR}/${GUID}
.endif
