import 'dart:io';

import 'package:flutter/material.dart';
import 'package:super_context_menu/super_context_menu.dart';

class CustomContextMenuWidget extends ContextMenuWidget {
  CustomContextMenuWidget({
    super.key,
    required super.child,
    required super.menuProvider,
    super.liftBuilder,
  });

  @override
  Widget build(BuildContext context) {
    //
    //  Why is this only being used for Desktop and iOS devices?
    //
    //    Well, super_context_menu, the package being used is absolute garbage
    //    when any customization is required. It is possible to define a custom
    //    theme that fits this application, but it requires overriding private
    //    classes that will inevitably change in a package update. Long story
    //    short, I have chosen to just use another package for anything that
    //    needs to be customized because the native context menu's are ugly.
    //

    if (Platform.isIOS ||
        Platform.isMacOS ||
        Platform.isWindows ||
        Platform.isLinux) {
      return super.build(context);
    }
    return SizedBox(
      child: child,
    );
  }
}
