MODULE_NAME := pippo
SRC_C := $(MODULE_NAME).c
KERNEL_BUILD := /lib/modules/$(shell uname -r)/build/

obj-m = $(MODULE_NAME).o

$(info $$MODULE_NAME is [${MODULE_NAME}])
$(info $$SRC_c is [${SRC_C}])
$(info $$KERNEL_BUILD is [${KERNEL_BUILD}])
$(info $$obj-m is [${obj-m}])

all: from_btf.h
	make -C /lib/modules/$(shell uname -r)/build/ M=$(PWD) modules

vmlinux:
	$(KERNEL_BUILD)/scripts/extract-vmlinux /boot/vmlinuz-$(shell uname -r) >vmlinux

from_btf.h: vmlinux
	./make_btf_include.sh $(SRC_C) >>from_btf.h

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
	rm -f from_btf.h vmlinux

