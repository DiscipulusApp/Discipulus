import 'dart:math';
import 'package:collection/collection.dart';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/grades/widgets/calculator/grade_calculator_models.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

class GradeToAverageCalculatorCard extends StatefulWidget {
  final QueryBuilder<Grade, Grade, QAfterFilterCondition>? grades;
  final int? ignoredGradeUUID;
  final double? initialGrade;
  final double? initialWeight;
  final void Function(List<DummyGrade> grades, double? average)? onResult;

  const GradeToAverageCalculatorCard({
    super.key,
    this.grades,
    this.ignoredGradeUUID,
    this.initialGrade,
    this.initialWeight,
    this.onResult,
  });

  @override
  State<GradeToAverageCalculatorCard> createState() =>
      _GradeToAverageCalculatorCardState();
}

class _GradeToAverageCalculatorCardState
    extends State<GradeToAverageCalculatorCard> {
  final List<CalculatorGradeEntry> _entries = [];

  double _baseSum = 0.0;
  double _baseWeight = 0.0;
  double? _standardDeviation;

  @override
  void initState() {
    super.initState();

    // Start with initial row
    _entries.add(CalculatorGradeEntry(
      initialGrade: widget.initialGrade?.displayNumber() ?? '',
      initialWeight: widget.initialWeight?.displayNumber() ?? '',
      isEnabled: true,
    ));

    // If initial row has content, add ghost row right away
    if (_entries.first.hasContent) {
      _entries.add(CalculatorGradeEntry(
        initialGrade: '',
        initialWeight: '',
        isEnabled: true,
      ));
    }

    _loadBaseGrades();
  }

  @override
  void didUpdateWidget(covariant GradeToAverageCalculatorCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.grades != widget.grades ||
        oldWidget.ignoredGradeUUID != widget.ignoredGradeUUID) {
      _loadBaseGrades();
    }
  }

  Future<void> _loadBaseGrades() async {
    if (widget.grades == null) {
      // Demo / fallback state
      const double baseAvg = 6.4;
      const double baseWgt = 8.0;
      _baseSum = baseAvg * baseWgt;
      _baseWeight = baseWgt;
      _standardDeviation = 1.15;
      if (mounted) setState(() {});
      _triggerResultCallback();
      return;
    }

    try {
      final gradesList = await widget.grades!
          .optional(widget.ignoredGradeUUID != null,
              (q) => q.not().uuidEqualTo(widget.ignoredGradeUUID!))
          .numericalGrades
          .findAll();

      double sum = 0.0;
      double weightSum = 0.0;
      for (final g in gradesList) {
        final w = g.weight ?? 1.0;
        sum += g.grade * w;
        weightSum += w;
      }

      _baseSum = sum;
      _baseWeight = weightSum;

      // Calculate standard deviation for Cohen's d
      final numericalValues = gradesList
          .map((g) => g.grade)
          .where((v) => v >= 0 && v <= 10)
          .toList();

      if (numericalValues.length >= 2) {
        final mean = numericalValues.sum / numericalValues.length;
        final variance = numericalValues.map((v) => pow(v - mean, 2)).sum /
            numericalValues.length;
        _standardDeviation = sqrt(variance);
      } else {
        _standardDeviation = null;
      }
    } catch (_) {
      _baseSum = 6.4 * 8.0;
      _baseWeight = 8.0;
      _standardDeviation = null;
    }

    if (mounted) {
      setState(() {});
      _triggerResultCallback();
    }
  }

  CalculatorResult? get _calculationResult {
    return GradeCalculatorMath.calculateNewAverage(
      currentSum: _baseSum,
      currentWeight: _baseWeight,
      entries: _entries,
      standardDeviation: _standardDeviation,
    );
  }

  List<DummyGrade> get _allEnabledGrades {
    final list = <DummyGrade>[];
    for (final e in _entries) {
      if (e.isEnabled && e.isValid) {
        list.add(DummyGrade(grade: e.grade!, weight: e.weight!));
      }
    }
    return list;
  }

  /// Ensures that when there is at most one grade with content in the entries,
  /// that entry is never disabled (even if it was disabled previously).
  void _ensureSingleEntryEnabled() {
    final contentEntries = _entries.where((e) => e.hasContent).toList();
    if (contentEntries.length <= 1) {
      for (final e in _entries) {
        if (!e.isEnabled) {
          e.isEnabled = true;
        }
      }
    }
  }

  void _triggerResultCallback() {
    _ensureSingleEntryEnabled();
    final result = _calculationResult;
    final all = _allEnabledGrades;

    widget.onResult?.call(all, result?.value);
  }

  /// Ghost row management: ensure exactly one trailing empty row exists if the last active row has input.
  void _onEntryChanged(int index) {
    final entry = _entries[index];

    // If user typed into the last entry, add a new ghost entry
    if (index == _entries.length - 1 && entry.hasContent) {
      _entries.add(CalculatorGradeEntry(
        initialGrade: '',
        initialWeight: '',
        isEnabled: true,
      ));
    } else {
      // Clean up multiple trailing empty entries if any
      while (_entries.length > 1 &&
          !_entries.last.hasContent &&
          !_entries[_entries.length - 2].hasContent) {
        final removed = _entries.removeLast();
        removed.dispose();
      }
    }

    _ensureSingleEntryEnabled();

    setState(() {});
    _triggerResultCallback();
    HapticFeedback.selectionClick();
  }

  void _toggleEntryEnabled(int index) {
    final entry = _entries[index];
    // Ghost row can't be toggled until it has content
    final isGhost = index == _entries.length - 1 && !entry.hasContent;
    if (isGhost) return;

    final contentCount = _entries.where((e) => e.hasContent).length;
    // When there is only one grade with content in the entries, it can never be disabled
    if (contentCount <= 1) {
      if (!entry.isEnabled) {
        setState(() => entry.isEnabled = true);
        _triggerResultCallback();
      }
      return;
    }

    setState(() {
      entry.isEnabled = !entry.isEnabled;
    });
    _triggerResultCallback();
  }

  @override
  void dispose() {
    for (final entry in _entries) {
      entry.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _ensureSingleEntryEnabled();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final result = _calculationResult;

    return Card(
      elevation: 1,
      surfaceTintColor: colorScheme.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.all(Radius.circular(16))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomCard(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: CustomAnimatedSize(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 8,
                  children: [
                    ..._entries.asMap().entries.map((item) {
                      final index = item.key;
                      final entry = item.value;
                      final isGhost =
                          index == _entries.length - 1 && !entry.hasContent;
          
                      return _buildGradeRow(
                        context: context,
                        index: index,
                        entry: entry,
                        isGhost: isGhost,
                        theme: theme,
                        colorScheme: colorScheme,
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _buildBottomShelf(theme, colorScheme, result),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeRow({
    required BuildContext context,
    required int index,
    required CalculatorGradeEntry entry,
    required bool isGhost,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    final double opacity =
        isGhost && index != 0 ? 0.5 : (entry.isEnabled ? 1.0 : 0.45);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: opacity,
      child: Row(
        key: entry.key,
        children: [
          Expanded(
            flex: 3,
            child: CustomCard(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: TextField(
                controller: entry.gradeController,
                focusNode: entry.gradeFocusNode,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  decoration: (!(entry.isEnabled) && !isGhost)
                      ? TextDecoration.lineThrough
                      : null,
                ),
                decoration: InputDecoration(
                  hintText: "Cijfer",
                  hintStyle: TextStyle(
                      color: context.cs.onSurface.withValues(alpha: .4)),
                  border: InputBorder.none,
                  icon: const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Icon(Icons.numbers),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                onChanged: (_) => _onEntryChanged(index),
              ),
            ),
          ),

          SizedBox(width: 4),

          Expanded(
            flex: 2,
            child: CustomCard(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              child: TextField(
                controller: entry.weightController,
                focusNode: entry.weightFocusNode,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.done,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Weging",
                  border: InputBorder.none,
                  // suffixIcon: const Padding(
                  //   padding: EdgeInsets.only(right: 8),
                  //   child: Icon(Icons.balance_outlined),
                  // ),
                  hintStyle: TextStyle(
                      color: context.cs.onSurface.withValues(alpha: .4)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                onChanged: (_) => _onEntryChanged(index),
              ),
            ),
          ),

          if (_entries.where((e) => e.hasContent).length >= 2)
            const SizedBox(width: 8),

          // Checkmark button
          CustomAnimatedSize(
            alignment: Alignment.centerLeft,
            visible: _entries.where((e) => e.hasContent).length >= 2,
            child: SizedBox(
              width: 44,
              height: 44,
              child: entry.isEnabled
                  ? FilledButton(
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      onPressed:
                          isGhost ? null : () => _toggleEntryEnabled(index),
                      child: const Icon(Icons.check, size: 20),
                    )
                  : OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () => _toggleEntryEnabled(index),
                      child: Icon(
                        Icons.check,
                        size: 20,
                        color: colorScheme.outline,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomShelf(
    ThemeData theme,
    ColorScheme colorScheme,
    CalculatorResult? result,
  ) {
    final bool isPositive = result != null ? result.change > 0.001 : false;
    final bool isNegative = result != null ? result.change < -0.001 : false;
    final Color changeColor = result != null
        ? isPositive
            ? colorScheme.primary
            : (isNegative ? colorScheme.error : colorScheme.onSurfaceVariant)
        : colorScheme.onSurfaceVariant;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (result != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ElasticAnimation(
                  child: Icon(
                    key: ValueKey("change_TA_i$isNegative$isPositive"),
                    isNegative
                        ? Icons.trending_down
                        : (isPositive
                            ? Icons.trending_up
                            : Icons.trending_flat),
                    color: changeColor,
                    size: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              ElasticAnimation(
                child: Text(
                  key: ValueKey("change_TA_${result.change}"),
                  '${result.change >= 0 ? '+' : ''}${result.change.displayNumber(decimalDigits: 2)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: changeColor,
                  ),
                ),
              ),
            ] else ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Wat ga ik staan?",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.8,
                   
                  ),
                ),
              )
            ],
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Nieuw gemiddelde',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                ElasticAnimation(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    key: ValueKey("value_TA_${result?.value}"),
                    result != null
                        ? result.value.displayNumber(decimalDigits: 2)
                        : "-",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                      color: result != null
                          ? (result.value < 5.5)
                              ? colorScheme.error
                              : colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Cohen's d Effect Size badge/pill (if standard deviation is available)
        // if (result.cohenD != null) ...[
        //   const SizedBox(height: 6),
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       Tooltip(
        //         message:
        //             'Cohen\'s d meet de relatieve impact van het cijfer ten opzichte van de standaardafwijking (${_standardDeviation?.displayNumber(decimalDigits: 2)}).',
        //         child: Container(
        //           padding:
        //               const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        //           decoration: BoxDecoration(
        //             color:
        //                 colorScheme.secondaryContainer.withValues(alpha: 0.6),
        //             borderRadius: BorderRadius.circular(12),
        //           ),
        //           child: Row(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               Icon(
        //                 Icons.analytics_outlined,
        //                 size: 14,
        //                 color: colorScheme.onSecondaryContainer,
        //               ),
        //               const SizedBox(width: 4),
        //               Text(
        //                 'Cohen\'s d: ${result.cohenD! >= 0 ? '+' : ''}${result.cohenD!.displayNumber(decimalDigits: 2)} (${result.cohenDInterpretation})',
        //                 style: theme.textTheme.labelSmall?.copyWith(
        //                   color: colorScheme.onSecondaryContainer,
        //                   fontWeight: FontWeight.w600,
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ],
      ],
    );
  }
}
