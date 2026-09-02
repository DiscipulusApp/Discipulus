#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include "flutter/generated_plugin_registrant.h"

struct _MyApplication {
  GtkApplication parent_instance;
  char** dart_entrypoint_arguments;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

static GtkCssProvider* headerbar_css_provider = nullptr;

static void header_bar_method_call_cb(FlMethodChannel* channel,
                                      FlMethodCall* method_call,
                                      gpointer user_data) {
  const gchar* method = fl_method_call_get_name(method_call);
  if (g_strcmp0(method, "setHeaderBarColor") == 0) {
    FlValue* args = fl_method_call_get_args(method_call);
    if (args != nullptr && fl_value_get_type(args) == FL_VALUE_TYPE_MAP) {
      FlValue* bg_val = fl_value_lookup_string(args, "background");
      FlValue* fg_val = fl_value_lookup_string(args, "foreground");
      FlValue* border_val = fl_value_lookup_string(args, "border");

      if (bg_val != nullptr && fg_val != nullptr) {
        const gchar* bg = fl_value_get_string(bg_val);
        const gchar* fg = fl_value_get_string(fg_val);
        const gchar* border = border_val != nullptr ? fl_value_get_string(border_val) : "transparent";

        gchar* css = g_strdup_printf(
            "headerbar, .titlebar, headerbar.titlebar {\n"
            "  background: %s;\n"
            "  background-color: %s;\n"
            "  color: %s;\n"
            "  border-bottom: 1px solid %s;\n"
            "  box-shadow: none;\n"
            "}\n"
            "headerbar .title, headerbar .subtitle, headerbar label {\n"
            "  color: %s;\n"
            "}\n"
            "headerbar button.titlebutton, headerbar button {\n"
            "  color: %s;\n"
            "}\n",
            bg, bg, fg, border, fg, fg);

        if (headerbar_css_provider == nullptr) {
          headerbar_css_provider = gtk_css_provider_new();
          gtk_style_context_add_provider_for_screen(
              gdk_screen_get_default(),
              GTK_STYLE_PROVIDER(headerbar_css_provider),
              GTK_STYLE_PROVIDER_PRIORITY_APPLICATION);
        }

        gtk_css_provider_load_from_data(headerbar_css_provider, css, -1, nullptr);
        g_free(css);
      }
    }
    g_autoptr(FlMethodResponse) response = FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
    fl_method_call_respond(method_call, response, nullptr);
  } else {
    g_autoptr(FlMethodResponse) response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
    fl_method_call_respond(method_call, response, nullptr);
  }
}

// Implements GApplication::activate.
static void my_application_activate(GApplication* application) {
  MyApplication* self = MY_APPLICATION(application);
  GList* windows = gtk_application_get_windows(GTK_APPLICATION(application));
  if (windows) {
    gtk_window_present(GTK_WINDOW(windows->data));
    return;
  }
  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  // Use a header bar when running in GNOME as this is the common style used
  // by applications and is the setup most users will be using (e.g. Ubuntu / Fedora desktop).
  gboolean use_header_bar = TRUE;
#ifdef GDK_WINDOWING_X11
  GdkScreen* screen = gtk_window_get_screen(window);
  if (GDK_IS_X11_SCREEN(screen)) {
    const gchar* wm_name = gdk_x11_screen_get_window_manager_name(screen);
    if (g_strcmp0(wm_name, "GNOME Shell") != 0) {
      use_header_bar = FALSE;
    }
  }
#endif
  if (use_header_bar) {
    GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
    gtk_widget_show(GTK_WIDGET(header_bar));
    gtk_header_bar_set_title(header_bar, "Discipulus");
    gtk_header_bar_set_show_close_button(header_bar, TRUE);
    gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
  } else {
    gtk_window_set_title(window, "Discipulus");
  }

  gtk_window_set_default_size(window, 1280, 720);
  gtk_widget_show(GTK_WIDGET(window));

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(project, self->dart_entrypoint_arguments);

  FlView* view = fl_view_new(project);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  // Register header bar theming method channel
  FlEngine* engine = fl_view_get_engine(view);
  FlBinaryMessenger* messenger = fl_engine_get_binary_messenger(engine);
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel = fl_method_channel_new(
      messenger, "dev.harrydekat.discipulus/header_bar", FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(
      channel, header_bar_method_call_cb, nullptr, nullptr);

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

// Implements GApplication::local_command_line.
static gboolean my_application_local_command_line(GApplication* application, gchar*** arguments, int* exit_status) {
  MyApplication* self = MY_APPLICATION(application);
  // Strip out the first argument as it is the binary name.
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  g_autoptr(GError) error = nullptr;
  if (!g_application_register(application, nullptr, &error)) {
     g_warning("Failed to register: %s", error->message);
     *exit_status = 1;
     return TRUE;
  }

  g_application_activate(application);
  *exit_status = 0;

  return FALSE;
}

// Implements GObject::dispose.
static void my_application_dispose(GObject* object) {
  MyApplication* self = MY_APPLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

static void my_application_class_init(MyApplicationClass* klass) {
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
  G_APPLICATION_CLASS(klass)->local_command_line = my_application_local_command_line;
  G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

static void my_application_init(MyApplication* self) {}

MyApplication* my_application_new() {
  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID,
                                     "flags", G_APPLICATION_HANDLES_COMMAND_LINE | G_APPLICATION_HANDLES_OPEN,
                                     nullptr));
}
