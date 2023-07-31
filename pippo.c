#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/signal_types.h>
#include <asm/signal.h>
#include "from_btf.h"

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Pippo");

static int __init pippo_init(void)
{
	struct xattr_ctx pippo; //BTF_INCLUDE

	memset(&pippo, 0, sizeof(struct xattr_ctx) );
	pippo.size=5;

	printk(KERN_INFO "pippo[%lud] wants to use an non public data structure\n", pippo.size);
	return 0;
}

static void __exit pippo_exit(void)
{
	printk(KERN_INFO "Unloading Pippo\n");
}

module_init(pippo_init);
module_exit(pippo_exit);
