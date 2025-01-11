import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/screens/summary/widgets/favorite_studiewijzers.dart';
import 'package:discipulus/screens/summary/widgets/next_lesson.dart';
import 'package:discipulus/screens/summary/widgets/recent_grades.dart';
import 'package:discipulus/screens/summary/widgets/recent_messages.dart';
import 'package:discipulus/screens/summary/widgets/week_heatmap.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldSkeleton(
      activity: HandoffActivity.construct(
        type: NSUserActivityTypes.rootPage,
        title: "Samenvatting",
        screenType: HomeScreen,
      ),
      fetch: (isOffline) async {
        if (!isOffline) {
          await BackgroundRefresh.quickRefresh(
            onlyRefreshNeeded: false,
            enableNotifcations: false,
            profiles: [activeProfile],
          );
        }
      },
      appBar: (_, trailingWidgets, leading) => SliverAppBar.large(
        title: const Text("Samenvatting"),
        leading: leading,
        actions: [if (trailingWidgets != null) trailingWidgets],
      ),
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: NextLessonTile(),
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 8),
        //   child: WeekHeatmap(
        //     extraWeeks: 2,
        //   ),
        // ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: RecentMessagesTile(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: RecentGradesWidget(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: FavoriteStudiewijzersTile(),
        ),
        BottomSheetBottomContentPadding(),
      ],
    );
  }
}
