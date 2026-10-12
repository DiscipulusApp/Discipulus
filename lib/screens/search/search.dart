import 'package:discipulus/api/models/assignments.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/api/models/messages.dart';
import 'package:discipulus/api/models/permissions.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/screens/assignments/assignments.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day.dart';
import 'package:discipulus/screens/grades/grades.dart';
import 'package:discipulus/screens/messages/message_details.dart';
import 'package:discipulus/screens/studiewijzers/studiewijzer_details.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchEntry {
  const _SearchEntry(this.category, this.title, this.detail, this.icon, this.destination);

  final String category;
  final String title;
  final String detail;
  final IconData icon;
  final Widget destination;

  bool matches(String query) =>
      title.toLowerCase().contains(query) || detail.toLowerCase().contains(query);
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<_SearchEntry>> _entries;
  int? _loadedProfileUuid;
  String _query = '';
  String _category = 'Alles';

  @override
  void initState() {
    super.initState();
    _loadedProfileUuid = activeProfile.uuid;
    _entries = _loadEntries();
  }

  Future<List<_SearchEntry>> _loadEntries() async {
    final profile = activeProfile;
    final permissions = profile.account.value?.permissions ?? [];
    final entries = <_SearchEntry>[];
    final now = DateTime.now();

    // Search data already downloaded for this profile. The bounded time ranges
    // keep search responsive even for accounts with many years of history.
    if (permissions.hasPermissions(PermissionType.afspraken)) {
      final events = await profile.calendarEvents
          .filter()
          .startBetween(now.subtract(const Duration(days: 90)),
              now.add(const Duration(days: 365)))
          .sortByStartDesc()
          .limit(500)
          .findAll();
      for (final event in events) {
        entries.add(_SearchEntry('Rooster', event.title,
            event.omschrijving ?? '', Icons.calendar_today_outlined,
            CalendarDayView(displayedDay: event.start)));
      }
    }

    if (permissions.hasPermissions(PermissionType.eloOpdracht)) {
      final assignments = await profile.assignments
          .filter()
          .inleverenVoorBetween(now.subtract(const Duration(days: 365)),
              now.add(const Duration(days: 365)))
          .sortByInleverenVoorDesc()
          .limit(300)
          .findAll();
      for (final assignment in assignments) {
        entries.add(_SearchEntry('Opdrachten', assignment.titel,
            assignment.vak, Icons.assignment_outlined,
            const AssignmentListScreen()));
      }
    }

    if (permissions.hasPermissions(PermissionType.berichten)) {
      final folders = await profile.berichtMappen.filter().findAll();
      for (final folder in folders) {
        final messages = await folder.berichten
            .filter()
            .sortByVerzondenOpDesc()
            .limit(150)
            .findAll();
        for (final message in messages) {
          entries.add(_SearchEntry('Berichten', message.onderwerp ?? 'Bericht',
              message.afzender?.naam ?? '', Icons.message_outlined,
              MessageScreen(message: message)));
        }
      }
    }

    if (permissions.hasPermissions(PermissionType.studiewijzers) ||
        permissions.hasPermissions(PermissionType.projecten)) {
      final guides = await profile.studiewijzers.filter().findAll();
      for (final guide in guides) {
        entries.add(_SearchEntry('Studiewijzers', guide.titel,
            guide.groupName ?? '', Icons.menu_book_outlined,
            StudieWijzerScreen(studiewijzer: guide)));
      }
    }

    if (permissions.hasPermissions(PermissionType.cijfers)) {
      final year = await profile.schoolyears
          .filter()
          .sortByEindeDesc()
          .findFirst();
      if (year != null) {
        final grades = await year.grades.filter().findAll();
        for (final grade in grades) {
          entries.add(_SearchEntry('Cijfers',
              grade.description ?? grade.subject.value?.naam ?? 'Cijfer',
              '${grade.cijferStr ?? ''} ${grade.subject.value?.naam ?? ''}',
              Icons.numbers_outlined, const GradesListScreen()));
        }
      }
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    // A search route may survive a profile switch. Never show another
    // student's cached results, even while the new query is loading.
    if (_loadedProfileUuid != activeProfile.uuid) {
      _loadedProfileUuid = activeProfile.uuid;
      _category = 'Alles';
      _entries = _loadEntries();
    }
    return ScaffoldSkeleton(
        noInitialFetch: true,
        appBar: (_, __, leading) => SliverAppBar.large(
          title: const Text('Zoeken'),
          leading: leading,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              autofocus: true,
              onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                labelText: 'Zoek in je schoolgegevens',
                hintText: 'Vak, opdracht, bericht, cijfer...',
              ),
            ),
          ),
          FutureBuilder<List<_SearchEntry>>(
            future: _entries,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text('Zoekgegevens konden niet worden geladen.'),
                      TextButton(
                        onPressed: () => setState(() => _entries = _loadEntries()),
                        child: const Text('Opnieuw proberen'),
                      ),
                    ],
                  ),
                );
              }
              if (snapshot.connectionState != ConnectionState.done ||
                  !snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (_query.length < 2) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Voer minimaal twee letters in om te zoeken.'),
                );
              }
              final matchingAll = snapshot.data!.where((item) => item.matches(_query)).toList();
              final categories = <String>{'Alles', ...matchingAll.map((item) => item.category)};
              final selectedCategory = categories.contains(_category) ? _category : 'Alles';
              final matches = matchingAll.where((item) =>
                  selectedCategory == 'Alles' || item.category == selectedCategory).toList();
              if (matches.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Geen resultaten gevonden in je opgeslagen gegevens.'),
                );
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          for (final category in categories)
                            ChoiceChip(
                              label: Text(category),
                              selected: category == selectedCategory,
                              onSelected: (_) => setState(() => _category = category),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('${matches.length} resultaten · Alleen lokaal opgeslagen gegevens',
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ),
                  for (final item in matches.take(40))
                    ListTile(
                      leading: Icon(item.icon),
                      title: Text(item.title,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(item.detail.isEmpty
                          ? item.category
                          : '${item.category} · ${item.detail}',
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Layout.of(context)?.goToPage(
                          item.destination, makeFirst: false),
                    ),
                ],
              );
            },
          ),
        ],
      );
  }
}