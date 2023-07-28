MODULE_NAME := pippo
SRC_C := $(MODULE_NAME).c
KERNEL_BUILD_X := /lib/modules/$(shell uname -r)/build/

obj-m = $(MODULE_NAME).o

$(info $$MODULE_NAME is [${MODULE_NAME}])
$(info $$SRC_c is [${SRC_C}])
$(info $$KERNEL_BUILD_X is [${KERNEL_BUILD_X}])
$(info $$obj-m is [${obj-m}])

all: from_btf.h
	@echo build the module
	make -C /lib/modules/$(shell uname -r)/build/ M=$(PWD) modules


in_headers.db: $(KERNEL_BUILD_X)
	@echo produce a db with unions and struct defined in headers
	./extract_data.sh >in_headers.db

linuximage:
	@echo extract vmlinux
	$(KERNEL_BUILD_X)/scripts/extract-vmlinux /boot/vmlinuz-$(shell uname -r) >linuximage

from_btf.h: linuximage in_headers.db
	@echo producing headers from BTF
	./make_btf_include.sh $(SRC_C) >>from_btf.h

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
	rm -f from_btf.h linuximage in_headers.db
