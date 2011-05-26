# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

TAR_SUFFIX=tar.gz

inherit googlecode

DESCRIPTION="A GTK+ front-end for the SopCast P2P TV player"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""


S=${WORKDIR}/${PN}

RDEPEND="dev-python/pygtk
	dev-python/pygobject
	media-tv/sopcast-bin
	=media-video/vlc-1.1*
	sys-devel/gettext"

DEPEND="${REPEND}
	dev-lang/python[sqlite]"

src_install() {
	emake DESTDIR=${D} install \
	|| die "emake install failed"
	dosym /usr/bin/sopcast-bin /usr/bin/sp-sc
}
