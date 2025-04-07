import 'package:discipulus/api/models/grades.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'dart:math';

class SufficientGradesCard extends StatefulWidget {
  const SufficientGradesCard({super.key, required this.grades});

  final QueryBuilder<Grade, Grade, QAfterFilterCondition> grades;

  @override
  State<SufficientGradesCard> createState() => _SufficientGradesCardState();
}

class _FutureResult {
  int sufficient = 0;
  int insufficient = 0;
  int total = 0;

  _FutureResult({
    required this.sufficient,
    required this.insufficient,
    required this.total,
  });
}

class _SufficientGradesCardState extends State<SufficientGradesCard> {
  // --- Configuration ---
  // Radius for the corners of the entire card
  final double _cardBorderRadius = 8.0;
  // Width of the transparent separator between bars
  final double _separatorWidth = 4.0;
  // Height of the card
  final double _cardHeight = 80.0;
  // Minimum percentage of the total flex allocated to a non-zero bar
  // e.g., 0.15 means even a bar representing 1 out of 1000 will get
  // at least the visual space equivalent to 15% of the total count.
  final double _minBarFlexPercentage = 0.15;
  // Absolute minimum flex value to prevent division by zero or tiny values if total is small
  final int _absoluteMinFlex = 1;
  // --- End Configuration ---

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_FutureResult>(
      future: Future(() async {
        final allGrades = await widget.grades.count();
        final sufficientGrades =
            await widget.grades.isVoldoendeEqualTo(true).count();

        int total = allGrades;
        int sufficient = sufficientGrades;
        int insufficient = total - sufficient;

        return _FutureResult(
          sufficient: sufficient,
          insufficient: insufficient,
          total: total,
        );
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: _cardHeight,
            child: const Center(
              child: CircularProgressIndicator(),
            ), // Or just SizedBox()
          );
        }
        if (snapshot.hasError) {
          return SizedBox(
            height: _cardHeight,
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return SizedBox(height: _cardHeight);
        }

        final result = snapshot.data!;
        final int sufficient = result.sufficient;
        final int insufficient = result.insufficient;
        final int total = result.total;

        if (total == 0) {
          return SizedBox(height: _cardHeight);
        }

        // Determine the minimum flex based on the percentage of the total count
        int minFlexFromTotal = (total * _minBarFlexPercentage)
            .round()
            .clamp(_absoluteMinFlex, total);

        // Assign flex, ensuring non-zero counts get at least the minimum flex
        int flexSufficient =
            (sufficient == 0) ? 0 : max(sufficient, minFlexFromTotal);

        int flexInsufficient =
            (insufficient == 0) ? 0 : max(insufficient, minFlexFromTotal);

        final bool showSeparator = flexSufficient > 0 && flexInsufficient > 0;

        return ClipRRect(
          borderRadius: BorderRadius.circular(_cardBorderRadius),
          child: SizedBox(
            height: _cardHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (flexSufficient > 0)
                        Expanded(
                          flex: flexSufficient,
                          child: Container(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      // Separator
                      if (showSeparator) SizedBox(width: _separatorWidth),
                      //
                      if (flexInsufficient > 0)
                        Expanded(
                          flex: flexInsufficient,
                          child: Container(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                    ],
                  ),
                ),

                // Text Overlay
                Positioned.fill(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (flexSufficient > 0)
                        Expanded(
                          flex: flexSufficient,
                          child: Center(
                            child: Text(
                              sufficient.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      if (flexInsufficient > 0)
                        Expanded(
                          flex: flexInsufficient,
                          child: Center(
                            child: Text(
                              insufficient.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onError,
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
