# $OpenBSD$
# Some of this comes from www/firefox-esr as apropos, since Tor
# browser is a fork of ESR.  It is a good idea to look at that
# Makefile when editing this one (ESR versions not always the same).

COMMENT =		firefox-esr fork for browsing the web over Tor

MOZILLA_VERSION =	${TBB_VERSION}
MOZILLA_PROJECT =	${BROWSER_NAME}
MOZILLA_CODENAME =	browser
BROKEN-sparc64 =	xpcshell SIGBUS during fake

GH_PROJECT =		torb
GH_TAGNAME =		v${TBB_VERSION}-esr45.1.1

PKGNAME =		${BROWSER_NAME}-${TBB_VERSION}
DISTNAME =		${GH_TAGNAME}

SO_VERSION =		1.0
MOZILLA_LIBS =		browsercomps xul lgpllibs
MOZILLA_LIBS +=		freebl3 nss3 nssckbi nssdbm3
MOZILLA_LIBS +=		nssutil3 smime3 softokn3 ssl3

# mozilla public license
PERMIT_PACKAGE_CDROM=	Yes

MODULES =		www/mozilla lang/python

# Things we must override to use www/mozilla:
MOZILLA_USE_BUNDLED_NSS = Yes
MOZILLA_USE_BUNDLED_LIBEVENT = Yes
MASTER_SITES = 		https://github.com/${GH_ACCOUNT}/${GH_PROJECT}/archive/
EXTRACT_SUFX = 		.tar.gz
DIST_SUBDIR = 		${BROWSER_NAME}
WRKDIST = 		${WRKDIR}/${GH_PROJECT}-${GH_TAGNAME:C/^v//}

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

LIB_DEPENDS +=		devel/gettext>=0.10.38 \
			converters/libiconv
BUILD_DEPENDS +=	devel/gettext>=0.10.38
RUN_DEPENDS +=		devel/gettext>=0.10.38
WANTLIB +=		intl>=5 iconv>=6

# to be able to link when building with clang on i386 or gcc on ppc
.if ${MACHINE_ARCH} == "i386" || ${MACHINE_ARCH} == "powerpc"
CONFIGURE_ARGS +=	--disable-debug-symbols
.endif

# Avoid conflict with other firefox installs, use ~/.tor-browser
CONFIGURE_ARGS +=	--with-app-name=${BROWSER_NAME} 		\
			--with-tor-browser-version=${TBB_VERSION}	\
			--disable-tor-browser-update			\
			--with-user-appdir=.${BROWSER_NAME}

# relies on pulseaudio for sound and broken at runtime
CONFIGURE_ARGS +=	--disable-webrtc

# bug #1064665
LIB_DEPENDS +=	textproc/icu4c
CONFIGURE_ARGS += --with-system-icu
WANTLIB += icudata icui18n icuuc

CONFIGURE_ARGS +=	--disable-gstreamer

BUILD_DEPENDS +=	multimedia/gstreamer1/plugins-base
RUN_DEPENDS +=		net/tor>=0.2.7.6

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

post-install:
	# install prefs, bookmarks, app config file for Tor browser
	${INSTALL_DATA_DIR} \
	  ${PREFIX}/lib/${PKGNAME}/browser/defaults/preferences
	${SUBST_DATA} ${FILESDIR}/all-openbsd.js \
	  ${PREFIX}/lib/${PKGNAME}/browser/defaults/preferences/all-openbsd.js
	${INSTALL_DATA_DIR} \
	  ${PREFIX}/lib/${PKGNAME}/browser/defaults/profile
	${INSTALL_DATA} ${FILESDIR}/bookmarks.html \
	  ${PREFIX}/lib/${PKGNAME}/browser/defaults/profile
	${INSTALL_DATA} ${FILESDIR}/${BROWSER_NAME}.cfg \
	  ${PREFIX}/lib/${PKGNAME}/${BROWSER_NAME}.cfg
	# install desktop file
	${INSTALL_DATA_DIR} ${PREFIX}/share/applications/
	${SUBST_DATA} ${FILESDIR}/${BROWSER_NAME}.desktop \
		${PREFIX}/share/applications/${BROWSER_NAME}.desktop
	# install icon for desktop file
	${INSTALL_DATA_DIR} ${PREFIX}/share/pixmaps/
	${INSTALL_DATA} ${PREFIX}/lib/${PKGNAME}/browser/icons/mozicon128.png \
		${PREFIX}/share/pixmaps/${BROWSER_NAME}.png
	# link default48.png to default.png to be used by default
	# by non-icccm compliant wm
	ln -f \
	 ${PREFIX}/lib/${PKGNAME}/browser/chrome/icons/default/default{48,}.png

.include <bsd.port.mk>
