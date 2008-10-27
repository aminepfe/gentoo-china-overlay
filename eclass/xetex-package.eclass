# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/xetex-package.eclass,v 1.33 2008/02/17 19:03:07 aballier Exp $

# @ECLASS: xetex-package.eclass
# @MAINTAINER:
# TeX team <tex@gentoo.org>
# 
# Author Matthew Turk <satai@gentoo.org>
# Martin Ehmsen <ehmsen@gentoo.org>
# @BLURB: An eclass for easy installation of LaTeX packages
# @DESCRIPTION:
# This eClass is designed to be easy to use and implement.  The vast majority of
# LaTeX packages will only need to define SRC_URI (and sometimes S) for a
# successful installation.  If fonts need to be installed, then the variable
# SUPPLIER must also be defined.
#
# However, those packages that contain subdirectories must process each
# subdirectory individually.  For example, a package that contains directories
# DIR1 and DIR2 must call xetex-package_src_compile() and
# xetex-package_src_install() in each directory, as shown here:
#
# src_compile() {
#    cd ${S}
#    cd DIR1
#    xetex-package_src_compile
#    cd ..
#    cd DIR2
#    xetex-package_src_compile
# }
#
# src_install() {
#    cd ${S}
#    cd DIR1
#    xetex-package_src_install
#    cd ..
#    cd DIR2
#    xetex-package_src_install
# }
#
# The eClass automatically takes care of rehashing TeX's cache (ls-lR) after
# installation and after removal, as well as creating final documentation from
# TeX files that come with the source.  Note that we break TeX layout standards
# by placing documentation in /usr/share/doc/${PN}
#
# For examples of basic installations, check out dev-tex/aastex and
# dev-tex/leaflet .
#
# NOTE: The CTAN "directory grab" function creates files with different MD5
# signatures EVERY TIME.  For this reason, if you are grabbing from the CTAN,
# you must either grab each file individually, or find a place to mirror an
# archive of them.  (iBiblio)
#

# Use EAPI2 to make USE dependency easy to specify
EAPI="2"

# It inherits base.
inherit base

RDEPEND="|| (
				>=app-text/texlive-2008[xetex]
				>=app-text/xetex-0.997
		)"
DEPEND="${RDEPEND}
		>=sys-apps/texinfo-4.2-r5"
HOMEPAGE="http://www.tug.org/"
SRC_URI="ftp://tug.ctan.org/macros/xetex/"
S=${WORKDIR}/${P}
TEXMF="/usr/share/texmf"

# @ECLASS-VARIABLE: SUPPLIER
# @DESCRIPTION:
# This refers to the font supplier; it should be overridden (see eclass
# DESCRIPTION above)
SUPPLIER="misc" 

# @FUNCTION: xetex-package_has_tetex3
# @RETURN: true if at least one of (>=tetex-3 or >=ptex-3.1.8 or >=texlive-core-2007) is installed, else false
# @DESCRIPTION:
# It is often used to know if the current TeX installation supports gentoo's
# texmf-update or if the package has to do it the old way
xetex-package_has_tetex_3() {
	if has_version '>=app-text/tetex-3' || has_version '>=app-text/ptex-3.1.8' || has_version '>=app-text/texlive-core-2007' ; then
		true
	else
		false
	fi
}

# @FUNCTION: xetex-package_src_doinstall
# @USAGE: [ module ]
# @DESCRIPTION:
# [module] can be one or more of: sh, sty, cls, fd, clo, def, cfg, dvi, ps, pdf,
# tex, dtx, tfm, vf, afm, pfb, ttf, bst, styles, doc, fonts, bin, or all.
# If [module] is not given, all is assumed.
# It installs the files found in the current directory to the standard locations
# for a TeX installation
xetex-package_src_doinstall() {
	debug-print function $FUNCNAME $*
	# This actually follows the directions for a "single-user" system
	# at http://www.ctan.org/installationadvice/ modified for gentoo.
	[ -z "$1" ] && xetex-package_src_install all

	while [ "$1" ]; do
		case $1 in
			"sh")
				for i in `find . -maxdepth 1 -type f -name "*.${1}"`
				do
					dobin $i || die "dobin $i failed"
				done
				;;
			"sty" | "cls" | "fd" | "clo" | "def" | "cfg")
				for i in `find . -maxdepth 1 -type f -name "*.${1}"`
				do
					insinto ${TEXMF}/tex/xetex/${PN}
					doins $i || die "doins $i failed"
				done
				;;
			"dvi" | "ps" | "pdf")
				for i in `find . -maxdepth 1 -type f -name "*.${1}"`
				do
					insinto /usr/share/doc/${P}
					doins $i || "doins $i failed"
					#dodoc -u $i
				done
				;;
			"tex" | "dtx")
				for i in `find . -maxdepth 1 -type f -name "*.${1}"`
				do
					einfo "Making documentation: $i"
					texi2dvi -q -c --language=xetex $i &> /dev/null
					done
				;;
			"tfm" | "vf" | "afm")
				for i in `find . -maxdepth 1 -type f -name "*.${1}"`
				do
					insinto ${TEXMF}/fonts/${1}/${SUPPLIER}/${PN}
					doins $i || die "doins $i failed"
				done
				;;
			"pfb")
				for i in `find . -maxdepth 1 -type f -name "*.pfb"`
				do
					insinto ${TEXMF}/fonts/type1/${SUPPLIER}/${PN}
					doins $i || die "doins $i failed"
				done
				;;
			"ttf")
				for i in `find . -maxdepth 1 -type f -name "*.ttf"`
				do
					insinto ${TEXMF}/fonts/truetype/${SUPPLIER}/${PN}
					doins $i || die "doins $i failed"
				done
				;;
			"bst")
				for i in `find . -maxdepth 1 -type f -name "*.bst"`
				do
					insinto ${TEXMF}/bibtex/bst/${PN}
					doins $i || die "doins $i failed"
				done
				;;
			"styles")
				xetex-package_src_doinstall sty cls fd clo def cfg bst
				;;
			"doc")
				xetex-package_src_doinstall tex dtx dvi ps pdf
				;;
			"fonts")
				xetex-package_src_doinstall tfm vf afm pfb ttf
				;;
			"bin")
				xetex-package_src_doinstall sh
				;;
			"all")
				xetex-package_src_doinstall styles fonts bin doc
				;;
		esac
	shift
	done
}

# @FUNCTION: xetex-package_src_compile
# @DESCRIPTION:
# Calls xetex for each *.ins in the current directory in order to generate the
# relevant files that will be installed
xetex-package_src_compile() {
	debug-print function $FUNCNAME $*
	for i in `find \`pwd\` -maxdepth 1 -type f -name "*.ins"`
	do
		einfo "Extracting from $i"
		xetex --interaction=batchmode $i &> /dev/null
	done
}

# @FUNCTION: xetex-package_src_install
# @DESCRIPTION:
# Installs the package
xetex-package_src_install() {
	debug-print function $FUNCNAME $*
	xetex-package_src_doinstall all
	if [ -n "${DOCS}" ] ; then
		dodoc ${DOCS}
	fi
}

# @FUNCTION: xetex-pacakge_pkg_postinst
# @DESCRIPTION:
# Calls xetex-package_rehash to ensure the TeX installation is consistent with
# the kpathsea database
xetex-package_pkg_postinst() {
	debug-print function $FUNCNAME $*
	xetex-package_rehash
}

# @FUNCTION: xetex-package_pkg_postrm
# @DESCRIPTION:
# Calls xetex-package_rehash to ensure the TeX installation is consistent with
# the kpathsea database
xetex-package_pkg_postrm() {
	debug-print function $FUNCNAME $*
	xetex-package_rehash
}

# @FUNCTION: xetex-package_rehash
# @DESCRIPTION:
# Rehashes the kpathsea database, according to the current TeX installation
xetex-package_rehash() {
	debug-print function $FUNCNAME $*
	if xetex-package_has_tetex_3 ; then
		texmf-update
	else
		texconfig rehash
	fi
}

EXPORT_FUNCTIONS src_compile src_install pkg_postinst pkg_postrm
