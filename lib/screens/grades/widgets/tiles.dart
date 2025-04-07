import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/models/settings.dart';
import 'package:discipulus/screens/grades/grade_detail.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/calendar/ext_calendar.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/global/bottom_sheet.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:flutter/material.dart';

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
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: grade.isEnabled ? 1 : .5,
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
  });

  final String? gradeString;
  final bool? isSufficient;
  final bool enableAnimatedSwitcher;
  final int? decimalDigits;
  final String? badge;

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
            radius: 25,
            child: Text(
              displayedGrade,
              style: !finaliIsSufficient
                  ? TextStyle(color: onContainerColor)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
