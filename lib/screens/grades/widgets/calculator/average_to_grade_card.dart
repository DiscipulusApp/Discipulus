import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/screens/grades/grade_extensions.dart';
import 'package:discipulus/screens/grades/widgets/calculator/grade_calculator_models.dart';
import 'package:discipulus/screens/grades/widgets/calculator/multigrade_tradeoff_graph.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/animations/widgets.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/widgets/global/list_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

class AverageToGradeCalculatorCard extends StatefulWidget {
  final QueryBuilder<Grade, Grade, QAfterFilterCondition>? grades;
  final int? ignoredGradeUUID;
  final double? initialTargetAverage;
  final double? initialWeight;
  final void Function(List<DummyGrade> grades, double? average)? onResult;

  const AverageToGradeCalculatorCard({
    super.key,
    this.grades,
    this.ignoredGradeUUID,
    this.initialTargetAverage,
    this.initialWeight,
    this.onResult,
  });

  @override
  State<AverageToGradeCalculatorCard> createState() =>
      _AverageToGradeCalculatorCardState();
}

class _AverageToGradeCalculatorCardState
    extends State<AverageToGradeCalculatorCard> {
  late final TextEditingController _targetAverageController;
  late final TextEditingController _weight1Controller;
  late final TextEditingController _weight2Controller;

  bool _isAdvancedMode = false;
  bool _isAddStaticGradeMode = false;
  Offset? _inspectPoint;
  final List<StaticGradeEntry> _staticGrades = [];

  double _baseSum = 0.0;
  double _baseWeight = 0.0;

  @override
  void initState() {
    super.initState();
    _targetAverageController = TextEditingController(
      text: widget.initialTargetAverage?.displayNumber() ?? '',
    );
    _weight1Controller = TextEditingController(
      text: widget.initialWeight?.displayNumber() ?? '',
    );
    _weight2Controller = TextEditingController(text: '');

    _loadBaseGrades();
  }

  @override
  void didUpdateWidget(covariant AverageToGradeCalculatorCard oldWidget) {
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
    } catch (_) {
      _baseSum = 6.4 * 8.0;
      _baseWeight = 8.0;
    }

    if (mounted) {
      setState(() {});
      _triggerResultCallback();
    }
  }

  double? get _targetAverage =>
      double.tryParse(_targetAverageController.text.replaceAll(',', '.'));

  double? get _weight1 =>
      double.tryParse(_weight1Controller.text.replaceAll(',', '.'));

  double? get _weight2 =>
      double.tryParse(_weight2Controller.text.replaceAll(',', '.'));

  double get _effectiveBaseSum {
    double sum = _baseSum;
    for (final s in _staticGrades) {
      if (s.isValid) sum += s.grade! * s.weight!;
    }
    return sum;
  }

  double get _effectiveBaseWeight {
    double w = _baseWeight;
    for (final s in _staticGrades) {
      if (s.isValid) w += s.weight!;
    }
    return w;
  }

  double? get _calculatedRequiredGrade {
    final avg = _targetAverage;
    final w1 = _weight1;
    if (avg == null || w1 == null || w1 <= 0) return null;

    return GradeCalculatorMath.calculateRequiredGrade(
      targetAverage: avg,
      weight: w1,
      currentSum: _baseSum,
      currentWeight: _baseWeight,
      staticGrades: _staticGrades,
    );
  }

  List<DummyGrade> get _allHypotheticalGrades {
    final list = <DummyGrade>[];
    // 1. Static grades
    for (final s in _staticGrades) {
      if (s.isValid) {
        list.add(DummyGrade(grade: s.grade!, weight: s.weight!));
      }
    }
    // 2. Standard mode target grade
    if (!_isAdvancedMode) {
      final req = _calculatedRequiredGrade;
      final w1 = _weight1;
      if (req != null && w1 != null && w1 > 0) {
        list.add(DummyGrade(grade: req, weight: w1));
      }
    } else {
      // 3. Advanced mode graph
      final w1 = _weight1;
      final w2 = _weight2;
      if (_inspectPoint != null) {
        if (w1 != null && w1 > 0) {
          list.add(DummyGrade(grade: _inspectPoint!.dx, weight: w1));
        }
        if (w2 != null && w2 > 0) {
          list.add(DummyGrade(grade: _inspectPoint!.dy, weight: w2));
        }
      }
    }
    return list;
  }

  void _triggerResultCallback() {
    final all = _allHypotheticalGrades;
    final avg = _targetAverage;

    widget.onResult?.call(all, avg);
  }

  void _toggleAddStaticGradeMode() {
    setState(() {
      _isAddStaticGradeMode = !_isAddStaticGradeMode;
      if (_isAddStaticGradeMode) {
        if (_staticGrades.isEmpty) {
          _staticGrades.add(StaticGradeEntry(
            initialGrade: '',
            initialWeight: '',
          ));
        }
      } else {
        for (final s in _staticGrades) {
          s.dispose();
        }
        _staticGrades.clear();
      }
    });
    _triggerResultCallback();
    HapticFeedback.selectionClick();
  }

  void _onStaticEntryChanged(int index) {
    final entry = _staticGrades[index];

    // If user typed into the last entry, add a new ghost entry
    if (index == _staticGrades.length - 1 && entry.hasContent) {
      _staticGrades.add(StaticGradeEntry(
        initialGrade: '',
        initialWeight: '',
      ));
    } else {
      // Clean up multiple trailing empty entries if any
      while (_staticGrades.length > 1 &&
          !_staticGrades.last.hasContent &&
          !_staticGrades[_staticGrades.length - 2].hasContent) {
        final removed = _staticGrades.removeLast();
        removed.dispose();
      }
    }

    setState(() {});
    _triggerResultCallback();
    HapticFeedback.selectionClick();
  }

  @override
  void dispose() {
    _targetAverageController.dispose();
    _weight1Controller.dispose();
    _weight2Controller.dispose();
    for (final s in _staticGrades) {
      s.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final reqGrade = _calculatedRequiredGrade;

    // Linear tradeoff equation for Advanced mode
    final equation = LinearTradeoffEquation(
      w1: _weight1 ?? 1.0,
      w2: _weight2 ?? 1.0,
      targetAverage: _targetAverage ?? 0.0,
      baseSum: _effectiveBaseSum,
      baseWeight: _effectiveBaseWeight,
    );

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
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: CustomCard(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.only(
                                topRight:
                                    Radius.circular(_isAdvancedMode ? 8 : 4),
                                bottomRight: Radius.circular(4),
                                topLeft: Radius.circular(8),
                                bottomLeft:
                                    Radius.circular(_isAdvancedMode ? 4 : 8),
                              ),
                            ),
                            child: TextField(
                              controller: _targetAverageController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              textInputAction: TextInputAction.next,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                hintText: "Gemiddelde",
                                hintStyle: TextStyle(
                                  color: context.cs.onSurface
                                      .withValues(alpha: .4),
                                ),
                                border: InputBorder.none,
                                icon: const Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Icon(Icons.show_chart_rounded),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                              ),
                              onChanged: (_) {
                                setState(() {});
                                _triggerResultCallback();
                                HapticFeedback.selectionClick();
                              },
                            ),
                          ),
                        ),
          
                        if (!_isAdvancedMode) SizedBox(width: 4),
          
                        // Weight
                        CustomAnimatedSize(
                          visible: !_isAdvancedMode,
                          alignment: Alignment.centerLeft,
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
                            child: SizedBox(
                              width: 100,
                              child: TextField(
                                controller: _weight1Controller,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                textInputAction: TextInputAction.done,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText: "Weging",
                                  hintStyle: TextStyle(
                                    color: context.cs.onSurface
                                        .withValues(alpha: .4),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                ),
                                onChanged: (_) {
                                  setState(() {});
                                  _triggerResultCallback();
                                  HapticFeedback.selectionClick();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
          
                    SizedBox(height: 4),
          
                    CustomAnimatedSize(
                      alignment: Alignment.topCenter,
                      visible: _isAdvancedMode,
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomCard(
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.only(
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              child: SizedBox(
                                width: 120,
                                child: TextField(
                                  controller: _weight1Controller,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: 'Weging 1 (X)',
                                    hintStyle: TextStyle(
                                      color: context.cs.onSurface
                                          .withValues(alpha: .4),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                  ),
                                  onChanged: (_) {
                                    setState(() {});
                                    _triggerResultCallback();
                                    HapticFeedback.selectionClick();
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: CustomCard(
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.only(
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(8),
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                ),
                              ),
                              child: SizedBox(
                                width: 120,
                                child: TextField(
                                  controller: _weight2Controller,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  textInputAction: TextInputAction.done,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: 'Weging 2 (Y)',
                                    hintStyle: TextStyle(
                                      color: context.cs.onSurface
                                          .withValues(alpha: .4),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                  ),
                                  onChanged: (_) {
                                    setState(() {});
                                    _triggerResultCallback();
                                    HapticFeedback.selectionClick();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
          
                    if (_isAdvancedMode) SizedBox(height: 8),
          
                    // Geavanceerde modus & Cijfer toevoegen
                    Row(
                      children: [
                        Expanded(
                          child: _isAdvancedMode
                              ? FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () =>
                                      setState(() => _isAdvancedMode = false),
                                  icon: const Icon(Icons.check),
                                  label: const Text(
                                    'Geavanceerde modus',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              : FilledButton.tonalIcon(
                                  onPressed: () =>
                                      setState(() => _isAdvancedMode = true),
                                  icon: const Icon(Icons.tune),
                                  label: const Text(
                                    'Geavanceerde modus',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _isAddStaticGradeMode
                              ? FilledButton.icon(
                                  style: FilledButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: _toggleAddStaticGradeMode,
                                  icon: const Icon(Icons.check),
                                  label: const Text(
                                    'Cijfer toevoegen',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              : FilledButton.tonalIcon(
                                  onPressed: _toggleAddStaticGradeMode,
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text(
                                    'Cijfer toevoegen',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                        ),
                      ],
                    ),
          
                    // Static Grades List (appears underneath buttons)
                    if (_isAddStaticGradeMode && _staticGrades.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                          spacing: 8,
                          children: [
                            ..._staticGrades.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              final isGhost =
                                  index == _staticGrades.length - 1 &&
                                      !item.hasContent;
                        
                              return AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: isGhost ? 0.5 : 1.0,
                                child: Row(
                                  key: item.key,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: CustomCard(
                                        margin: EdgeInsets.zero,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadiusGeometry.only(
                                            topRight: Radius.circular(4),
                                            bottomRight: Radius.circular(4),
                                            topLeft: Radius.circular(8),
                                            bottomLeft: Radius.circular(8),
                                          ),
                                        ),
                                        child: TextField(
                                          controller: item.gradeController,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          textInputAction: TextInputAction.next,
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Cijfer",
                                            hintStyle: TextStyle(
                                              color: context.cs.onSurface
                                                  .withValues(alpha: .4),
                                            ),
                                            border: InputBorder.none,
                                            icon: const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 16),
                                              child: Icon(Icons.numbers),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8),
                                          ),
                                          onChanged: (_) =>
                                              _onStaticEntryChanged(index),
                                        ),
                                      ),
                                    ),
                        
                                    const SizedBox(width: 4),
                        
                                    Expanded(
                                      flex: 2,
                                      child: CustomCard(
                                        margin: EdgeInsets.zero,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadiusGeometry.only(
                                            topRight: Radius.circular(8),
                                            bottomRight: Radius.circular(8),
                                            topLeft: Radius.circular(4),
                                            bottomLeft: Radius.circular(4),
                                          ),
                                        ),
                                        child: TextField(
                                          controller: item.weightController,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          textInputAction: TextInputAction.done,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            hintText: "Weging",
                                            border: InputBorder.none,
                                            hintStyle: TextStyle(
                                              color: context.cs.onSurface
                                                  .withValues(alpha: .4),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 8),
                                          ),
                                          onChanged: (_) =>
                                              _onStaticEntryChanged(index),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Graph
          CustomAnimatedSize(
            visible: _isAdvancedMode,
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(12).copyWith(bottom: 0),
              child: MultigradeTradeoffGraph(
                equation: equation,
                height: 250,
                onSelectedPoint: (pt) {
                  setState(() => _inspectPoint = pt);
                  _triggerResultCallback();
                },
              ),
            ),
          ),

          if (!_isAdvancedMode)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _buildStandardBottomShelf(theme, colorScheme, reqGrade),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildAdvancedBottomShelf(theme, colorScheme),
            ),
        ],
      ),
    );
  }

  Widget _buildStandardBottomShelf(
    ThemeData theme,
    ColorScheme colorScheme,
    double? reqGrade,
  ) {
    final isNegativeOrHigh =
        reqGrade != null && (reqGrade < 1.0 || reqGrade > 10.0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Wat moet ik halen?",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
            ),
          ),
        ),

        const Spacer(),
        // Result
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Benodigd cijfer',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            ElasticAnimation(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                key: ValueKey("req_grade_$reqGrade"),
                reqGrade != null
                    ? reqGrade.displayNumber(decimalDigits: 1)
                    : "-",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                  color: reqGrade != null
                      ? (isNegativeOrHigh
                          ? colorScheme.error
                          : colorScheme.primary)
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdvancedBottomShelf(
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 12, vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Pas de wegingen aan om de haalbare cijfercombinaties in de grafiek te zien.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
