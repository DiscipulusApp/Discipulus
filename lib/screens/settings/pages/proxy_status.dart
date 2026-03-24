import 'package:discipulus/utils/proxy.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';

class WiiProxyStatusScreen extends StatelessWidget {
  const WiiProxyStatusScreen({super.key, required this.proxyUrl});

  final String proxyUrl;

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Proxy Actief"),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(
                Icons.settings_input_component,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 24),
              Text(
                "Je telefoon fungeert nu als proxy voor een extern apparaat.",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              CustomCard(
                child: ListTile(
                  leading: const Icon(Icons.link),
                  title: const Text("Proxy URL"),
                  subtitle: Text(proxyUrl),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "Houd deze app open zolang je het apparaat gebruikt. Je kunt de proxy stoppen door hieronder op de knop te tikken.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () async {
                  await WiiProxyService.stop();
                  if (context.mounted) Navigator.of(context).pop();
                },
                icon: const Icon(Icons.stop),
                label: const Text("Stop Proxy"),
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
