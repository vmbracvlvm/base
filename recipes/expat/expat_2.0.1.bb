require expat.inc

PR_append = ".0"

SRC_URI += "file://autotools.patch;patch=1"

do_configure() {
	rm -f ${S}/conftools/libtool.m4
	touch ${S}/conftools/libtool.m4
	autotools_do_configure
}

do_install() {
	oe_runmake prefix="${D}${prefix}" \
		bindir="${D}${bindir}" \
		libdir="${D}${libdir}" \
		includedir="${D}${includedir}" \
		man1dir="${D}${mandir}/man1" \
		install
}
