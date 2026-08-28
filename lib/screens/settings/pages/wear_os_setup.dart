import 'package:discipulus/api/authentication.dart';
import 'package:discipulus/core/watch_service.dart';
import 'package:discipulus/models/account.dart';
import 'package:discipulus/screens/introduction/login.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:watch_connectivity/watch_connectivity.dart';

class WearOSSetupScreen extends StatefulWidget {
  const WearOSSetupScreen({super.key});

  @override
  State<WearOSSetupScreen> createState() => _WearOSSetupScreenState();
}

class _WearOSSetupScreenState extends State<WearOSSetupScreen> {
  final _watch = WatchConnectivity();
  bool _isLoading = false;
  String _statusMessage = "";

  Future<void> _setCompanionMode() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Horloge instellen op companion-modus...";
    });

    try {
      await _watch.sendMessage({
        'type': 'config_mode',
        'mode': 'companion',
      });
      await WatchService().syncAll();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Horloge ingesteld op verbinding via telefoon!"),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Fout bij instellen: $e")),
        );
      }
    }
  }

  Future<void> _loginForProfile(Profile profile) async {
    final account = profile.account.value;
    String? tenant;
    if (account?.endPoint != null && account!.endPoint.isNotEmpty) {
      try {
        final host = Uri.parse(account.endPoint).host;
        if (host.isNotEmpty) tenant = host;
      } catch (_) {}
    }

    final tokenSet = await showMagisterLoginDialog(
      context,
      tenant: tenant,
    );
    if (tokenSet == null) return;

    setState(() {
      _isLoading = true;
      _statusMessage = "Gegevens koppelen voor ${profile.name}...";
    });

    try {
      final apiEndpoint = await Authentication.apiEndpoint(tokenSet);

      await _watch.sendMessage({
        'type': 'tokenset',
        'data': {
          'accessToken': tokenSet.accessToken,
          'refreshToken': tokenSet.refreshToken ?? '',
          'idToken': tokenSet.idToken,
          'expiresAt': tokenSet.expiredDate?.millisecondsSinceEpoch ??
              (DateTime.now().millisecondsSinceEpoch + 3600000),
          'apiEndpoint': apiEndpoint.toString(),
          'personId': profile.id,
          'accountName': profile.name,
        },
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Nieuwe tokenset succesvol gekoppeld aan horloge voor ${profile.name}!"),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Fout bij koppelen van tokenset: $e")),
        );
      }
    }
  }

  Future<void> _loginNewMagisterAccount() async {
    final tokenSet = await showMagisterLoginDialog(context);
    if (tokenSet == null) return;

    setState(() {
      _isLoading = true;
      _statusMessage = "Accountgegevens koppelen...";
    });

    try {
      final apiEndpoint = await Authentication.apiEndpoint(tokenSet);

      await _watch.sendMessage({
        'type': 'tokenset',
        'data': {
          'accessToken': tokenSet.accessToken,
          'refreshToken': tokenSet.refreshToken ?? '',
          'idToken': tokenSet.idToken,
          'expiresAt': tokenSet.expiredDate?.millisecondsSinceEpoch ??
              (DateTime.now().millisecondsSinceEpoch + 3600000),
          'apiEndpoint': apiEndpoint.toString(),
        },
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Nieuw account gekoppeld aan horloge!"),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Fout bij afronden login: $e")),
        );
      }
    }
  }

  Widget _buildFeatureBullet({required IconData icon, required String title}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 16,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        leading: leading,
        title: const Text("Wear OS Instellen"),
      ),
      children: [
        if (_isLoading) ...[
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    Text(
                      _statusMessage,
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          )
        ] else ...[
          CustomCard(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Standalone Mode Section
                  CustomCard(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.wifi_tethering_rounded,
                                  color: colorScheme.onPrimaryContainer,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Standalone Modus",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: colorScheme.primaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            "Wi-Fi & LTE",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  colorScheme.onPrimaryContainer,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Zelfstandig zonder telefoonverbinding",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _buildFeatureBullet(
                            icon: Icons.cloud_done_rounded,
                            title: "Direct verbonden met Magister",
                          ),
                          _buildFeatureBullet(
                            icon: Icons.phone_disabled_rounded,
                            title: "Blijft werken zonder telefoon",
                          ),
                          _buildFeatureBullet(
                            icon: Icons.key_rounded,
                            title: "Eigen beveiligde tokenset",
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _loginNewMagisterAccount,
                              icon: const Icon(Icons.login_rounded),
                              label: const Text("Magister-account koppelen"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Companion Mode
                  CustomCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.phone_android_rounded,
                                  color: colorScheme.onSecondaryContainer,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Companion Modus",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: colorScheme.tertiaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            "Bluetooth",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme
                                                  .onTertiaryContainer,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Verbinding via je telefoon",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _buildFeatureBullet(
                            icon: Icons.sync_rounded,
                            title: "Automatische synchronisatie",
                          ),
                          _buildFeatureBullet(
                            icon: Icons.battery_charging_full_rounded,
                            title: "Zuinig in batterijverbruik",
                          ),
                          _buildFeatureBullet(
                            icon: Icons.lock_open_rounded,
                            title: "Geen aparte login nodig",
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.tonalIcon(
                              onPressed: _setCompanionMode,
                              icon: const Icon(Icons.check_rounded),
                              label: const Text("Huidige account koppelen"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ]
      ],
    );
  }
}
