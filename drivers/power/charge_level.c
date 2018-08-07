/*
 * Author: andip71, 07.08.2018
 *
 * Version 1.3
 *
 * This software is licensed under the terms of the GNU General Public
 * License version 2, as published by the Free Software Foundation, and
 * may be copied, distributed, and modified under those terms.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */


#include <linux/module.h>
#include <linux/kobject.h>
#include <linux/sysfs.h>
#include <linux/power_supply.h>

/* variables */
extern int bc_enable_usb_fastcharge;


/* imported function prototypes */
int get_bk_current_now (void);
int get_bk_charger_type (void);


/* sysfs interface */
static ssize_t charge_info_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
{
	char charge_info_text[30];
	int charger_type;

	// get charger type
	charger_type = get_bk_charger_type();

	// check connected charger type
	switch (charger_type)
	{
		case POWER_SUPPLY_TYPE_UNKNOWN:
		case POWER_SUPPLY_TYPE_USB_PD:
			sprintf(charge_info_text, "No charger");
			break;

		case POWER_SUPPLY_TYPE_USB_DCP:
			sprintf(charge_info_text, "~%d mA (AC charger)", get_bk_current_now());
			break;

		case POWER_SUPPLY_TYPE_USB:
			sprintf(charge_info_text, "~%d mA (USB charger)", get_bk_current_now());
			break;

		case POWER_SUPPLY_TYPE_DASH:
			sprintf(charge_info_text, "~%d mA (Dash charging)", get_bk_current_now());
			break;

		default:
			sprintf(charge_info_text, "~%d mA (unknown charger: %d)", get_bk_current_now(), charger_type);
			break;
	}

	// return info text
	return sprintf(buf, charge_info_text);
}


static ssize_t enable_usb_fastcharge_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
{
	// return setting
	return sprintf(buf, "%d", bc_enable_usb_fastcharge);
}


static ssize_t enable_usb_fastcharge_store(struct kobject *kobj, struct kobj_attribute *attr, const char *buf, size_t count)
{
	unsigned int ret = -EINVAL;
	int val;

	// read value from input buffer
	ret = sscanf(buf, "%d", &val);

	if (ret != 1)
		return -EINVAL;

	// value of 1 enables usb fast charging; everything else disables it
	if (val == 1)
		bc_enable_usb_fastcharge = 1;
	else
		bc_enable_usb_fastcharge = 0;

	return count;
}

/* Initialize charge level sysfs folder */

static struct kobj_attribute charge_info_attribute =
__ATTR(charge_info, 0664, charge_info_show, NULL);

static struct kobj_attribute enable_usb_fastcharge_attribute =
__ATTR(enable_usb_fastcharge, 0664, enable_usb_fastcharge_show, enable_usb_fastcharge_store);

static struct attribute *charge_level_attrs[] = {
&charge_info_attribute.attr,
&enable_usb_fastcharge_attribute.attr,
NULL,
};

static struct attribute_group charge_level_attr_group = {
.attrs = charge_level_attrs,
};

static struct kobject *charge_level_kobj;


int charge_level_init(void)
{
	int charge_level_retval;

    charge_level_kobj = kobject_create_and_add("charge_levels", kernel_kobj);

    if (!charge_level_kobj)
	{
		printk("Boeffla-Kernel: failed to create kernel object for charge level interface.\n");
                return -ENOMEM;
        }

        charge_level_retval = sysfs_create_group(charge_level_kobj, &charge_level_attr_group);

    if (charge_level_retval)
	{
		kobject_put(charge_level_kobj);
		printk("Boeffla-Kernel: failed to create fs object for charge level interface.\n");
	    return (charge_level_retval);
	}

	// print debug info
	printk("Boeffla-Kernel: charge level interface started.\n");

    return (charge_level_retval);
}


void charge_level_exit(void)
{
	kobject_put(charge_level_kobj);

	// print debug info
	printk("Boeffla-Kernel: charge level interface stopped.\n");
}


/* define driver entry points */
module_init(charge_level_init);
module_exit(charge_level_exit);
