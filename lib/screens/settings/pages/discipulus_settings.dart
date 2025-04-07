import 'dart:io';

import 'package:discipulus/api/models/permissions.dart';
import 'package:discipulus/core/routes.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/models/account_extension.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/introduction/vertical_intro.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/avatars.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:discipulus/widgets/global/tiles/loading_button.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:url_launcher/url_launcher.dart';

class DiscipulusSettingsPage extends StatefulWidget {
  const DiscipulusSettingsPage({super.key});

  @override
  State<DiscipulusSettingsPage> createState() => _DiscipulusSettingsPageState();
}

class _DiscipulusSettingsPageState extends State<DiscipulusSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Discipulus instellingen"),
      ),
      children: [
        //
        //  Vormgeving
        //
        const ListTitle(child: Text("Thema")),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: CustomCard(
            child: ListTile(
                leading: Icon(Icons.format_color_fill),
                subtitle: PersonalColorSetting()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SegmentedButton<ThemeBrightness>(
            showSelectedIcon: true,
            emptySelectionAllowed: false,
            multiSelectionEnabled: false,
            onSelectionChanged: (set) async {
              setState(() {
                appSettings
                  ..brightness = set.first
                  ..save();
              });
              await MainApp.of(context).updateTheme();
            },
            segments: [
              ...ThemeBrightness.values.map(
                (e) => ButtonSegment(
                  value: e,
                  label: Text(
                    e.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  icon: e.icon,
                ),
              )
            ],
            selected: {appSettings.brightness},
          ),
        ),
        const ThemeVariantWidget(),

        //
        //  Vormgeving
        //
        const ListTitle(child: Text("Vormgeving")),
        if (Platform.isAndroid)
          SwitchListTile(
            value: appSettings.drawerOnBack,
            secondary: const Icon(Icons.arrow_back),
            title: const Text("Open zijbalk bij terugknop"),
            subtitle: const Text(
                "Wanneer dit aan staat kan je met de terug knop de zijbalk openen"),
            onChanged: (value) {
              setState(() {
                appSettings
                  ..drawerOnBack = value
                  ..save();
                Layout.of(context)?.update();
              });
            },
          ),
        SwitchListTile(
          value: appSettings.drawerOpenOnRight,
          secondary: const Icon(Icons.swipe_left),
          title: const Text("Open zijbalk aan rechterkant"),
          subtitle: const Text("Open de zijbalk aan de rechter kant"),
          onChanged: (value) {
            setState(() {
              appSettings
                ..drawerOpenOnRight = value
                ..save();
              Layout.of(context)?.update();
            });
          },
        ),
        ListTile(
          title: const Text("Startpagina"),
          leading: const Icon(Icons.brightness_auto),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Deze pagina zal openen wanneer de app wordt geopend"),
              Align(
                alignment: Alignment.centerRight,
                child: DropdownButton<int>(
                  value: activeProfile.settings.startingPageIndex,
                  onChanged: (value) async {
                    setState(() {
                      activeProfile
                        ..settings.startingPageIndex = value!
                        ..save();
                    });
                    await MainApp.of(context).updateTheme();
                  },
                  items: destinations(activeProfile.account.value!.permissions)
                      .expand(
                        (element) => element.destinations,
                      )
                      .indexed
                      .map(
                        (e) => DropdownMenuItem(
                            value: e.$1, child: Text(e.$2.label)),
                      )
                      .toList() as List<DropdownMenuItem<int>>?,
                ),
              ),
            ],
          ),
        ),
        //
        //  AI
        //
        const ListTitle(child: Text("Kunstmatige intelligentie")),
        ListTile(
          leading: const Icon(Icons.auto_awesome),
          title: const Text("Gemini API key"),
          subtitle: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              hintText: appSettings.geminiAPIKey,
            ),
            onChanged: (value) => appSettings
              ..geminiAPIKey = value.nullOnEmpty
              ..save(),
          ),
        ),
        ListTile(
          dense: true,
          leading: const Icon(Icons.open_in_browser),
          title: const Text("Krijg een API-key"),
          onTap: () =>
              launchUrl(Uri.parse("https://aistudio.google.com/apikey")),
        ),
        SwitchListTile(
            value: appSettings.sharePersonalInformationWithGemini,
            onChanged: appSettings.geminiAPIKey != null
                ? (value) => setState(() {
                      appSettings
                        ..sharePersonalInformationWithGemini = value
                        ..save();
                    })
                : null,
            secondary: const Icon(Icons.lock),
            title: const Text("Deel persoonlijke informatie"),
            subtitle: const Text(
                "Wanneer dit aan staat zullen dingen zoals je naam en klas worden gebruikt bij het gebruik van AI")),
        //
        //  Profiles
        //
        const ListTitle(child: Text("Accounts")),
        for (DiscipulusAccount account
            in isar.discipulusAccounts.where().findAllSync())
          CustomCard(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      for (Profile profile in account.profiles)
                        ListTile(
                          leading: ProfilePicture(
                              base64ProfilePicture:
                                  profile.base64ProfilePicture),
                          title: Text(profile.name),
                          subtitle: Text(
                            account.permissions
                                    .hasPermissions(PermissionType.kinderen)
                                ? "Ouder account"
                                : "Direct account",
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: LoadingButton(
                    future: () async {
                      // Remove account
                      await account.logoutAndRemoveAllData();
                      if (await isar.profiles.where().count() == 0) {
                        // No account left, returning to main menu
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) =>
                              const VerticalIntroductionScreen(),
                        ));
                      }
                      if (mounted) setState(() {});
                    },
                    child: (isLoading, onTap) => IconButton(
                      key: ValueKey(isLoading),
                      onPressed: isLoading ? null : onTap,
                      icon: isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            )
                          : Icon(
                              Icons.logout,
                              color: Theme.of(context).colorScheme.error,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}

class ThemeVariantWidget extends StatefulWidget {
  const ThemeVariantWidget({super.key});

  @override
  State<ThemeVariantWidget> createState() => _ThemeVariantWidgetState();
}

class _ThemeVariantWidgetState extends State<ThemeVariantWidget> {
  Map<ThemeVariant, ColorScheme?> schemes = {};
  late Color? accentColor;
  late Color seedColor =
      (appSettings.useMaterialYou ?? true) && accentColor != null
          ? accentColor!
          : Color(appSettings.activeMaterialYouColorInt);

  Future<void> setSchemes() async {
    accentColor = await DynamicColorPlugin.getAccentColor();

    schemes = {
      for (ThemeVariant variant in ThemeVariant.values)
        variant: variant.variant != null
            ? ColorScheme.fromSeed(
                seedColor: seedColor,
                dynamicSchemeVariant: variant.variant!,
                brightness: Theme.of(context).brightness,
              )
            : accentColor != seedColor && accentColor != null
                ? ColorScheme.fromSeed(
                    seedColor: accentColor!,
                    brightness: Theme.of(context).brightness,
                  )
                : null,
    };

    setState(() {});
  }

  @override
  void initState() {
    setSchemes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            for (MapEntry<ThemeVariant, ColorScheme?> entry
                in schemes.entries.nonNulls) ...[
              Card.outlined(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      appSettings
                        ..themeVariant = entry.key
                        ..save();
                    });
                    MainApp.of(context).updateTheme();
                    setSchemes();
                  },
                  child: SizedBox(
                    height: 150,
                    width: 50,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (entry.value != null)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for (Color color in [
                                entry.value!.primary,
                                entry.value!.primaryContainer,
                                entry.value!.tertiary,
                                entry.value!.tertiaryContainer,
                                entry.value!.secondary
                              ])
                                Expanded(
                                  child: Container(
                                    color: color,
                                  ),
                                )
                            ],
                          ),
                        if (entry.key == appSettings.themeVariant &&
                            entry.value != null)
                          Icon(
                            Icons.check_circle,
                            color:
                                (entry.value ?? Theme.of(context).colorScheme)
                                    .onTertiary,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class PersonalColorSetting extends StatefulWidget {
  const PersonalColorSetting({super.key});

  @override
  State<PersonalColorSetting> createState() => _PersonalColorSettingState();
}

class _PersonalColorSettingState extends State<PersonalColorSetting> {
  bool hasDynamicColoring = Platform.isAndroid;
  final Map<String, Color> material3Colors = {
    'Red': const Color(0xFFE57373),
    'Orange': const Color(0xFFFF8A65),
    'Yellow': const Color(0xFFFFD54F),
    'Green': const Color(0xFF81C784),
    'Light Blue': const Color(0xFF4FC3F7),
    'Indigo': const Color(0xFF7986CB),
    'Purple': const Color(0xFFBA68C8),
    'Pink': const Color(0xFFF06292),
    'Teal': const Color(0xFF4DB6AC),
  };

  @override
  void initState() {
    super.initState();
    Future(() async {
      // Check for material you or system accent colors
      hasDynamicColoring =
          ((await DynamicColorPlugin.getCorePalette()) != null ||
              await DynamicColorPlugin.getAccentColor() != null);

      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...material3Colors.values.map(
          (value) => IconButton(
            icon: const Icon(Icons.radio_button_unchecked),
            color: value,
            isSelected: appSettings.activeMaterialYouColorInt == value.value &&
                !(appSettings.useMaterialYou ?? false),
            selectedIcon: const Icon(Icons.circle),
            onPressed: () async {
              setState(() => appSettings
                ..useMaterialYou = false
                ..activeMaterialYouColorInt = value.value
                ..save());
              await MainApp.of(context).updateTheme();
            },
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 24,
              child: VerticalDivider(),
            ),
            IconButton(
              isSelected: !material3Colors.values
                      .contains(appSettings.activeMaterialYouColorInt) &&
                  !(appSettings.useMaterialYou ?? false),
              selectedIcon: const Icon(Icons.image),
              icon: const Icon(Icons.image_outlined),
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.image,
                );
                ColorScheme colorScheme = await ColorScheme.fromImageProvider(
                  dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
                  provider: ResizeImage(FileImage(File(result!.paths.first!)),
                      height: 10, width: 10),
                  brightness: Theme.of(context).brightness,
                );
                setState(() => appSettings
                  ..useMaterialYou = false
                  ..activeMaterialYouColorInt = colorScheme.primary.value
                  ..save());
                await MainApp.of(context).updateTheme();
              },
            ),
            if (hasDynamicColoring)
              IconButton(
                icon: const Icon(Icons.star_outline_rounded),
                isSelected: appSettings.useMaterialYou,
                selectedIcon: const Icon(Icons.star_rounded),
                onPressed: () async {
                  setState(() => appSettings
                    ..useMaterialYou = !(appSettings.useMaterialYou ?? true)
                    ..save());
                  await MainApp.of(context).updateTheme();
                },
              ),
          ],
        )
      ],
    );
  }
}
