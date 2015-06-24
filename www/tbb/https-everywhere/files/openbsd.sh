#!/bin/sh
#
# OpenBSD (but really just POSIX-compliant) build script for the
# https-everywhere port.
#
# B-Deps: textproc/libxml, textproc/py-lxml, archivers/zip

# Preliminaries

set -e

APP_NAME=https-everywhere
RULESETS_SQLITE="`pwd`/src/defaults/rulesets.sqlite"
GRAMMAR="utils/relaxng.xml"
PYTHON=${PYTHON-python2.7}
VERS=`grep em:version src/install.rdf | perl -lpe 's/^\s*<em:version>([0-9.a-zA-Z]+)<\/em:version>/$1/'`
XPI_NAME="$APP_NAME-$VERS"

echo "$APP_NAME version $VERS"

die() {
    echo >&2 "ERROR:" "$@"
    exit 1
}
validate_grammar() {
    find src/chrome/content/rules -name "*.xml" | \
	xargs xmllint --noout --relaxng utils/relaxng.xml
}

# Create sqlite database
[ -d pkg ] || mkdir pkg
echo "Generating sqlite DB"
$PYTHON ./utils/make-sqlite.py
[ ! -f $RULESETS_SQLITE ] && die "make-sqlite.py failed"

if $PYTHON ./utils/trivial-validate.py --quiet --db $RULESETS_SQLITE >&2
then
  echo Validation of included rulesets completed. >&2
  echo >&2
else
  die "Validation of rulesets failed."
fi

# Validate it
if validate_grammar 2>/dev/null
then
    echo Validation of rulesets against $GRAMMAR succeeded. >&2
else
    validate_grammar 2>&1 | grep -v validates
    die "Validation of rulesets against $GRAMMAR failed."
fi
if sh ./utils/compare-locales.sh >&2
then
    echo Validation of included locales completed. >&2
else
    die "Validation of locales failed."
fi

# Create the XPI
[ -e tmp ] && rm -rf tmp
mkdir tmp
(cd src; tar cf - .) | (cd tmp; tar xf -)
rm -rf tmp/chrome/content/rules
rm -f "${XPI_NAME}.xpi"
cd tmp
zip -q -X -9r "../pkg/${XPI_NAME}.xpi" . "-x@../.build_exclusions"
cd ..

# Summarize
echo >&2 "Total included rules: `sqlite3 $RULESETS_SQLITE 'select count(*) from rulesets'`"
echo >&2 "Rules disabled by default: `find src/chrome/content/rules -name "*.xml" | xargs grep -F default_off | wc -l`"
echo >&2 "Created ${XPI_NAME}.xpi"
rm -rf tmp
