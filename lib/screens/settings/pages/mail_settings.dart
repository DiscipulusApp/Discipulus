import 'package:discipulus/screens/settings/settings.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';

class MailSettingsPage extends StatefulWidget {
  const MailSettingsPage({super.key});

  @override
  State<MailSettingsPage> createState() => _MailSettingsPageState();
}

class _MailSettingsPageState extends State<MailSettingsPage> {
  late final TextEditingController headerController;
  late final TextEditingController footerController;

  @override
  void initState() {
    headerController = TextEditingController(
      text: activeProfile.settings.mailHeader,
    );
    footerController = TextEditingController(
      text: activeProfile.settings.mailFooter,
    );
    super.initState();
  }

  @override
  void dispose() {
    headerController.dispose();
    footerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Berichten instellingen"),
      ),
      children: [
        ProfileChangeWidget(
          updateState: (p0) => setState(() {}),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.paste),
          title: const Text("Automatische header/footer"),
          subtitle: const Text("Voeg de footer/header automatisch in."),
          value: activeProfile.settings.autoInsertHeaderAndFooter,
          onChanged: (value) {
            setState(() {
              activeProfile
                ..settings.autoInsertHeaderAndFooter = value
                ..save();
            });
          },
        ),
        CustomCard(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                CustomCard(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: const ListTile(
                    leading: Icon(Icons.info_outline_rounded),
                    title: Text("Tip"),
                    subtitle: Text(
                        "Text als: \${ontvanger}, wordt automatisch vervangen door de naam van de ontvanger."),
                  ),
                ),
                CustomCard(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          maxLines: null,
                          controller: headerController,
                          keyboardType: TextInputType.multiline,
                          onChanged: (value) {
                            setState(() {
                              activeProfile
                                ..settings.mailHeader = value
                                ..save();
                            });
                          },
                        ),
                        for (double width in [double.infinity, 70])
                          CustomCard(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: Theme.of(context).colorScheme.outlineVariant,
                            child: SizedBox(
                              height: 20,
                              width: width,
                            ),
                          ),
                        TextField(
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          maxLines: null,
                          controller: footerController,
                          keyboardType: TextInputType.multiline,
                          onChanged: (value) {
                            setState(() {
                              activeProfile
                                ..settings.mailFooter = value
                                ..save();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Icon(Icons.arrow_downward),
                ),
                CustomCard(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        "${activeProfile.settings.mailHeader?.replaceAll("\${ontvanger}", "T. Borger") ?? ""}Ik wil u graag vragen om mijn cijfer te heroverwegen. Einstein heeft namelijk bewezen dat tijd relatief is. Tijdens de toets leek de tijd echt sneller te gaan door de stress, waardoor ik minder tijd had om alles goed te maken. Dit had invloed op mijn resultaat. Zou u mijn cijfer daarom alstublieft willen herzien?\n${activeProfile.settings.mailFooter ?? ""}",
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
