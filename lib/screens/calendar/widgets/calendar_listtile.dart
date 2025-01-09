import 'dart:async';

import 'package:discipulus/api/models/activities.dart';
import 'package:discipulus/api/models/assignments.dart';
import 'package:discipulus/api/models/calendar.dart';
import 'package:discipulus/core/handoff.dart';
import 'package:discipulus/screens/activities/activity_detail.dart';
import 'package:discipulus/screens/assignments/assignment_details.dart';
import 'package:discipulus/screens/calendar/calendar_day/calendar_day_body.dart';
import 'package:discipulus/screens/calendar/calendar_details.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/context_menu.dart';
import 'package:discipulus/widgets/global/html.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:discipulus/widgets/global/tiles/loading_button.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:super_context_menu/super_context_menu.dart';

class SimpleDayViewEventTile extends StatefulWidget {
  const SimpleDayViewEventTile({
    super.key,
    required this.event,
    this.size = CalendarEventSize.normal,
    this.displayCountdown = false,
    this.callback,
    this.onTapOverride,
    this.navigationTile = true,
  });

  /// Can be a combination of multiple events;
  final List<CalendarEvent> event;

  /// The size of the event. When this property is null, the size will be
  /// dependent on the length of the event.
  final CalendarEventSize? size;

  /// Whether or not a countdown until the start date of the event should be
  /// shown.
  final bool displayCountdown;

  /// When the event tile was clicked and changes were made this will fire.
  final void Function()? callback;

  /// Override the button on the event tile. When this property is null the
  /// button will open a bottom sheet where the event details can be read and
  /// changed.
  final void Function()? onTapOverride;

  /// When this value is false the main button of the widget that opens the
  /// calendar details will not work.
  final bool navigationTile;

  @override
  State<SimpleDayViewEventTile> createState() => _SimpleDayViewEventTileState();
}

class _SimpleDayViewEventTileState extends State<SimpleDayViewEventTile> {
  Timer? _timer;

  ColorScheme get cardColor {
    if (widget.event.first.isCanceled ||
        !(widget.event.first.afwezigheid?.geoorloofd ?? true)) {
      // When event has been canceled
      return Theme.of(context).colorScheme.copyWith(
            primary: Theme.of(context).colorScheme.error,
            primaryContainer: Theme.of(context).colorScheme.errorContainer,
            onPrimary: Theme.of(context).colorScheme.onError,
            onPrimaryContainer: Theme.of(context).colorScheme.onErrorContainer,
            secondary: Theme.of(context)
                .colorScheme
                .error
                .harmonizeWith(Theme.of(context).colorScheme.secondary),
            secondaryContainer: Theme.of(context)
                .colorScheme
                .errorContainer
                .harmonizeWith(
                    Theme.of(context).colorScheme.secondaryContainer),
            surfaceTint: Theme.of(context)
                .colorScheme
                .error
                .harmonizeWith(Theme.of(context).colorScheme.surfaceTint),
          );
    } else if (widget.event.first.isTest) {
      // When event is a test
      return Theme.of(context).colorScheme.copyWith(
            primary: Theme.of(context).colorScheme.tertiary,
            primaryContainer: Theme.of(context).colorScheme.tertiaryContainer,
            onPrimary: Theme.of(context).colorScheme.onTertiary,
            onPrimaryContainer:
                Theme.of(context).colorScheme.onTertiaryContainer,
            secondary: Theme.of(context)
                .colorScheme
                .tertiary
                .harmonizeWith(Theme.of(context).colorScheme.secondary),
            secondaryContainer: Theme.of(context)
                .colorScheme
                .tertiaryContainer
                .harmonizeWith(
                    Theme.of(context).colorScheme.secondaryContainer),
            surfaceTint: Theme.of(context)
                .colorScheme
                .tertiary
                .harmonizeWith(Theme.of(context).colorScheme.surfaceTint),
            onSecondary: Theme.of(context)
                .colorScheme
                .onTertiary
                .harmonizeWith(Theme.of(context).colorScheme.onSecondary),
            onSecondaryContainer: Theme.of(context)
                .colorScheme
                .onTertiaryContainer
                .harmonizeWith(
                    Theme.of(context).colorScheme.onSecondaryContainer),
          );
    }
    return Theme.of(context).colorScheme;
  }

  @override
  void initState() {
    _timer = Timer(
      widget.event.first.start.difference(DateTime.now()),
      () {
        if (mounted) setState(() {});
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomContextMenuWidget(
      liftBuilder: (context, child) => CustomCard(
        margin: EdgeInsets.zero,
        child: child,
      ),
      menuProvider: (MenuRequest request) {
        return Menu(children: menu);
      },
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: cardColor,
        ),
        child: Hero(
          tag: widget.event.map((e) => e.id.isNegative ? e.id : e.uuid).join(),
          child: CustomCard(
            // color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Column(
              children: [
                CustomAnimatedSize(
                  child: CountDownWidget(
                    countDownTime: widget.event.first.start,
                    builder: (countdown) {
                      bool shoudlDisplay =
                          !countdown.time.isNegative && widget.displayCountdown;
                      return SizedBox(
                        height: shoudlDisplay ? null : 0,
                        child: CustomCard(
                          margin: const EdgeInsets.all(8).copyWith(bottom: 0),
                          elevation: 0,
                          child: ListTile(
                            leading: shoudlDisplay
                                ? const Icon(Icons.access_time)
                                : null,
                            title: Text(
                                "Start in ${countdown.time} ${countdown.unit}"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Table(
                  columnWidths: [
                    if (widget.event.first.lesuurVan != null)
                      const FixedColumnWidth(48.0),
                    if (widget.size == CalendarEventSize.large ||
                        widget.size == null)
                      const FixedColumnWidth(0),
                    const FlexColumnWidth(),
                    const FixedColumnWidth(48.0)
                  ].asMap(),
                  children: [
                    TableRow(
                      children: [
                        if (widget.event.first.lesuurVan != null)
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(8.0).copyWith(right: 0),
                              child: HourIndicator(
                                from: widget.event.first.lesuurVan!,
                                to: widget.event.last.lesuurTotMet,
                              ),
                            ),
                          ),
                        if (widget.size == CalendarEventSize.large ||
                            widget.size == null)
                          TableCell(
                            child: SizedBox(
                              height: widget.event.first.duurtHeleDag
                                  ? 50
                                  : widget.size != null
                                      ? 100
                                      : widget.event.duration.inMinutes
                                          .clamp(30, 200)
                                          .toDouble(),
                            ),
                          ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: ListTile(
                            dense: widget.size == CalendarEventSize.small,
                            title: Text(widget.event.first.title.capitalized),
                            subtitle: Text(
                              maxLines: widget.event.first.lesuurVan ==
                                      widget.event.last.lesuurTotMet
                                  ? 1
                                  : 2,
                              overflow: TextOverflow.ellipsis,
                              [
                                // Location
                                widget.event.first.lokatie ??
                                    widget.event.first.lokalen
                                        ?.map((e) => e.naam)
                                        .formattedJoin,
                                // Absence
                                widget.event
                                        .map((e) => e.afwezigheid)
                                        .nonNulls
                                        .isNotEmpty
                                    ? "Afwezig"
                                    : null,
                                //Time
                                widget.event.first.duurtHeleDag
                                    ? "${widget.event.last.einde.difference(widget.event.first.start).inDays} dag(en)"
                                    : "${widget.event.first.start.formattedTime} - ${widget.event.last.einde.formattedTime}",
                                // Special things
                                if (widget.event.first.isCanceled)
                                  widget.event.first.status.toName,
                                // Infotype
                                if (widget.event.first.infoType.index != 0)
                                  widget.event.first.infoType.toName,
                                // Teacher
                                widget.event.first.docenten
                                    ?.map((e) => e.naam)
                                    .formattedJoin,
                              ].where((e) => e != null && e != "").join(" • "),
                            ),
                          ),
                        ),
                        if (widget.navigationTile)
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.fill,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, right: 8, bottom: 8),
                              child: SizedBox(
                                child: IconButton.filledTonal(
                                  onPressed: widget.onTapOverride ??
                                      () => showCalendarEventDetailsSheet(
                                            context,
                                            events: widget.event,
                                            callback: widget.callback,
                                            showSeeInContext: false,
                                          ),
                                  icon: const Icon(Icons.navigate_next),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                if (widget.event.first.inhoud != null &&
                    !widget.event.first.inhoud!.isEmptyHTML)
                  Padding(
                    padding: const EdgeInsets.all(4.0).copyWith(top: 0),
                    child: Table(
                      columnWidths: [
                        if (widget.event.first.isEditable)
                          const FixedColumnWidth(48.0),
                        const FlexColumnWidth(),
                      ].asMap(),
                      children: [
                        TableRow(
                          children: [
                            if (widget.event.first.isEditable)
                              TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.fill,
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: _buildDoneButton(),
                                ),
                              ),
                            CustomCard(
                              child: ExpandableEventBody(
                                constraints: widget.navigationTile
                                    ? const BoxConstraints(maxHeight: 128)
                                    : const BoxConstraints(maxHeight: 128 * 2),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: HTMLDisplay(
                                    html: widget.event.first.inhoud!,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> toggleAfgerond() async {
    widget.event.first.afgerond = !widget.event.first.afgerond;
    widget.event.first.save();
    await widget.event.first.sync();
    widget.callback?.call();
    setState(() {});
  }

  Widget _buildDoneButton() {
    // Function for toggling the "afgerond" property

    if (widget.event.first.afgerond) {
      return LoadingButton(
        future: toggleAfgerond,
        child: (isLoading, onTap) => IconButton.filled(
          onPressed: onTap,
          icon: isLoading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: IconTheme.of(context).color,
                  ),
                )
              : const Icon(Icons.done),
        ),
      );
    } else {
      return LoadingButton(
        future: toggleAfgerond,
        child: (isLoading, onTap) => IconButton.filledTonal(
          onPressed: onTap,
          icon: isLoading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: IconTheme.of(context).color,
                  ),
                )
              : const Icon(Icons.close),
        ),
      );
    }
  }

  List<MenuElement> get menu => [
        Menu(title: "Status", children: [
          for (var e in statusOptions.entries) ...[
            MenuAction(
              callback: () {
                widget.event.first.status = e.key;
                widget.event.first.save();
                widget.event.first.sync();
                setState(() {});
              },
              state: widget.event.first.status == e.key ||
                      (e.key == null &&
                          widget.event.first.status ==
                              widget.event.first.rawStatus)
                  ? MenuActionState.checkOn
                  : MenuActionState.none,
              title: e.value,
            ),
            if (e.key == null)
              MenuSeparator(), // Original entry will get separator
          ]
        ]),
        Menu(title: "Informatie", children: [
          for (var e in infoTypeOptions.entries) ...[
            MenuAction(
              callback: () {
                widget.event.first.infoType = e.key;
                widget.event.first.save();
                widget.event.first.sync();
                setState(() {});
              },
              state: widget.event.first.infoType == e.key ||
                      (e.key == null &&
                          widget.event.first.infoType ==
                              widget.event.first.rawInfoType)
                  ? MenuActionState.checkOn
                  : MenuActionState.none,
              title: e.value,
            ),
            if (e.key == null)
              MenuSeparator(), // Original entry will get separator
          ]
        ]),
        if (widget.event.first.isEditable &&
            widget.event.first.infoType != InfoType.none) ...[
          MenuSeparator(),
          MenuAction(
            state: widget.event.first.afgerond
                ? MenuActionState.checkOn
                : MenuActionState.checkOff,
            callback: toggleAfgerond,
            title: "Afgerond",
          )
        ]
      ];
}

class HourIndicator extends StatelessWidget {
  const HourIndicator({super.key, required this.from, this.to});

  final int from;
  final int? to;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const StadiumBorder(),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        children: [
          CircleAvatar(child: Text(from.toString())),
          if (to != null && to != from)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: CircleAvatar(child: Text(to.toString())),
            )
        ],
      ),
    );
  }
}

class ExpandableEventBody extends StatefulWidget {
  const ExpandableEventBody({
    super.key,
    required this.child,
    this.constraints = const BoxConstraints(maxHeight: 128),
  });

  final Widget child;
  final BoxConstraints constraints;

  @override
  State<ExpandableEventBody> createState() => _ExpandableEventBodyState();
}

class _ExpandableEventBodyState extends State<ExpandableEventBody> {
  bool _isExpanded = false;
  final GlobalKey _key = GlobalKey();

  Size? get childSize {
    final RenderBox? renderLogo =
        _key.currentContext?.findRenderObject() as RenderBox?;
    return renderLogo?.size;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CustomAnimatedSize(
          child: Column(
            children: [
              ConstrainedBox(
                key: _key,
                constraints:
                    !_isExpanded ? widget.constraints : const BoxConstraints(),
                child: widget.child,
              ),
              if (_isExpanded)
                const SizedBox(
                  height: 38 + 8, // Button height + Padding
                ),
            ],
          ),
        ),
        CustomAnimatedSize(
          curve: Easing.emphasizedDecelerate,
          duration: Durations.short3,
          child: Padding(
            padding: EdgeInsets.all(
                ((childSize?.height ?? 0) >= widget.constraints.maxHeight)
                    ? 8
                    : 0),
            child: SizedBox(
              width: double.infinity,
              height: ((childSize?.height ?? 0) >= widget.constraints.maxHeight)
                  ? 38
                  : 0,
              child: IconButton.filled(
                onPressed: () => setState(() {
                  _isExpanded = !_isExpanded;
                }),
                icon: _isExpanded
                    ? const Icon(Icons.expand_less)
                    : const Icon(Icons.expand_more),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class CountDownWidget extends StatefulWidget {
  const CountDownWidget({
    super.key,
    required this.countDownTime,
    required this.builder,
    this.noNegative = true,
  });

  final DateTime countDownTime;
  final Widget Function(FormattedDuration duration) builder;
  final bool noNegative;

  @override
  State<CountDownWidget> createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget> {
  Timer? _timer;
  late final ValueNotifier<FormattedDuration> countdown;
  bool _isDisposed = false;

  DateTime get nextChange {
    // We need to change the timer, when the countdown changes

    Duration timeBetween = widget.countDownTime.difference(DateTime.now());

    if (timeBetween.inSeconds < 60) {
      // Seconds
      return DateTime.now().add(const Duration(seconds: 1));
    } else if (timeBetween.inMinutes < 60) {
      // Minutes
      return DateTime.now().add(const Duration(minutes: 1));
    } else if (timeBetween.inHours < 24) {
      // Hours
      return DateTime.now().add(const Duration(hours: 1));
    } else {
      return DateTime.now().add(const Duration(days: 1));
    }
  }

  void update() {
    if (!_isDisposed) {
      // Set new value
      if (_timer != null) _timer!.cancel();
      Duration duration = widget.countDownTime.difference(DateTime.now());
      countdown.value = duration.toNameFormat;
      // Schedule next update
      if (!duration.inSeconds.isNegative) {
        _timer = Timer(
          nextChange.difference(DateTime.now()),
          update,
        );
      }
    }
  }

  @override
  void initState() {
    countdown = ValueNotifier(
        widget.countDownTime.difference(DateTime.now()).toNameFormat);
    update();
    super.initState();
  }

  @override
  void dispose() {
    _isDisposed = true;
    countdown.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: countdown,
      builder: (context, value, child) => widget.builder(value),
    );
  }
}

class AssignmentCalendarTile extends StatelessWidget {
  const AssignmentCalendarTile({super.key, required this.assignment});

  final Assignment assignment;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: ListTile(
        onTap: () =>
            AssignmentDetailsScreen(assignment: assignment).push(context),
        leading: assignment.ingeleverdOp != null
            ? const Icon(Icons.done)
            : const Icon(Icons.history_edu),
        title: Text(
          assignment.titel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "Inleveren voor: ${assignment.inleverenVoor.formattedTime}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class ActivityCalendarTile extends StatelessWidget {
  const ActivityCalendarTile({super.key, required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: ListTile(
        onTap: () => ActivityDetailScreen(activity: activity).push(context),
        leading: activity.canSignUp
            ? const Icon(Icons.person)
            : const Icon(Icons.done),
        title: Text(
          activity.titel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          "Inschrijven voor: ${activity.eindeInschrijfdatum.formattedTime}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
            "${activity.aantalInschrijvingen} (${activity.minimumAantalInschrijvingenPerActiviteit}/${activity.maximumAantalInschrijvingenPerActiviteit})"),
      ),
    );
  }
}

Future<void> showCalendarEventDetailsSheet(
  BuildContext context, {
  required List<CalendarEvent> events,
  void Function()? callback,
  bool showSeeInContext = true,
}) async {
  await showScrollableModalBottomSheet(
    activity: HandoffActivity.construct(
      type: NSUserActivityTypes.bottomSheet,
      title:
          "${events.first.title} op ${events.first.start.formattedDateAndTimWithoutYear}",
      screenType: CalendarEventDetails,
      profileUUID: events.first.profile.value?.uuid,
      extraInfo: {
        "event_uuids": [for (var e in events) e.uuid],
        "event_ids": [for (var e in events) e.id],
        "event_start": [for (var e in events) e.start.microsecondsSinceEpoch]
      },
    ),
    context: context,
    builder: (context, setState, scrollcontroller) => SingleChildScrollView(
      controller: scrollcontroller,
      child: CalendarEventDetails(
        combinedEvent: events,
        callback: callback,
        showSeeInContext: showSeeInContext,
      ),
    ),
  );
}
