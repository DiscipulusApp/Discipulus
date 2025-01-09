import 'package:animations/animations.dart';
import 'package:collection/collection.dart';
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:flutter/material.dart';
import 'package:discipulus/api/models/leermiddelen.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:url_launcher/url_launcher.dart';

class LeermiddelenScreen extends StatefulWidget {
  const LeermiddelenScreen({super.key});

  @override
  State<LeermiddelenScreen> createState() => _LeermiddelenScreenState();
}

class _LeermiddelenScreenState extends State<LeermiddelenScreen> {
  List<Leermiddel> leermiddelen = [];

  Future<void> getLeermiddelen() async {
    leermiddelen = await activeProfile.account.value!.api
        .person(activeProfile.id)
        .leermiddelen;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      // This is the only root-view that gets an exception on the noWait rule,
      // since it has to be loaded every single time and waiting an extra 500ms
      // before you can do anything it really annoying.
      noWait: true,
      activity: HandoffActivity.construct(
        type: NSUserActivityTypes.rootPage,
        title: "Leermiddelen",
        screenType: LeermiddelenScreen,
      ),
      fetch: (isOffline) async {
        if (!isOffline) {
          getLeermiddelen().then((value) {
            if (mounted) setState(() {});
          });
        }
      },
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        title: const Text("Leermiddelen"),
        actions: [
          if (trailingRefreshButton != null) trailingRefreshButton,
        ],
        leading: leading,
      ),
      children: [
        ...(leermiddelen.map((e) => e.vak.omschrijving).toSet()
              ..sortedBy(
                (element) => element,
              ))
            .map(
              (e) => [
                AppearAnimation(
                  child: (animation) => FadeScaleTransition(
                    animation: animation,
                    child: ListTitle(
                      child: Text(e.capitalized),
                    ),
                  ),
                ),
                ...leermiddelen.where((l) => l.vak.omschrijving == e).map(
                      (e) => AppearAnimation(
                        child: (animation) => FadeScaleTransition(
                          animation: animation,
                          child: ListTile(
                            title: Text(
                              e.titel,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(e.uitgeverij),
                            trailing: const Icon(Icons.open_in_browser),
                            onTap: () async => launchUrl(
                                await e.redirectLocation,
                                mode: LaunchMode.externalApplication),
                          ),
                        ),
                      ),
                    )
              ],
            )
            .expand((element) => element),
      ],
    );
  }
}
