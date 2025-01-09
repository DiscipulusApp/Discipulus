import 'package:discipulus/api/models/activities.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/html.dart';
import 'package:discipulus/widgets/global/tiles/loading_button.dart';
import 'package:flutter/material.dart';

class ActivityElementCard extends StatefulWidget {
  const ActivityElementCard({
    super.key,
    required this.activityElement,
    this.onSignupChanged,
  });

  final ActivityElement activityElement;
  final void Function(bool signedUp)? onSignupChanged;

  @override
  State<ActivityElementCard> createState() => _ActivityElementCardState();
}

class _ActivityElementCardState extends State<ActivityElementCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Table(
            columnWidths: const {
              0: FlexColumnWidth(),
              1: FixedColumnWidth(56.0)
            },
            children: [
              TableRow(
                children: [
                  LayoutBuilder(builder: (context, constraints) {
                    return Wrap(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.date_range),
                          title: Text(widget.activityElement.eindeInschrijfdatum
                              .formattedDateWithoutYear),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(
                              "${widget.activityElement.maxAantalDeelnemers - widget.activityElement.aantalPlaatsenBeschikbaar}/${widget.activityElement.maxAantalDeelnemers}"),
                        ),
                      ]
                          .map(
                            (e) => CustomCard(
                              elevation: 0,
                              child: e,
                            ),
                          )
                          .wrapOn(constraints, wrapWidth: 500)
                          .toList(),
                    );
                  }),
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.fill,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: signupButton(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.subject),
            title: Text(widget.activityElement.titel),
          ),
          if (widget.activityElement.details != null &&
              !widget.activityElement.details!.isEmptyHTML)
            CustomAnimatedSize(
              child: CustomCard(
                elevation: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: SizedBox(
                        height: isExpanded ? null : 100,
                        child: HTMLDisplay(
                          html: widget.activityElement.details ?? "",
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          if (widget.activityElement.details != null &&
              !widget.activityElement.details!.isEmptyHTML)
            Padding(
              padding: const EdgeInsets.all(4),
              child: FilledButton(
                onPressed: () => setState(() {
                  isExpanded = !isExpanded;
                }),
                child: SizedBox(
                  width: double.infinity,
                  child: isExpanded
                      ? const Icon(Icons.expand_less)
                      : const Icon(Icons.expand_more),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget signupButton(BuildContext context) {
    return widget.activityElement.isIngeschreven
        ? LoadingButton(
            future: () async {
              await widget.activityElement
                  .removeSignUp()
                  .then((value) => widget.onSignupChanged?.call(false));
              setState(() {});
            },
            child: (isLoading, onTap) => IconButton.filled(
              onPressed:
                  widget.activityElement.isOpInTeSchrijven ? onTap : null,
              icon: isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: IconTheme.of(context).color,
                      ),
                    )
                  : const Icon(Icons.check),
            ),
          )
        : LoadingButton(
            future: () async {
              await widget.activityElement
                  .signUp()
                  .then((value) => widget.onSignupChanged?.call(true));
              setState(() {});
            },
            child: (isLoading, onTap) => IconButton.filledTonal(
              icon: isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: IconTheme.of(context).color,
                      ),
                    )
                  : widget.activityElement.canSignUp
                      ? const Icon(Icons.add)
                      : const Icon(Icons.close),
              onPressed: widget.activityElement.canSignUp ? onTap : null,
            ),
          );
  }
}
