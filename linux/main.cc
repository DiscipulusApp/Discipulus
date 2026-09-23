#include <stdlib.h>
#include "my_application.h"

int main(int argc, char** argv) {
  // Disable WebKitGTK hardware compositing and DMABUF renderer on Linux/Wayland/Mesa/NVIDIA
  // to get rid of a blank/white screen in WebKitGTK webview windows. 
  // This package is for now disabled due to another bug, but still, for the future.
  setenv("WEBKIT_DISABLE_COMPOSITING_MODE", "1", 1);
  setenv("WEBKIT_DISABLE_DMABUF_RENDERER", "1", 1);

  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}

