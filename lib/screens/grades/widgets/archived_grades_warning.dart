import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/api/models/subjects.dart';
import 'package:discipulus/main.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

/// Displays a card that warns the user that one or more grades are archived
/// (for example, when a school hides grades during test weeks).
/// Allows enabling, disabling, or permanently deleting all archived grades in one go.
class ArchivedGradesWarning extends StatefulWidget {
  const ArchivedGradesWarning({
    super.key,
    required this.schoolyear,
    this.subject,
    this.onChanged,
  });

  /// The schoolyear to check for archived grades
  final Schoolyear schoolyear;

  /// Optional subject to filter archived grades
  final Subject? subject;

  /// Callback when grades are toggled or removed
  final VoidCallback? onChanged;

  @override
  State<ArchivedGradesWarning> createState() => _ArchivedGradesWarningState();
}

class _ArchivedGradesWarningState extends State<ArchivedGradesWarning> {
  List<Grade> _getArchivedGrades() {
    return (widget.subject?.grades ?? widget.schoolyear.grades)
        .filter()
        .isArchivedEqualTo(true)
        .findAllSync();
  }

  void _toggleAll(bool enable, List<Grade> archivedGrades) {
    isar.writeTxnSync(() {
      for (var grade in archivedGrades) {
        grade.isEnabled = enable;
        isar.grades.putSync(grade);
      }
    });
    setState(() {});
    widget.onChanged?.call();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          enable
              ? "Alle gearchiveerde cijfers ingeschakeld"
              : "Alle gearchiveerde cijfers uitgeschakeld",
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _deleteAll(List<Grade> archivedGrades) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Gearchiveerde cijfers verwijderen?"),
        content: const Text(
          "Weet je zeker dat je alle gearchiveerde cijfers definitief wilt verwijderen? Doe dit alleen als cijfers terecht zijn verwijderd door je school.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annuleren"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Verwijderen"),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      isar.writeTxnSync(() {
        for (var grade in archivedGrades) {
          isar.grades.deleteSync(grade.uuid);
        }
        widget.schoolyear.grades.saveSync();
      });
      setState(() {});
      widget.onChanged?.call();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gearchiveerde cijfers verwijderd"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final archivedGrades = _getArchivedGrades();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CustomAnimatedSize(
      child: archivedGrades.isEmpty
          ? const SizedBox.shrink()
          : Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              surfaceTintColor: colorScheme.tertiary,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2, right: 12),
                          child: Icon(
                            Icons.inventory_2_outlined,
                            color: colorScheme.tertiary,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                archivedGrades.length == 1
                                    ? "1 gearchiveerd cijfer"
                                    : "${archivedGrades.length} gearchiveerde cijfers",
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                archivedGrades.any((g) => g.isEnabled)
                                    ? "Verborgen in Magister (bijv. toetsweek). Telt momenteel mee voor je gemiddelde."
                                    : "Verborgen in Magister en uitgeschakeld in berekeningen.",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_rounded),
                          tooltip: "Opties",
                          onSelected: (value) {
                            if (value == 'delete') {
                              _deleteAll(archivedGrades);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_outline_rounded,
                                    color: colorScheme.error,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Definitief wissen",
                                    style: TextStyle(color: colorScheme.error),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (archivedGrades.any((g) => g.isEnabled))
                          FilledButton.tonalIcon(
                            onPressed: () => _toggleAll(false, archivedGrades),
                            icon: const Icon(Icons.visibility_off_outlined,
                                size: 18),
                            label: const Text("Alles uitschakelen"),
                          )
                        else
                          FilledButton.tonalIcon(
                            onPressed: () => _toggleAll(true, archivedGrades),
                            icon:
                                const Icon(Icons.visibility_outlined, size: 18),
                            label: const Text("Alles inschakelen"),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
