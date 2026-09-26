import 'package:flutter/material.dart';

/// Represents a single dynamic grade entry in "Grade to Average".
class CalculatorGradeEntry {
  final TextEditingController gradeController;
  final TextEditingController weightController;
  final FocusNode gradeFocusNode;
  final FocusNode weightFocusNode;
  final Key key;
  bool isEnabled;

  CalculatorGradeEntry({
    Key? key,
    String? initialGrade,
    String? initialWeight,
    this.isEnabled = true,
  })  : key = key ?? UniqueKey(),
        gradeController = TextEditingController(text: initialGrade ?? ''),
        weightController = TextEditingController(text: initialWeight ?? ''),
        gradeFocusNode = FocusNode(),
        weightFocusNode = FocusNode();

  double? get grade =>
      double.tryParse(gradeController.text.trim().replaceAll(',', '.'));

  double? get weight =>
      double.tryParse(weightController.text.trim().replaceAll(',', '.'));

  bool get hasContent =>
      gradeController.text.trim().isNotEmpty ||
      weightController.text.trim().isNotEmpty;

  bool get isValid =>
      grade != null && weight != null && weight! > 0;

  void dispose() {
    gradeController.dispose();
    weightController.dispose();
    gradeFocusNode.dispose();
    weightFocusNode.dispose();
  }
}

/// Represents a static (fixed) grade entry in "Average to Grade".
class StaticGradeEntry {
  final TextEditingController weightController;
  final TextEditingController gradeController;
  final Key key;

  StaticGradeEntry({
    Key? key,
    String? initialWeight,
    String? initialGrade,
  })  : key = key ?? UniqueKey(),
        weightController = TextEditingController(text: initialWeight ?? ''),
        gradeController = TextEditingController(text: initialGrade ?? '');

  double? get grade =>
      double.tryParse(gradeController.text.trim().replaceAll(',', '.'));

  double? get weight =>
      double.tryParse(weightController.text.trim().replaceAll(',', '.'));

  bool get hasContent =>
      gradeController.text.trim().isNotEmpty ||
      weightController.text.trim().isNotEmpty;

  bool get isValid =>
      grade != null && weight != null && weight! > 0;

  void dispose() {
    weightController.dispose();
    gradeController.dispose();
  }
}

/// Calculation result model.
class CalculatorResult {
  final double value;
  final double change;
  final double? cohenD;

  const CalculatorResult({
    required this.value,
    required this.change,
    this.cohenD,
  });

  /// Dutch descriptive interpretation of Cohen's d effect size.
  String? get cohenDInterpretation {
    if (cohenD == null) return null;
    final absD = cohenD!.abs();
    if (absD < 0.2) return 'verwaarloosbaar';
    if (absD < 0.5) return 'klein effect';
    if (absD < 0.8) return 'gemiddeld effect';
    return 'groot effect';
  }
}

/// Mathematics and helpers for grade calculations.
class GradeCalculatorMath {
  /// Solves for the needed grade to achieve [targetAverage] given target [weight],
  /// [currentSum], [currentWeight], and any [staticGrades].
  static double? calculateRequiredGrade({
    required double targetAverage,
    required double weight,
    required double currentSum,
    required double currentWeight,
    List<StaticGradeEntry> staticGrades = const [],
  }) {
    if (weight <= 0) return null;

    double effectiveSum = currentSum;
    double effectiveWeight = currentWeight;

    for (final s in staticGrades) {
      if (s.isValid) {
        effectiveSum += s.grade! * s.weight!;
        effectiveWeight += s.weight!;
      }
    }

    final totalWeight = effectiveWeight + weight;
    return ((totalWeight * targetAverage) - effectiveSum) / weight;
  }

  /// Calculates the new average given [currentSum], [currentWeight],
  /// and dynamic grade entries that are enabled.
  static CalculatorResult? calculateNewAverage({
    required double currentSum,
    required double currentWeight,
    required List<CalculatorGradeEntry> entries,
    double? standardDeviation,
  }) {
    double addedSum = 0;
    double addedWeight = 0;
    int validCount = 0;

    for (final e in entries) {
      if (e.isEnabled && e.isValid) {
        addedSum += e.grade! * e.weight!;
        addedWeight += e.weight!;
        validCount++;
      }
    }

    if (validCount == 0) return null;

    final baseAverage = currentWeight > 0 ? currentSum / currentWeight : 0.0;
    final totalWeight = currentWeight + addedWeight;
    if (totalWeight <= 0) return null;

    final newAverage = (currentSum + addedSum) / totalWeight;
    final change = newAverage - baseAverage;

    double? cohenD;
    if (standardDeviation != null && standardDeviation > 1e-6) {
      cohenD = change / standardDeviation;
    }

    return CalculatorResult(
      value: newAverage,
      change: change,
      cohenD: cohenD,
    );
  }

  /// Calculates Cohen's d effect size: (newAvg - oldAvg) / stdDev.
  static double? calculateCohenD({
    required double oldAverage,
    required double newAverage,
    required double? standardDeviation,
  }) {
    if (standardDeviation == null || standardDeviation < 1e-6) return null;
    return (newAverage - oldAverage) / standardDeviation;
  }
}

/// Trade-off model for 2D Multigrade mode (Linear Programming).
/// w1 * g1 + w2 * g2 = targetAverage * (W_base + w1 + w2) - S_base
class LinearTradeoffEquation {
  final double w1;
  final double w2;
  final double targetAverage;
  final double baseSum;
  final double baseWeight;

  LinearTradeoffEquation({
    required this.w1,
    required this.w2,
    required this.targetAverage,
    required this.baseSum,
    required this.baseWeight,
  });

  /// Total weight when both upcoming grades are included.
  double get totalWeight => baseWeight + w1 + w2;

  /// Required weighted sum: targetAverage * totalWeight - baseSum.
  double get requiredSum => (targetAverage * totalWeight) - baseSum;

  /// Whether inputs are valid to solve.
  bool get isValid => w1 > 0 && w2 > 0 && targetAverage > 0;

  /// Solves for grade 2 given grade 1: g2 = (K - w1 * g1) / w2.
  double? solveG2(double g1) {
    if (w2 <= 0) return null;
    return (requiredSum - (w1 * g1)) / w2;
  }

  /// Solves for grade 1 given grade 2: g1 = (K - w2 * g2) / w1.
  double? solveG1(double g2) {
    if (w1 <= 0) return null;
    return (requiredSum - (w2 * g2)) / w1;
  }

  /// Calculates resulting average for specific pair (g1, g2).
  double calculateAverage(double g1, double g2) {
    if (totalWeight <= 0) return 0;
    return (baseSum + (w1 * g1) + (w2 * g2)) / totalWeight;
  }

  /// True if achieving the target average is completely impossible with grades <= 10.
  bool get isImpossible => (10 * w1) + (10 * w2) < requiredSum;

  /// True if any pair of non-negative grades satisfies the target average (already achieved).
  bool get isTriviallySatisfied => requiredSum <= 0;

  /// Returns the polygon points of the feasible region within [0, maxGrade] x [0, maxGrade].
  List<Offset> computeFeasiblePolygon({double maxGrade = 10.0}) {
    if (!isValid) return [];
    if (isImpossible) return [];
    if (isTriviallySatisfied) {
      return [
        const Offset(0, 0),
        Offset(maxGrade, 0),
        Offset(maxGrade, maxGrade),
        Offset(0, maxGrade),
      ];
    }

    final List<Offset> points = [];

    // The boundary is w1 * g1 + w2 * g2 = requiredSum.
    // Feasible region is w1 * g1 + w2 * g2 >= requiredSum.
    // Since w1 > 0 and w2 > 0, the top-right corner (maxGrade, maxGrade) is always feasible.
    // We check intersections with the 4 bounding box edges:
    // Bottom: g2 = 0 => g1 = requiredSum / w1
    // Right: g1 = maxGrade => g2 = (requiredSum - w1 * maxGrade) / w2
    // Top: g2 = maxGrade => g1 = (requiredSum - w2 * maxGrade) / w1
    // Left: g1 = 0 => g2 = requiredSum / w2

    final g1AtBottom = requiredSum / w1;
    final g2AtRight = (requiredSum - (w1 * maxGrade)) / w2;
    final g1AtTop = (requiredSum - (w2 * maxGrade)) / w1;
    final g2AtLeft = requiredSum / w2;

    // Start from line entry into the box, trace boundary, then box corners to (maxGrade, maxGrade)
    if (g2AtLeft >= 0 && g2AtLeft <= maxGrade) {
      points.add(Offset(0, g2AtLeft));
    }

    if (g1AtBottom >= 0 && g1AtBottom <= maxGrade) {
      points.add(Offset(g1AtBottom, 0));
      // From bottom edge intersection, we include (maxGrade, 0)
      points.add(Offset(maxGrade, 0));
    }

    if (g2AtRight >= 0 && g2AtRight <= maxGrade) {
      if (!points.any((p) => (p.dx - maxGrade).abs() < 1e-4 && (p.dy - g2AtRight).abs() < 1e-4)) {
        points.add(Offset(maxGrade, g2AtRight));
      }
    }

    // Always include top-right corner
    points.add(Offset(maxGrade, maxGrade));

    if (g1AtTop >= 0 && g1AtTop <= maxGrade) {
      points.add(Offset(g1AtTop, maxGrade));
    } else if (g2AtLeft >= 0 && g2AtLeft <= maxGrade) {
      // If entered from left and exited through right/bottom, top-left is also feasible
      points.add(Offset(0, maxGrade));
    }

    return points;
  }
}
