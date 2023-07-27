#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include "from_btf.h"

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Pippo");

static int __init hello_init(void)
{
	struct task_struct *thread; //BTF_INCLUDE


	printk(KERN_INFO "pippo[%d] wants to use an non public data structure\n", thread->pid);
	return 0;
}

static void __exit hello_exit(void)
{
	printk(KERN_INFO "Unloading Pippo\n");
}

module_init(hello_init);
module_exit(hello_exit);
