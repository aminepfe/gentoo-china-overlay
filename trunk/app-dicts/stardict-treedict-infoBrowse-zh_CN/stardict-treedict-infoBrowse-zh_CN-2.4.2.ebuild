# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

FROM_LANG="Simplified Chinese (GB)"
TO_LANG="Simplified Chinese (GB)"
DICT_SUFFIX="treedict-infoBrowse-zh_CN"

inherit stardict-treedict

HOMEPAGE="http://stardict.sourceforge.net/Dictionaries_Quick.php"

KEYWORDS="~x86 ~ppc ~sparc"
IUSE=""

RDEPEND=">=app-dicts/stardict-2.4.2"
