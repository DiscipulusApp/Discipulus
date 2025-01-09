import 'package:discipulus/api/models/assignments.dart';
import 'package:discipulus/api/models/bronnen.dart';
import 'package:discipulus/screens/assignments/assignment_details.dart';
import 'package:discipulus/screens/bronnen/bron_tiles.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/html.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:flutter/material.dart';

class AssignmentTile extends StatefulWidget {
  const AssignmentTile({
    super.key,
    required this.assignment,
    this.isNavigationCard = true,
  });

  final Assignment assignment;

  final bool isNavigationCard;

  @override
  State<AssignmentTile> createState() => _AssignmentTileState();
}

class _AssignmentTileState extends State<AssignmentTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Table(
            columnWidths:
                [const FlexColumnWidth(), const FixedColumnWidth(56.0)].asMap(),
            children: [
              TableRow(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Table(
                        columnWidths: [
                          if (widget.assignment.vak.isNotEmpty)
                            const FixedColumnWidth(56),
                          const FlexColumnWidth(),
                        ].asMap(),
                        children: [
                          TableRow(
                            children: [
                              if (widget.assignment.vak.isNotEmpty)
                                TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.fill,
                                  child: Row(
                                    children: [
                                      CustomCard(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        child: SizedBox(
                                          width: 48,
                                          height: double.infinity,
                                          child: Center(
                                            child: Text(
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500),
                                              widget.assignment.vak
                                                  .toUpperCase(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              CustomCard(
                                child: ListTile(
                                  title: Text(
                                    widget.assignment.titel,
                                    maxLines:
                                        widget.isNavigationCard ? 1 : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          children: [
                            if (!widget.assignment.magInleveren)
                              CustomCard(
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                                child: const SizedBox(
                                  height: 38,
                                  width: 38,
                                  child: Icon(
                                    Icons.lock,
                                    size: 18,
                                  ),
                                ),
                              ),
                            for (var e in [
                              RowTile(
                                icon: Icons.access_time,
                                title: widget
                                    .assignment.inleverenVoor.formattedTime,
                              ),
                              RowTile(
                                icon: Icons.date_range,
                                title: widget.assignment.inleverenVoor
                                    .formattedDateWithoutYear,
                              ),
                              RowTile(
                                icon: Icons.short_text,
                                title: widget.assignment.status.name,
                              )
                            ])
                              CustomCard(elevation: 8, child: e),
                          ],
                        ),
                      ),
                      if (!widget.isNavigationCard &&
                          !widget.assignment.omschrijving.isEmptyHTML)
                        CustomCard(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: HTMLDisplay(
                                html: widget.assignment.omschrijving),
                          ),
                        ),
                      if (!widget.isNavigationCard &&
                          widget.assignment.bronnen.isNotEmpty)
                        CustomCard(
                          child: Column(
                            children: [
                              for (Bron bron in widget.assignment.bronnen)
                                BronTile(bron: bron)
                            ],
                          ),
                        )
                    ],
                  ),
                  if (widget.isNavigationCard)
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.fill,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: IconButton.filled(
                          constraints:
                              const BoxConstraints(minHeight: double.infinity),
                          onPressed: () => AssignmentDetailsScreen(
                            assignment: widget.assignment,
                          ).push(context),
                          icon: const Icon(Icons.navigate_next),
                        ),
                      ),
                    )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension AssignmentSortingTypeExtension on AssignmentSortingType {
  String get toName {
    switch (this) {
      case AssignmentSortingType.alphabetical:
        return "Alphabetisch";
      case AssignmentSortingType.deadline:
        return "Deadline";
      default:
        return "Geen";
    }
  }
}

enum AssignmentSortingType { alphabetical, deadline, none }

extension AssignmentListExtension on Iterable<Assignment> {
  List<Assignment> assSort(AssignmentSortingType sortingType) {
    switch (sortingType) {
      case AssignmentSortingType.alphabetical:
        return toList()
          ..sort(
            (a, b) => a.titel.toLowerCase().compareTo(b.titel.toLowerCase()),
          );
      case AssignmentSortingType.deadline:
        return toList()
          ..sort(
            (a, b) => (b.inleverenVoor.millisecondsSinceEpoch)
                .compareTo(a.inleverenVoor.millisecondsSinceEpoch),
          );
      default:
        return toList();
    }
  }
}

class AssignmentVersionTile extends StatelessWidget {
  const AssignmentVersionTile({super.key, required this.assignmentVersion});

  final AssignmentVersion assignmentVersion;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (assignmentVersion.feedbackBijlagen.isNotEmpty ||
            assignmentVersion.docentOpmerking != null ||
            assignmentVersion.beoordeling != null)
          _buildMessageTile(context, false),
        _buildMessageTile(context),
      ],
    );
  }

  Widget _buildMessageTile(BuildContext context, [bool fromMe = true]) {
    final Iterable<Bron> bronnen = fromMe
        ? assignmentVersion.leerlingBijlagen
        : assignmentVersion.feedbackBijlagen;
    final String? comment = fromMe
        ? assignmentVersion.leerlingOpmerking?.nullOnEmpty
        : assignmentVersion.docentOpmerking?.nullOnEmpty?.withoutHTML;
    final DateTime? time = fromMe
        ? assignmentVersion.ingeleverdOp
        : assignmentVersion.beoordeeldOp;

    final String messageTitle = _getMessageTitle(fromMe);

    const double cardPadding = 8.0;
    const double contentHorizontalPadding = 12.0;
    const double contentVerticalPadding = 8.0;

    // No comment nor attachments, meaning that it is empty
    if ((assignmentVersion.leerlingOpmerking?.nullOnEmpty ??
                assignmentVersion.docentOpmerking?.nullOnEmpty?.withoutHTML) ==
            null &&
        [
          ...assignmentVersion.leerlingBijlagen,
          ...assignmentVersion.feedbackBijlagen
        ].isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: cardPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            fromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!fromMe)
            const Padding(
              padding: EdgeInsets.all(4),
              child: CircleAvatar(
                child: Icon(Icons.supervisor_account),
              ),
            ),
          Expanded(
            child: CustomCard(
              color: fromMe
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Column(
                crossAxisAlignment:
                    fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                            horizontal: contentHorizontalPadding,
                            vertical: contentVerticalPadding)
                        .copyWith(bottom: 4),
                    child: Text(
                      messageTitle,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  if (!(comment?.isEmptyHTML ?? true))
                    Padding(
                      padding: const EdgeInsets.symmetric(
                              horizontal: contentHorizontalPadding)
                          .copyWith(
                        bottom: contentVerticalPadding,
                      ),
                      child: Text(
                        comment!,
                      ),
                    ),
                  if (bronnen.isEmpty &&
                      comment == null &&
                      assignmentVersion.ingeleverdOp != null)
                    _buildStatusTile(context, fromMe),
                  if (bronnen.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(cardPadding),
                      child: CustomCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (Bron bron in bronnen) BronTile(bron: bron),
                          ],
                        ),
                      ),
                    ),
                  if (time != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding:
                            const EdgeInsets.all(cardPadding).copyWith(top: 0),
                        child: Text([
                          if (time != DateTime.fromMillisecondsSinceEpoch(0))
                            time.formattedTime,
                          "Versie ${assignmentVersion.versieNummer}"
                        ].join(" - ")),
                      ),
                    )
                ],
              ),
            ),
          ),
          if (fromMe)
            const Padding(
              padding: EdgeInsets.all(4),
              child: CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
        ],
      ),
    );
  }

  String _getMessageTitle(bool fromMe) {
    return fromMe
        ? assignmentVersion.assignment.value?.profile.value?.name ?? "Leerling"
        : assignmentVersion.assignment.value?.docenten
                ?.map((e) => e.naam)
                .formattedJoin
                .nullOnEmpty ??
            "Docent(en)";
  }

  Widget _buildStatusTile(BuildContext context, bool fromMe) {
    String statusText;
    if (assignmentVersion.beoordeling != null && !fromMe) {
      statusText = "Beoordeling: ${assignmentVersion.beoordeling}";
    } else if (assignmentVersion.ingeleverdOp != null) {
      statusText = "Opdracht ingeleverd";
    } else {
      statusText = "Opdracht afgesloten";
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: CustomCard(
        child: ListTile(
          leading: const Icon(Icons.done),
          title: Text(
            statusText,
          ),
        ),
      ),
    );
  }
}
