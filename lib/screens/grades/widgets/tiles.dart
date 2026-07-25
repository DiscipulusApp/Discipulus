import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/grades/grade_detail.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:haptic_kit/haptic_kit.dart';

class GradeTile extends StatelessWidget {
  const GradeTile({
    super.key,
    required this.grade,
    this.isAverage = false,
    this.setStateTop,
  });

  final Grade grade;
  final bool isAverage;
  final void Function(void Function())? setStateTop;

  List<Widget> _buildBadges() {
    return [
      // Change in average
      if (appSettings.enabledGradeBadgeTypes.contains(GradeBadgeTypes.change))
        FutureBuilder(
          future: grade.subject.value!.grades
              .filter()
              .changeInAverage(grade: grade),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Badge(
                    backgroundColor: snapshot.data!.change.isNegative
                        ? Theme.of(context).colorScheme.errorContainer
                        : null,
                    textColor: snapshot.data!.change.isNegative
                        ? Theme.of(context).colorScheme.onErrorContainer
                        : null,
                    label: Text(snapshot.data!.change.displayNumber()),
                  )
                : const SizedBox();
          },
        ),
      // Change in global average
      if (appSettings.enabledGradeBadgeTypes
          .contains(GradeBadgeTypes.globalChange))
        FutureBuilder(
            future: grade.schoolyear.value!.grades
                .filter()
                .changeInAverage(grade: grade),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Badge(
                      backgroundColor: snapshot.data!.change.isNegative
                          ? Theme.of(context).colorScheme.errorContainer
                          : null,
                      textColor: snapshot.data!.change.isNegative
                          ? Theme.of(context).colorScheme.onErrorContainer
                          : null,
                      label: Text(snapshot.data!.change.displayNumber()),
                    )
                  : const SizedBox();
            }),
      // Date
      if (appSettings.enabledGradeBadgeTypes.contains(GradeBadgeTypes.date) &&
          grade.datumIngevoerd != null)
        Badge(label: Text(grade.datumIngevoerd!.formattedDate)),
      // PTA indicator
      if (appSettings.enabledGradeBadgeTypes.contains(GradeBadgeTypes.pta) &&
          grade.cijferKolom.isPtaKolom == true)
        const Badge(label: Text("PTA")),
      if (grade.isArchived) const Badge(label: Text("Gearchiveerd")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: (grade.isEnabled && !grade.isArchived) ? 1 : .5,
      child: ListTile(
        onTap: () => showScrollableModalBottomSheet(
          context: context,
          builder: (p0, p1, scrollcontroller) =>
              ListView(controller: scrollcontroller, children: [
            (grade.cijferKolom.kolomSoort == 1)
                ? GradeInformation(
                    grade: grade,
                    setStateTop: setStateTop,
                  )
                : GradesInAverageDetailsView(grade: grade)
          ]),
        ),
        title: Text(
          grade.subject.value?.naam.capitalized ?? "",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: (grade.cijferKolom.kolomSoort == 1 || isAverage)
            ? Text(
                grade.description ?? grade.ingevoerdDoor ?? grade.docent ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : Text(grade.datumIngevoerd?.formattedDate ?? ""),
        leading: (grade.cijferKolom.kolomSoort == 1 || isAverage)
            ? GradeAvatar(
                heroTag: grade.id,
                gradeString: grade.cijferStr,
                badge: (grade.weight != null &&
                        appSettings.enabledGradeBadgeTypes
                            .contains(GradeBadgeTypes.weight))
                    ? "${grade.weight!.displayNumber()}x"
                    : null,
              )
            : null,
        trailing: (grade.cijferKolom.kolomSoort == 1 || isAverage)
            ? Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.end,
                spacing: 8,
                runSpacing: 10,
                children: _buildBadges(),
              )
            : GradeAvatar(gradeString: grade.cijferStr),
      ),
    );
  }
}

class GradeTileExample extends GradeTile {
  const GradeTileExample({super.key, required super.grade});

  @override
  List<Widget> _buildBadges() {
    return [
      // Change in average
      if (appSettings.enabledGradeBadgeTypes.contains(GradeBadgeTypes.change))
        Badge(label: Text(0.10.displayNumber())),

      // Change in global average
      if (appSettings.enabledGradeBadgeTypes
          .contains(GradeBadgeTypes.globalChange))
        Badge(label: Text(0.12.displayNumber())),

      // Date
      if (appSettings.enabledGradeBadgeTypes.contains(GradeBadgeTypes.date) &&
          grade.datumIngevoerd != null)
        Badge(label: Text(grade.datumIngevoerd!.formattedDate)),

      // PTA indicator
      if (appSettings.enabledGradeBadgeTypes.contains(GradeBadgeTypes.pta) &&
          grade.cijferKolom.isPtaKolom == true)
        const Badge(label: Text("PTA")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        "Nederlandse taal",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: const Text(
        "Literatuur: verwerkingsopdracht",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      leading: GradeAvatar(
        heroTag: grade.id,
        gradeString: grade.cijferStr,
        badge: (grade.weight != null &&
                appSettings.enabledGradeBadgeTypes
                    .contains(GradeBadgeTypes.weight))
            ? "${grade.weight!.displayNumber()}x"
            : null,
      ),
      trailing: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 8,
        runSpacing: 10,
        children: _buildBadges(),
      ),
    );
  }
}

class GradeAvatar extends StatelessWidget {
  const GradeAvatar({
    super.key,
    required this.gradeString,
    this.isSufficient,
    this.enableAnimatedSwitcher = false,
    this.badge,
    this.decimalDigits,
    this.heroTag,
    this.radius,
  });

  final String? gradeString;
  final bool? isSufficient;
  final bool enableAnimatedSwitcher;
  final int? decimalDigits;
  final String? badge;
  final double? radius;

  /// Is used for the hero animation, but can be left null
  final int? heroTag;

  @override
  Widget build(BuildContext context) {
    double? grade = double.tryParse((gradeString ?? "-").replaceAll(',', '.'));

    bool finaliIsSufficient = (grade == null || grade.isNaN)
        ? (isSufficient ?? true)
        : num.parse(grade.toStringAsFixed(decimalDigits ?? 2)) >=
            appSettings.sufficientFrom;
    Color containerColor = !finaliIsSufficient
        ? Theme.of(context).colorScheme.errorContainer
        : Theme.of(context).colorScheme.primaryContainer;
    Color onContainerColor = !finaliIsSufficient
        ? Theme.of(context).colorScheme.onErrorContainer
        : Theme.of(context).colorScheme.onPrimaryContainer;
    String displayedGrade =
        grade?.displayNumber(decimalDigits: decimalDigits) ??
            (gradeString == "null" ? null : gradeString) ??
            "-";

    return ElasticAnimation(
      isEnabled: enableAnimatedSwitcher,
      child: Hero(
        tag: heroTag ?? hashCode,
        child: Badge(
          backgroundColor: containerColor,
          alignment: Alignment.centerRight,
          offset: Offset(-(badge?.length.toDouble() ?? 0) * 2, 7),
          textColor: onContainerColor,
          isLabelVisible: badge != null,
          label: badge != null
              ? Text(
                  badge!,
                  textAlign: TextAlign.end,
                  textDirection: TextDirection.rtl,
                )
              : null,
          key: ValueKey<String>(displayedGrade),
          child: CircleAvatar(
            backgroundColor: containerColor,
            radius: radius ?? 25,
            child: DefaultTextStyle.merge(
              style: TextStyle(
                fontSize: radius != null ? radius! * 0.60 : null,
                color: onContainerColor,
              ),
              child: Text(
                displayedGrade,
                style: !finaliIsSufficient
                    ? TextStyle(color: onContainerColor)
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RevealGradeAvatar extends StatefulWidget {
  const RevealGradeAvatar({
    super.key,
    required this.gradeString,
    this.isSufficient,
    this.enableAnimatedSwitcher = false,
    this.badge,
    this.decimalDigits,
    this.heroTag,
    this.radius,
  });

  final String? gradeString;
  final bool? isSufficient;
  final bool enableAnimatedSwitcher;
  final int? decimalDigits;
  final String? badge;
  final double? radius;

  /// Is used for the hero animation, but can be left null
  final int? heroTag;

  @override
  State<RevealGradeAvatar> createState() => _RevealGradeAvatarState();
}

class _RevealGradeAvatarState extends State<RevealGradeAvatar>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _morphController;
  late final Animation<double> _morphAnimation;
  late final Animation<double> _tickerAnimation;
  late final Animation<double> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    );
    _morphController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _morphAnimation = CurvedAnimation(
      parent: _morphController,
      curve: const Interval(0.0, 0.4, curve: Easing.standard),
    );
    _tickerAnimation = CurvedAnimation(
      parent: _morphController,
      curve: Curves.easeOutExpo,
    );
    _colorAnimation = CurvedAnimation(
      parent: _morphController,
      curve: const Interval(0.8, 1.0, curve: Easing.standard),
    );

    if (widget.gradeString == "?") {
      _rotationController.repeat();
      _morphController.value = 0.0;
    } else {
      _morphController.value = 1.0;
    }
  }

  List<int> generateCurvedNumbers({
    required int start,
    required int end,
    required int count,
    required Curve curve,
  }) {
    if (count <= 0) return [];
    if (count == 1) return [start];

    final List<int> numbers = [];
    final tween = Tween<int>(begin: start, end: end);

    for (int i = 0; i < count; i++) {
      // Calculate the linear progress (0.0 to 1.0)
      double linearProgress = i / (count - 1);

      // Apply the Flutter Curve to the progress
      double curvedProgress = curve.transform(linearProgress);

      // Interpolate the value based on the curved progress
      int value = tween.transform(curvedProgress);

      numbers.add(value);
    }

    return numbers;
  }

  Future<void> _playHapticRevealPattern() async {
    try {
      await Vibration.cancel();
      if (Platform.isAndroid) {
        await Vibration.vibrateWaveform(
          timings: const [
            // Phase 1: Continuous Smooth Launch (0 - 1200ms) - No pauses, smooth purr
            Duration.zero,
            Duration(milliseconds: 150),
            Duration(milliseconds: 150),
            Duration(milliseconds: 150),
            Duration(milliseconds: 150),
            Duration(milliseconds: 150),
            Duration(milliseconds: 150),
            Duration(milliseconds: 150),
            Duration(milliseconds: 150),
            // Phase 2: Decelerating Sparks (Apex Climb) - Distinct >100ms clicks
            Duration(milliseconds: 150), // Pause → Tick 1 at 1350ms
            Duration(milliseconds: 10), // Tick 1
            Duration(milliseconds: 240), // Pause → Tick 2 at 1600ms (color starts changing)
            Duration(milliseconds: 10), // Tick 2
            Duration(milliseconds: 390), // Pause → Pop at 2000ms (color fully revealed)
            // Phase 3: The Explosion (Apex Pop) - Gentle 150 amplitude pop
            Duration(milliseconds: 40),
          ],
          amplitudes: const [
            0,
            2, // Purr start (barely there)
            3,
            4,
            6,
            9,
            14,
            20,
            30, // Peak — exponential surge
            0,
            35, // Click 1
            0,
            15, // Click 2
            0,
            40, // Gentle pop
          ],
        );
      } else {
        await HapticPattern.builder()
            // Phase 1: Continuous Smooth Launch (0 - 1200ms) - No pauses, smooth purr
            .continuous(
                duration: const Duration(milliseconds: 150),
                intensity: 0.10,
                sharpness: 0.2)
            .continuous(
                duration: const Duration(milliseconds: 150),
                intensity: 0.15,
                sharpness: 0.3)
            .continuous(
                duration: const Duration(milliseconds: 150),
                intensity: 0.22,
                sharpness: 0.4)
            .continuous(
                duration: const Duration(milliseconds: 150),
                intensity: 0.30,
                sharpness: 0.5)
            .continuous(
                duration: const Duration(milliseconds: 150),
                intensity: 0.38,
                sharpness: 0.6)
            .continuous(
                duration: const Duration(milliseconds: 150),
                intensity: 0.46,
                sharpness: 0.7)
            .continuous(
                duration: const Duration(milliseconds: 150),
                intensity: 0.54,
                sharpness: 0.8)
            .continuous(
                duration: const Duration(milliseconds: 150),
                intensity: 0.60,
                sharpness: 0.9)
            // Phase 2: Decelerating Sparks (Apex Climb) - Distinct >100ms clicks
            .pause(const Duration(milliseconds: 150)) // Tick 1 at 1350ms
            .tap(intensity: 0.35, sharpness: 0.5)
            .pause(const Duration(milliseconds: 240)) // Tick 2 at 1600ms (color starts changing)
            .tap(intensity: 0.15, sharpness: 0.3)
            .pause(const Duration(milliseconds: 390)) // Pop at 2000ms (color fully revealed)
            // Phase 3: The Explosion (Apex Pop) - Gentle 150 amplitude pop
            .continuous(
              duration: const Duration(milliseconds: 80),
              intensity: 0.60,
              sharpness: 0.6,
            )
            .play();
      }
    } catch (_) {
      // Fallback for older devices/simulators
      try {
        await Vibration.vibrate(duration: const Duration(milliseconds: 150));
      } catch (_) {}
    }
  }

  @override
  void didUpdateWidget(RevealGradeAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.gradeString == "?" && widget.gradeString != "?") {
      _morphController.forward(from: 0.0);
      _rotationController.stop();
      _playHapticRevealPattern();
    } else if (oldWidget.gradeString != "?" && widget.gradeString == "?") {
      _morphController.reverse(from: 1.0);
      _rotationController.repeat();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _morphController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double? grade =
        double.tryParse((widget.gradeString ?? "-").replaceAll(',', '.'));

    bool finaliIsSufficient = (grade == null || grade.isNaN)
        ? (widget.isSufficient ?? true)
        : num.parse(grade.toStringAsFixed(widget.decimalDigits ?? 2)) >=
            appSettings.sufficientFrom;

    final double avatarRadius = widget.radius ?? 25;
    final double diameter = avatarRadius * 2;

    return ElasticAnimation(
      isEnabled: widget.enableAnimatedSwitcher,
      child: Hero(
        tag: widget.heroTag ?? hashCode,
        child: AnimatedBuilder(
          animation: Listenable.merge([_rotationController, _morphController]),
          builder: (context, child) {
            final double progress = _morphAnimation.value;
            final double rotationAngle = _rotationController.value * 2 * pi;

            Color startContainerColor =
                Theme.of(context).colorScheme.tertiaryContainer;
            Color startOnContainerColor =
                Theme.of(context).colorScheme.onTertiaryContainer;

            Color finalContainerColor = !finaliIsSufficient
                ? Theme.of(context).colorScheme.errorContainer
                : Theme.of(context).colorScheme.primaryContainer;
            Color finalOnContainerColor = !finaliIsSufficient
                ? Theme.of(context).colorScheme.onErrorContainer
                : Theme.of(context).colorScheme.onPrimaryContainer;

            final double colorProgress = _colorAnimation.value;

            Color containerColor = Color.lerp(
                    startContainerColor, finalContainerColor, colorProgress) ??
                finalContainerColor;
            Color onContainerColor = Color.lerp(startOnContainerColor,
                    finalOnContainerColor, colorProgress) ??
                finalOnContainerColor;

            String displayedGrade;
            if (grade == null || grade.isNaN) {
              displayedGrade =
                  (widget.gradeString == "null" ? null : widget.gradeString) ??
                      "-";
            } else {
              if (progress == 0.0 && widget.gradeString == "?") {
                displayedGrade = "?";
              } else {
                final double tickerProgress = _tickerAnimation.value;
                displayedGrade = (tickerProgress * grade)
                    .displayNumber(decimalDigits: widget.decimalDigits);
              }
            }

            return Badge(
              alignment: Alignment.centerRight,
              offset: Offset(-(widget.badge?.length.toDouble() ?? 0) * 2, 7),
              textColor: onContainerColor,
              isLabelVisible: widget.badge != null,
              label: widget.badge != null
                  ? Text(
                      widget.badge!,
                      textAlign: TextAlign.end,
                      textDirection: TextDirection.rtl,
                    )
                  : null,
              key: ValueKey<String>(displayedGrade),
              child: SizedBox(
                width: diameter,
                height: diameter,
                child: ClipPath(
                  clipper: MorphClipper(progress, rotationAngle),
                  child: Container(
                    color: containerColor,
                    alignment: Alignment.center,
                    child: DefaultTextStyle.merge(
                      style: TextStyle(
                        fontSize: widget.radius != null
                            ? widget.radius! * 0.60
                            : null,
                        color: onContainerColor,
                        fontWeight: FontWeight.bold,
                      ),
                      child: Text(
                        displayedGrade,
                        style: !finaliIsSufficient
                            ? TextStyle(color: onContainerColor)
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MorphClipper extends CustomClipper<Path> {
  final double progress;
  final double rotationAngle;

  MorphClipper(this.progress, this.rotationAngle);

  @override
  Path getClip(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 2;
    final path = Path();

    final double rOut = maxRadius;
    final double rIn = maxRadius * (0.72 + 0.28 * progress);

    const int pointsCount = 16;
    final List<Offset> points = [];
    for (int i = 0; i < pointsCount; i++) {
      final double angle = rotationAngle + (i * 2 * pi / pointsCount);
      final double r = (i % 2 == 0) ? rOut : rIn;
      points.add(Offset(
        center.dx + r * cos(angle),
        center.dy + r * sin(angle),
      ));
    }

    path.moveTo((points[0].dx + points[pointsCount - 1].dx) / 2,
        (points[0].dy + points[pointsCount - 1].dy) / 2);
    for (int i = 0; i < pointsCount; i++) {
      final pCurrent = points[i];
      final pNext = points[(i + 1) % pointsCount];
      final xMid = (pCurrent.dx + pNext.dx) / 2;
      final yMid = (pCurrent.dy + pNext.dy) / 2;
      path.quadraticBezierTo(pCurrent.dx, pCurrent.dy, xMid, yMid);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant MorphClipper oldClipper) {
    return oldClipper.progress != progress ||
        oldClipper.rotationAngle != rotationAngle;
  }
}
