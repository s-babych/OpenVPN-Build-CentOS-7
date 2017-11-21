VERSION 	= 2.4.4
SOURCE  	= openvpn-${VERSION}
TARBALL 	= ${SOURCE}.tar.gz
URL		= https://swupdate.openvpn.org/community/releases/${TARBALL}

# yum -y install gcc
# yum -y install openssl-devel
# yum -y install lzo-devel
# yum -y install pam-devel
# yum -y install patch

usage:
	@echo 'make [all|clean|clean-all]'

all: ${TARBALL} ${SOURCE}
	@:

clean:
	rm -rf ${SOURCE}

clean-all: clean
	rm  -f ${TARBALL}

${TARBALL}:
	wget ${URL}

CONFIGURE	:= cd ${SOURCE} && ./configure
CONFIGURE	+= --prefix=$$(pwd)/../root
CONFIGURE	+= --includedir=/usr/include
CONFIGURE	+= --libdir=/usr/lib64
CONFIGURE	+= --sbindir=/usr/sbin
CONFIGURE	+= --docdir=/usr/share/doc/openvpn-${VERSION}
CONFIGURE	+= --mandir=/usr/share/man

${SOURCE}:
	tar -zxf ${TARBALL}
	patch -p0 < openvpn-2.4.4-multihome_envvars.patch
	${CONFIGURE}