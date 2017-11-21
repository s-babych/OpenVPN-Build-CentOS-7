VERSION 	= 2.4.4
SOURCE  	= openvpn-${VERSION}
TARBALL 	= ${SOURCE}.tar.gz
URL		= https://swupdate.openvpn.org/community/releases/${TARBALL}

ESSENTIALS	= gcc openssl-devel lzo-devel pam-devel patch

usage:
	@echo 'make [build|install|clean|clean-all]'

build: essentials ${TARBALL} ${SOURCE}
	@:

install: build
	cd ${SOURCE} && make install

essentials: begin-check-essentials ${ESSENTIALS} end-check-essentials

begin-check-essentials:;@echo -n "Essenyials check:"

${ESSENTIALS}:
	@echo -n " $@"
	@if ! rpm -qa | grep -q "^$@-"; then		\
	   echo;					\
	   echo "Install $@";				\
	   yum -y -q install $@;			\
	   echo -n "Continue of essentials check";	\
	 fi

end-check-essentials:;@echo " Done"

CONFIGURE	:= ./configure
CONFIGURE	+= --prefix=$$(pwd)/../root
CONFIGURE	+= --includedir=/usr/include
CONFIGURE	+= --libdir=/usr/lib64
CONFIGURE	+= --sbindir=/usr/sbin
CONFIGURE	+= --docdir=/usr/share/doc/openvpn-${VERSION}
CONFIGURE	+= --mandir=/usr/share/man

${SOURCE}:
	tar -zxf ${TARBALL}
	patch -p0 < openvpn-2.4.4-multihome_envvars.patch
	@echo -n "Configure (see log: $$(pwd)/${SOURCE}/configure.log) ... "; \
	 cd ${SOURCE} && ${CONFIGURE} > configure.log
	@echo Done
	@echo -n "Compile (see log: $$(pwd)/${SOURCE}/make.log) ... "; \
	 cd ${SOURCE} && make > make.log 2>&1
	@echo Done

${TARBALL}:
	wget -q ${URL}

clean:
	rm -rf ${SOURCE}

clean-all: clean
	rm  -f ${TARBALL}
