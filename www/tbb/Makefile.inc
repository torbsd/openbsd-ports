# $OpenBSD$

MAINTAINER ?=		Sean Levy <attila@stalphonsos.com>
HOMEPAGE ?=			https://www.torproject.org
GH_ACCOUNT ?=		torbsd
PERMIT_PACKAGE_CDROM ?= Yes
CATEGORIES =		www
BROWSER_NAME =		tor-browser
TBB_VERSION =		6.0

# Used by tor-launcher, tor-browser
TBB_EXAMPLES =		${PREFIX}/share/examples/tbb

ADDON_NAME ?=
.if !empty(ADDON_NAME)
# Everything in this .if (most of the file) is for add-ons like
# torbutton, tor-launcher, ... tor-browser does its own thing.
.  if !defined(GUID)
ERRORS += "GUID missing: please set a GUID for ${ADDON_NAME}"
.  endif
USE_GMAKE =			Yes

# This should be set to Yes if the distfile for the addon is the .xpi
# file itself (noscript, https-everywhere)
DISTFILE_IS_XPI ?= 	No

TBBNAME ?=			${ADDON_NAME}-${V}
PKGNAME ?=			${TBBNAME}
DISTNAME ?=			${TBBNAME}
WRKDIST =			${WRKDIR}/${TBBNAME}
ADDON_XPI_FILE ?=	${TBBNAME}.xpi
# Directory that the port's makexpi.sh script dumps into, if it has one
ADDON_SUBDIR ?=		pkg
ADDON_BUILDDIR ?= 	${WRKBUILD}/${ADDON_SUBDIR}
.  if !defined(MASTER_SITES)
GH_PROJECT ?=		${ADDON_NAME}
GH_TAGNAME ?=		${V}
.  endif

CONFIGURE_STYLE ?=	none
BUILD_DEPENDS +=	archivers/zip archivers/unzip
RUN_DEPENDS +=		www/tbb/tor-browser

EXTDIR_ROOT ?=		lib/${BROWSER_NAME}-${TBB_VERSION}
EXTDIR_BASE ?=  	${EXTDIR_ROOT}/browser
EXTDIR ?=		${EXTDIR_BASE}/extensions/
REAL_EXTDIR ?=		${PREFIX}/${EXTDIR}

SUBST_VARS +=		EXTDIR_ROOT EXTDIR_BASE EXTDIR TBB_VERSION

SUBST_VARS +=		GUID

.  if ${DISTFILE_IS_XPI:L} == "yes"
EXTRACT_SUFX = .xpi

do-extract:
	mkdir -p ${ADDON_BUILDDIR}

do-build:
	cp ${FULLDISTDIR}/${ADDON_XPI_FILE} ${ADDON_BUILDDIR}/${ADDON_XPI_FILE}
.  endif

do-install:
	${INSTALL_DATA_DIR} ${REAL_EXTDIR}
	${INSTALL_DATA} ${ADDON_BUILDDIR}/${ADDON_XPI_FILE} ${REAL_EXTDIR}/${GUID}.xpi

.endif
