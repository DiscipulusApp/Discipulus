import 'package:discipulus/api/models/assignments.dart';
import 'package:discipulus/screens/assignments/assignments.dart';
import 'package:discipulus/utils/account_manager.dart';
import 'package:discipulus/widgets/global/layout.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

/// Open assignments that are due soon, using the existing offline cache.
class UpcomingAssignmentsTile extends StatelessWidget {
  const UpcomingAssignmentsTile({super.key});

  Future<List<Assignment>> _load() async {
    final now = DateTime.now();
    final assignments = await activeProfile.assignments
        .filter()
        .inleverenVoorBetween(
          now.subtract(const Duration(days: 7)),
          now.add(const Duration(days: 21)),
        )
        .sortByInleverenVoor()
        .findAll();
    return assignments
        .where((assignment) =>
            !assignment.afgesloten && assignment.ingeleverdOp == null)
        .take(4)
        .toList();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<Assignment>>(
        future: _load(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Opdrachten konden niet worden geladen.'),
            );
          }
          if (!snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: LinearProgressIndicator(),
            );
          }
          final assignments = snapshot.data!;
          if (assignments.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Geen openstaande deadlines in de komende drie weken.'),
            );
          }
          return Column(
            children: [
              for (final assignment in assignments)
                ListTile(
                  leading: Icon(
                    assignment.inleverenVoor.isBefore(DateTime.now())
                        ? Icons.priority_high_rounded
                        : Icons.assignment_outlined,
                  ),
                  title: Text(assignment.titel,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(
                    '${assignment.vak} · '
                    '${MaterialLocalizations.of(context).formatShortDate(assignment.inleverenVoor)}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Layout.of(context)?.goToPage(
                    const AssignmentListScreen(),
                    makeFirst: false,
                  ),
                ),
            ],
          );
        },
      );
}
