# $OpenBSD$
# Many things here come from www/firefox-esr/Makefile and
# www/mozilla/mozilla.port.mk, either directly or adapted.  As a
# result this Makefile must be maintained with an eye towards
# compatibility with those two things.

COMMENT =		Tor Browser (based on Firefox ESR)

GH_PROJECT =		torb
GH_TAGNAME =		v${TBB_VERSION}-esr31.8.0

DISTNAME =		${GH_PROJECT}-${GH_TAGNAME}
PKGNAME =		${BROWSER_NAME}-${TBB_VERSION}

SO_VERSION =		1.0
MOZILLA_LIBS =		browsercomps mozalloc mozgnome xul

# mozilla public license
PERMIT_PACKAGE_CDROM=	Yes

## Many things beyond this point taken from www/firefox-esr
MODULES =		devel/gettext lang/python

MODPY_RUNDEP =		No

# necessary glue to build with the correct compiler after fx 17
MODULES +=		gcc4 lang/clang
MODGCC4_ARCHS =		powerpc sparc64 alpha i386
MODGCC4_LANGS =		c c++
MODCLANG_ARCHS =	amd64
MODCLANG_LANGS =	c c++
# fix for 982693
.if ${MACHINE_ARCH:Mamd64}
MAKE_ENV += 		VPXHACK="-fno-integrated-as"
.endif

# Regression tests are too hard to adapt to run here
NO_TEST =		Yes

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

CONFIGURE_ARGS +=	--enable-gstreamer=1.0

# libxul doesnt link directly with gst but dlopens it at runtime
# see content/media/gstreamer/GStreamerLoader.cpp
#LIB_DEPENDS +=	multimedia/gstreamer-0.10/plugins-base
#WANTLIB += gmodule-2.0 gstapp-0.10 gstbase-0.10 gstreamer-0.10
#WANTLIB += gstvideo-0.10 xml2

BUILD_DEPENDS +=	multimedia/gstreamer1/plugins-base
RUN_DEPENDS +=		multimedia/gstreamer1/plugins-good
RUN_DEPENDS +=		devel/desktop-file-utils

# needs 3.0.10 when not using gcc
# CONFIGURE_ARGS += --with-system-ffi

# --with-system-png=${LOCALBASE}
# no system png : apng support not bundled in
 
OUR_AUTOCONF_DIRS +=	js/src

# pkg/PLIST fu
SUBST_VARS += 		BROWSER_NAME

## >>> From here on adapted liberally from mozilla.port.mk

SHARED_ONLY =		Yes
ONLY_FOR_ARCHS=		amd64 arm i386 powerpc sparc64
# gcc does ICE on alpha at some particular spots:
# thunderbird-24.0/comm-esr24/mozilla/js/src/vm/Debugger.cpp:3246
# firefox-24.0/mozilla-release/js/src/frontend/BytecodeEmitter.cpp:1488
# seamonkey-2.22/comm-release/mozilla/js/src/vm/Interpreter.cpp:743
# firefox-25.0/mozilla-release/js/src/builtin/MapObject.cpp:1119

DPB_PROPERTIES =	parallel

.for _lib in ${MOZILLA_LIBS}
SHARED_LIBS +=	${_lib}	${SO_VERSION}
.endfor

RUN_DEPENDS +=		devel/desktop-file-utils
BUILD_DEPENDS +=	archivers/gtar	\
			archivers/unzip \
			archivers/zip>=2.3

LIB_DEPENDS +=		textproc/hunspell \
			devel/nspr>=4.10.8 \
			security/nss>=3.17.4

# bug #736961
SEPARATE_BUILD =	Yes

# needed for webm
.if ${MACHINE_ARCH:Mi386} || ${MACHINE_ARCH:Mamd64}
BUILD_DEPENDS +=	devel/yasm
.endif

WANTLIB +=		X11 Xext Xrender Xt atk-1.0 c cairo 		\
			fontconfig freetype gdk_pixbuf-2.0 gio-2.0 glib-2.0 \
			gobject-2.0 gthread-2.0 m 			\
			nspr4 nss3 pango-1.0 pangocairo-1.0 pangoft2-1.0 \
			plc4 plds4 pthread event kvm sqlite3>=29 	\
			smime3 sndio nssutil3 ssl3 stdc++ z hunspell-1.3

# hack to build against systemwide sqlite3 (# 546162)
CONFIGURE_ENV +=	ac_cv_sqlite_secure_delete=yes

# --no-keep-memory avoids OOM when linking libxul
# --relax avoids relocation overflow on ppc, needed since sm 2.7b, tb 10.0b,
# fx 15.0b
.if ${MACHINE_ARCH} == "powerpc"
CONFIGURE_ENV +=	LDFLAGS="-Wl,--no-keep-memory -Wl,--relax"
.else
CONFIGURE_ENV +=	LDFLAGS="-Wl,--no-keep-memory"
.endif

USE_GMAKE ?=	Yes

# no --with-system-jpeg starting with fx 18, requires libjpeg-turbo
#    because of bug 791305
# no --with-system-cairo, too much gfx problems because of version mismatch
# no --with-system-ffi, needs 3.0.10 when not using gcc
# no --with-system-png, apng support not bundled in

AUTOCONF_VERSION =	2.13
CONFIGURE_ARGS +=	--with-system-zlib=/usr		\
			--with-system-libevent=/usr/	\
			--with-system-bz2=${LOCALBASE}	\
			--with-system-nspr		\
			--with-system-nss		\
			--enable-system-hunspell	\
			--enable-system-sqlite		\
			--enable-official-branding	\
			--enable-gio			\
			--disable-gconf			\
			--disable-necko-wifi		\
			--disable-optimize		\
			--disable-tests			\
			--disable-updater		\
			--disable-dbus

## N.B. The debug flavor does not work: build dies (sorry, don't
## have error handy, must investigate).

FLAVORS +=		debug gtk3
FLAVOR ?=

.if ${FLAVOR:Mdebug}
CONFIGURE_ARGS +=	--enable-debug \
			--enable-profiling \
			--enable-debug-symbols=yes \
			--disable-install-strip
INSTALL_STRIP =
.endif

.if ${FLAVOR:Mgtk3}
# https://bugzilla.mozilla.org/show_bug.cgi?id=983843
CONFIGURE_ARGS +=	--with-system-cairo
CONFIGURE_ARGS +=	--enable-default-toolkit=cairo-gtk3
LIB_DEPENDS +=	x11/gtk+3
WANTLIB +=	cairo-gobject gdk-3 gtk-3 pixman-1 pthread-stubs
.else
LIB_DEPENDS +=	x11/gtk+2
WANTLIB +=	Xcomposite Xcursor Xdamage Xfixes Xi Xinerama \
		Xrandr gdk-x11-2.0 gtk-x11-2.0
.endif

PORTHOME =	${WRKSRC}

# from browser/config/mozconfig
CONFIGURE_ARGS +=--enable-application=browser

MAKE_ENV +=	MOZILLA_OFFICIAL=1 \
		SHELL=/bin/sh \
		SO_VERSION="${SO_VERSION}"

CONFIGURE_ENV +=	${MAKE_ENV}

pre-configure:
.for d in ${OUR_AUTOCONF_DIRS}
	cd ${WRKSRC}/${d} && ${SETENV} ${AUTOCONF_ENV} ${AUTOCONF}
.endfor
## <<< End of mozilla.port.mk-derived stuff.
## I had done this in post-extract but I guess pre-configure makes
## slightly more sense.
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
	# install prefs
	${INSTALL_DATA_DIR} \
	  ${PREFIX}/lib/${PKGNAME}/browser/defaults/preferences
	${SUBST_DATA} ${FILESDIR}/all-openbsd.js \
	  ${PREFIX}/lib/${PKGNAME}/browser/defaults/preferences/all-openbsd.js
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
	ln \
	 ${PREFIX}/lib/${PKGNAME}/browser/chrome/icons/default/default{48,}.png

.include <bsd.port.mk>
