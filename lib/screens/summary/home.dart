import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/api/models/permissions.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/assignments/assignments.dart';
import 'package:discipulus/screens/grades/grades.dart';
import 'package:discipulus/screens/messages/messages.dart';
import 'package:discipulus/screens/studiewijzers/studiewijzers.dart';
import 'package:discipulus/screens/summary/widgets/upcoming_tests.dart';
import 'package:discipulus/screens/summary/widgets/upcoming_assignments.dart';
import 'package:discipulus/screens/search/search.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/screens/summary/widgets/favorite_studiewijzers.dart';
import 'package:discipulus/screens/summary/widgets/next_lesson.dart';
import 'package:discipulus/screens/summary/widgets/recent_grades.dart';
import 'package:discipulus/screens/summary/widgets/recent_messages.dart';
import 'package:discipulus/utils/account_manager.dart';
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
    final permissions = activeProfile.account.value?.permissions ?? [];
    final hasCalendar = permissions.hasPermissions(PermissionType.afspraken);
    final hasGrades = permissions.hasPermissions(PermissionType.cijfers);
    final hasMessages = permissions.hasPermissions(PermissionType.berichten);
    final hasGuides = permissions.hasPermissions(PermissionType.studiewijzers) ||
        permissions.hasPermissions(PermissionType.projecten);
    final hasAssignments = permissions.hasPermissions(PermissionType.eloOpdracht);
    final lastUpdated = activeProfile.settings.lastRefresh;
    // Ensure cached sections are recreated on a profile switch as well as
    // after a successful refresh, even if both profiles share a timestamp.
    final contentKey = '${activeProfile.uuid}_${lastUpdated?.microsecondsSinceEpoch}';

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
          if (mounted) setState(() {});
        }
      },
      appBar: (_, trailingWidgets, leading) => SliverAppBar.large(
        title: const Text("Samenvatting"),
        leading: leading,
        actions: [
          IconButton(
            tooltip: 'Zoeken',
            onPressed: () => Layout.of(context)?.goToPage(
                const SearchScreen(), makeFirst: false),
            icon: const Icon(Icons.search),
          ),
          if (trailingWidgets != null) trailingWidgets,
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Jouw schooloverzicht',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                lastUpdated == null
                    ? 'Nog geen synchronisatie uitgevoerd'
                    : 'Laatst bijgewerkt: ${MaterialLocalizations.of(context).formatShortDate(lastUpdated)} '
                        '${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(lastUpdated))}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (hasCalendar)
                    ActionChip(
                      avatar: const Icon(Icons.calendar_today_outlined, size: 18),
                      label: const Text('Rooster'),
                      onPressed: () => Layout.of(context)?.goToPage(
                          const CalendarDayView(), makeFirst: false),
                    ),
                  if (hasAssignments)
                    ActionChip(
                      avatar: const Icon(Icons.checklist_rounded, size: 18),
                      label: const Text('Opdrachten'),
                      onPressed: () => Layout.of(context)?.goToPage(
                          const AssignmentListScreen(), makeFirst: false),
                    ),
                  if (hasGrades)
                    ActionChip(
                      avatar: const Icon(Icons.numbers_outlined, size: 18),
                      label: const Text('Cijfers'),
                      onPressed: () => Layout.of(context)?.goToPage(
                          const GradesListScreen(), makeFirst: false),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (hasCalendar) ...[
          const _DashboardSectionTitle('Volgende les'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: NextLessonTile(key: ValueKey(contentKey)),
          ),
          const _DashboardSectionTitle('Aankomende toetsen'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(child: UpcomingTestsTile(key: ValueKey(contentKey))),
          ),
        ],
        if (hasAssignments) ...[
          _DashboardSectionTitle('Taken en deadlines', onTap: () =>
              Layout.of(context)?.goToPage(const AssignmentListScreen(), makeFirst: false)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(child: UpcomingAssignmentsTile(key: ValueKey(contentKey))),
          ),
        ],
        if (hasMessages) ...[
          _DashboardSectionTitle('Ongelezen berichten', onTap: () =>
              Layout.of(context)?.goToPage(const MessagesListScreen(), makeFirst: false)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: RecentMessagesTile(key: ValueKey(contentKey)),
          ),
        ],
        if (hasGrades) ...[
          _DashboardSectionTitle('Recente cijfers', onTap: () =>
              Layout.of(context)?.goToPage(const GradesListScreen(), makeFirst: false)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: RecentGradesWidget(key: ValueKey(contentKey)),
          ),
        ],
        if (hasGuides) ...[
          _DashboardSectionTitle('Favoriete studiewijzers', onTap: () =>
              Layout.of(context)?.goToPage(const StudiewijzerListScreen(), makeFirst: false)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: FavoriteStudiewijzersTile(key: ValueKey(contentKey)),
          ),
        ],
      ],
    );
  }
}

class _DashboardSectionTitle extends StatelessWidget {
  const _DashboardSectionTitle(this.title, {this.onTap});

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Row(
          children: [
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.titleMedium),
            ),
            if (onTap != null)
              TextButton(
                onPressed: onTap,
                child: const Text('Bekijk alles'),
              ),
          ],
        ),
      );
}
