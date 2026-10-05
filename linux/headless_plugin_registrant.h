#ifndef HEADLESS_PLUGIN_REGISTRANT_
#define HEADLESS_PLUGIN_REGISTRANT_

#include <flutter_linux/flutter_linux.h>

// Registers plugins that can run without a GTK/Flutter view.
void fl_register_headless_plugins(FlPluginRegistry* registry);

#endif  // HEADLESS_PLUGIN_REGISTRANT_
