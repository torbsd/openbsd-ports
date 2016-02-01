# $OpenBSD$
# Some of this comes from www/firefox-esr as apropos, since Tor
# browser is a fork of ESR.  It is a good idea to look at that
# Makefile when editing this one (ESR versions not always the same).

COMMENT =		Tor browser, based on Firefox ESR

MOZILLA_VERSION =	${TBB_VERSION}
MOZILLA_PROJECT =	${BROWSER_NAME} # tor-browser
MOZILLA_CODENAME =	browser
BROKEN-sparc64 =	xpcshell SIGBUS during fake

GH_PROJECT =		torb
GH_TAGNAME =		v${TBB_VERSION}-esr38.5.0

PKGNAME =		${BROWSER_NAME}-${TBB_VERSION}
DISTNAME =		${GH_TAGNAME}

SO_VERSION =		1.0
MOZILLA_LIBS =		browsercomps mozalloc mozgnome xul
MOZILLA_LIBS +=		freebl3 nss3 nssckbi nssdbm3
MOZILLA_LIBS +=		nssutil3 smime3 softokn3 ssl3

# mozilla public license
PERMIT_PACKAGE_CDROM=	Yes

MODULES =		www/mozilla devel/gettext lang/python

MOZILLA_USE_BUNDLED_NSS = Yes
MOZILLA_MASTER_SITES = https://github.com/${GH_ACCOUNT}/${GH_PROJECT}/archive/
WRKDIST 		= ${WRKDIR}/${GH_PROJECT}-${GH_TAGNAME:C/^v//}

MODPY_RUNDEP =		No

# necessary glue to build with the correct compiler after fx 17
MODULES +=		gcc4 lang/clang
MODGCC4_ARCHS =		powerpc sparc64 alpha
MODGCC4_LANGS =		c c++
MODCLANG_ARCHS =	amd64 i386
MODCLANG_LANGS =	c c++

# Regression tests are too hard to adapt to run here
NO_TEST =		Yes

# for nss build system
MAKE_ENV +=	BUILD_OPT=1 \
		LOCALBASE="${LOCALBASE}" \
		NSS_ENABLE_ECC=1 \
		NSS_USE_SYSTEM_SQLITE=1 \
		XCFLAGS="-I${LOCALBASE}/include ${CFLAGS}"

CONFIGURE_STYLE =	autoconf no-autoheader

# to be able to link when building with clang on i386 or gcc on ppc
.if ${MACHINE_ARCH} == "i386" || ${MACHINE_ARCH} == "powerpc"
CONFIGURE_ARGS +=	--disable-debug-symbols
.endif

# Avoid conflict with other firefox installs (ESR, regular, seamonkey).
#
CONFIGURE_ARGS +=	--with-app-name=${BROWSER_NAME} 		\
			--with-tor-browser-version=${TBB_VERSION}	\
			--disable-tor-browser-update
# Reminder: dig deeper, fix --with-user-appdir and submit a patch
# upstream so I can get rid of the patch in nsXREDirProvider.cpp.
#CONFIGURE_ARGS += --with-user-appdir=.${BROWSER_NAME}

# relies on pulseaudio for sound and broken at runtime
CONFIGURE_ARGS +=	--disable-webrtc

# bug #1064665
LIB_DEPENDS +=	textproc/icu4c
CONFIGURE_ARGS += --with-system-icu
WANTLIB += icudata icui18n icuuc

CONFIGURE_ARGS +=	--enable-gstreamer=1.0

BUILD_DEPENDS +=	multimedia/gstreamer1/plugins-base
# XXX Not needed? Not in firefox-esr
#RUN_DEPENDS +=		multimedia/gstreamer1/plugins-good
# start-tor-browser.sh wants something to use for cries for help
RUN_DEPENDS +=		x11/gxmessage

MOZILLA_AUTOCONF_DIRS +=	js/src

# pkg/PLIST fu
SUBST_VARS += 		BROWSER_NAME TBB_VERSION

post-extract:
	# hack .mozconfig
	cp ${WRKSRC}/.mozconfig ${WRKSRC}/.mozconfig.bak
	sed -e 's/@TOPSRCDIR@\/obj-@CONFIG_GUESS@/${WRKBUILD:S/\//\\\//g}/' \
		< ${WRKSRC}/.mozconfig.bak > ${WRKSRC}/.mozconfig
	# hack config/baseconfig.mk to not use MOZ_APP_VERSION in a few places
	cp ${WRKSRC}/config/baseconfig.mk ${WRKSRC}/config/baseconfig.mk.bak
	sed -e 's/-$$(MOZ_APP_VERSION)/-${TBB_VERSION}/'	\
		< ${WRKSRC}/config/baseconfig.mk.bak 		\
		> ${WRKSRC}/config/baseconfig.mk
	# honor our SO_VERSION in nss build system
	sed -i.bak -E -e \
 's/^DLL_SUFFIX[[:space:]]+=[[:space:]]+so.1.0/DLL_SUFFIX = so.${SO_VERSION}/' \
		${WRKSRC}/security/nss/coreconf/OpenBSD.mk

post-install:
	# install prefs
	${INSTALL_DATA_DIR} \
	  ${PREFIX}/lib/${PKGNAME}/browser/defaults/preferences
	${SUBST_DATA} ${FILESDIR}/all-openbsd.js \
	  ${PREFIX}/lib/${PKGNAME}/browser/defaults/preferences/all-openbsd.js
	# install desktop file
	${SUBST_PROGRAM} ${FILESDIR}/start-${BROWSER_NAME}.sh \
		${PREFIX}/bin/start-${BROWSER_NAME}
	${INSTALL_DATA_DIR} ${PREFIX}/share/applications/
	${SUBST_DATA} ${FILESDIR}/${BROWSER_NAME}.desktop \
		${PREFIX}/share/applications/${BROWSER_NAME}.desktop
	${INSTALL_DATA_DIR} ${PREFIX}/share/tbb
	${INSTALL_DATA} ${FILESDIR}/bookmarks.html \
		${PREFIX}/share/tbb/bookmarks.html
	${INSTALL_DATA} ${FILESDIR}/profiles.ini \
		${PREFIX}/share/tbb/profiles.ini
	${INSTALL_DATA} ${FILESDIR}/extension-overrides.js \
		${PREFIX}/share/tbb/extension-overrides.js
	# install icon for desktop file
	${INSTALL_DATA_DIR} ${PREFIX}/share/pixmaps/
	${INSTALL_DATA} ${PREFIX}/lib/${PKGNAME}/browser/icons/mozicon128.png \
		${PREFIX}/share/pixmaps/${BROWSER_NAME}.png
	# link default48.png to default.png to be used by default
	# by non-icccm compliant wm
	ln -f \
	 ${PREFIX}/lib/${PKGNAME}/browser/chrome/icons/default/default{48,}.png

love:
	@echo "MASTER_SITES = ${MASTER_SITES}"
	@echo "WRKDIST = ${WRKDIST}"

.include <bsd.port.mk>
