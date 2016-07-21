#include "collectd.h"
#include "common.h"
#include "plugin.h"
#include "configfile.h"
#include "utils_mount.h"
#include "utils_ignorelist.h"

int i = 0;

static int aeu_read (void)
{
	i += 1;
	INFO ("aeu ping %d", i);
	value_t values[1];
	value_list_t vl = VALUE_LIST_INIT;

	values[0].counter = (counter_t)i;

	vl.values = values;
	vl.values_len = 1;
	sstrncpy (vl.host, hostname_g, sizeof (vl.host));
	sstrncpy (vl.plugin, "aeu", sizeof (vl.plugin));
	sstrncpy (vl.type, "counter", sizeof (vl.type));
    sstrncpy (vl.type_instance, "ping", sizeof (vl.type_instance));

	plugin_dispatch_values (&vl);
	return 0;
} /* int aeu_read */

void module_register (void)
{
	plugin_register_read ("aeu", aeu_read);
} /* void module_register */
