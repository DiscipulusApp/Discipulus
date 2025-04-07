import 'dart:io';

import 'package:discipulus/screens/introduction/vertical_intro.dart';
import 'package:discipulus/screens/settings/pages/android_settings.dart';
import 'package:discipulus/screens/settings/pages/apple_settings.dart';
import 'package:discipulus/screens/settings/pages/discipulus_settings.dart';
import 'package:discipulus/screens/settings/pages/notification_settings.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';

List<IntroBulletPoint> functions(BuildContext context) => [
      IntroBulletPoint(
        icon: const Text("📣"),
        title: "Meldingen & Herinneringen",
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                "Discipulus kan je op de hoogte houden van nieuwe berichten, cijfers en andere belangrijke informatie. Je kan zelf instellen welke meldingen je wilt ontvangen."),
            const SizedBox(height: 8),
            CustomCard(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: ListTile(
                title: const Text("Pas meldingen aan"),
                trailing: const Icon(Icons.navigate_next),
                onTap: () => const NotificationSettingsPage().push(context),
              ),
            )
          ],
        ),
      ),
      IntroBulletPoint(
        icon: const Text("🤖"),
        title: "AI Functies (Gemini)",
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                "Bespaar nog meer tijd door AI in Discipulus te gebruiken. Vat berichten samen, genereer e-mails en meer! Hiervoor is een Gemini API-sleutel nodig."),
            const SizedBox(height: 8),
            CustomCard(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: ListTile(
                title: const Text("Configureer AI"),
                trailing: const Icon(Icons.navigate_next),
                onTap: () => const DiscipulusSettingsPage().push(context),
              ),
            )
          ],
        ),
      ),
      if (Platform.isAndroid)
        IntroBulletPoint(
          icon: const Text("🤫"),
          title: "Automatisch niet storen",
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  "Discipulus kan automatisch je niet storen modus inschakelen wanneer je op school bent. Dit werkt op basis van je locatie en de schooltijden die je hebt ingesteld. Zo word je niet gestoord tijdens de les."),
              const SizedBox(height: 8),
              CustomCard(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: ListTile(
                  title: const Text("Instellingen"),
                  trailing: const Icon(Icons.navigate_next),
                  // Assuming background refresh is part of notification settings for now
                  onTap: () => const AndroidSettingsPage().push(context),
                ),
              )
            ],
          ),
        ),
      if (Platform.isIOS || Platform.isMacOS)
        IntroBulletPoint(
          icon: const Text("🍏"),
          title: "Apple instellingen",
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  "Discipulus kan gebruik maken van Apple specifieke functies, zoals het automatisch verversen van de achtergrond. Dit zorgt ervoor dat je altijd de meest recente informatie hebt, zelfs als de app niet open staat."),
              const SizedBox(height: 8),
              CustomCard(
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: ListTile(
                  title: const Text("Instellingen"),
                  trailing: const Icon(Icons.navigate_next),
                  // Assuming background refresh is part of notification settings for now
                  onTap: () => const AppleSettingsPage().push(context),
                ),
              )
            ],
          ),
        ),
      IntroBulletPoint(
        icon: const Text("🎨"),
        title: "Thema",
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                "Personaliseer Discipulus volledig door de app aan te passen aan jouw favoriete kleuren."),
            const SizedBox(height: 8),
            CustomCard(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const PersonalColorSetting(),
            )
          ],
        ),
      ),
    ];

class PostLoginScreen extends StatefulWidget {
  const PostLoginScreen({super.key});

  @override
  State<PostLoginScreen> createState() => _PostLoginScreenState();
}

class _PostLoginScreenState extends State<PostLoginScreen> {
  void _navigateToHome() {
    Layout.of(context)?.goToPageFromIndex(
      activeProfile.settings.startingPageIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        title: const Text("Ontdek de krachtige functies"),
        automaticallyImplyLeading: false,
      ),
      customBuilder: (body) => Scaffold(
        body: body,
        persistentFooterButtons: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Klaar! Ga aan de slag"),
                onPressed: _navigateToHome,
              ),
            ),
          )
        ],
      ),
      children: [
        for (Widget e in functions(context).dislayCards)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: e,
          )
      ],
    );
  }
}
