DESCRIPTION = "A console URL download utility featuring HTTP, FTP, and more."
LICENSE = "GPLv3"

RECIPE_TYPES = "machine native"

DEPENDS_LIBC = "librt"
DEPENDS_LIBC:HOST_LIBC_mingw = ""
DEPENDS = "${DEPENDS_LIBC} native:flex"

inherit autotools gettext

#Only used for Aarch64
AUTOCONFDIRS = "/build-aux"

require conf/fetch/gnu.conf
SRC_URI = "${GNU_MIRROR}/wget/wget-${PV}.tar.gz"

RECIPE_FLAGS += "wget_ipv6"
EXTRA_OECONF:>wget_ipv6 = " --enable-ipv6"

RECIPE_FLAGS += "wget_ssl"
EXTRA_OECONF_SSL = "--without-ssl"
EXTRA_OECONF_SSL:USE_wget_ssl = "--with-ssl=${USE_wget_ssl}"
EXTRA_OECONF += "${EXTRA_OECONF_SSL}"

PROVIDES_${PN} = "util/wget"

RDEPENDS_${PN} = "librt libgcc"
