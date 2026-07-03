import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/screens/grades/widgets/tiles.dart';
import 'package:discipulus/screens/grades/grade_detail.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/animations/text.dart';
import 'package:discipulus/widgets/global/card.dart';
import 'package:discipulus/main.dart';
import 'package:flutter/material.dart';

class GradeRevealDialog extends StatefulWidget {
  final List<Grade> grades;

  const GradeRevealDialog({super.key, required this.grades});

  @override
  State<GradeRevealDialog> createState() => _GradeRevealDialogState();
}

class _GradeRevealDialogState extends State<GradeRevealDialog> {
  late final PageController _pageController;
  late final List<GlobalKey<_RevealGradePageState>> _pageKeys;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageKeys = List.generate(
        widget.grades.length, (_) => GlobalKey<_RevealGradePageState>());
    _fillGrade(_currentPageIndex);
  }

  Future<void> _fillGrade(int index) async {
    try {
      await widget.grades[index].fill();
      if (mounted) setState(() {});
    } catch (_) {}
  }

  void _onNext() {
    final currentKey = _pageKeys[_currentPageIndex];
    final isCurrentPageRevealed = currentKey.currentState?._isRevealed ?? false;

    if (!isCurrentPageRevealed) {
      currentKey.currentState?.reveal();
    } else {
      if (_currentPageIndex < widget.grades.length - 1) {
        _pageController.nextPage(
          duration: Durations.medium1,
          curve: Easing.standard,
        );
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Ensure all grades are marked as revealed when the dialog is closed,
    // to prevent the database listener from immediately opening it again.
    isar.writeTxnSync(() {
      for (var grade in widget.grades) {
        if (!grade.wasRevealed) {
          grade.wasRevealed = true;
          isar.grades.putSync(grade);
        }
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentKey = _pageKeys[_currentPageIndex];
    final bool isCurrentRevealed =
        (currentKey.currentState != null && currentKey.currentState!.mounted)
            ? currentKey.currentState!._isRevealed
            : widget.grades[_currentPageIndex].wasRevealed;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: Text(widget.grades.length > 1
            ? "Nieuwe cijfers (${_currentPageIndex + 1}/${widget.grades.length})"
            : "Nieuw cijfer"),
      ),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.grades.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                  _fillGrade(index);
                },
                itemBuilder: (context, index) {
                  final grade = widget.grades[index];
                  return RevealGradePage(
                    key: _pageKeys[index],
                    grade: grade,
                    onRevealed: () => setState(() {}),
                  );
                },
              ),
            ),
            ElasticAnimation(
              child: Padding(
                key: ValueKey(isCurrentRevealed
                    ? (_currentPageIndex < widget.grades.length - 1 ? 0 : 1)
                    : 2),
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: FilledButton.icon(
                    onPressed: _onNext,
                    icon: Icon(isCurrentRevealed
                        ? (_currentPageIndex < widget.grades.length - 1
                            ? Icons.arrow_forward
                            : Icons.check)
                        : Icons.visibility),
                    label: Text(isCurrentRevealed
                        ? (_currentPageIndex < widget.grades.length - 1
                            ? "Volgende"
                            : "Sluiten")
                        : "Onthullen"),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RevealGradePage extends StatefulWidget {
  final Grade grade;
  final VoidCallback onRevealed;

  const RevealGradePage({
    super.key,
    required this.grade,
    required this.onRevealed,
  });

  @override
  State<RevealGradePage> createState() => _RevealGradePageState();
}

class _RevealGradePageState extends State<RevealGradePage>
    with SingleTickerProviderStateMixin {
  bool _isRevealed = false;
  bool _showDetails = false;
  late final AnimationController _detailsController;
  late final Animation<double> _detailsHeightFactor;

  @override
  void initState() {
    super.initState();
    _detailsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _detailsHeightFactor = CurvedAnimation(
      parent: _detailsController,
      curve: Easing.standard,
    );

    // If already marked as revealed in DB, show it immediately without animation
    if (widget.grade.wasRevealed) {
      _isRevealed = true;
      _showDetails = true;
      _detailsController.value = 1.0;
    }
  }

  void reveal() {
    if (_isRevealed) return;
    setState(() {
      _isRevealed = true;
    });
    widget.onRevealed();
    Future.delayed(const Duration(milliseconds: 1700), () {
      if (mounted) {
        setState(() {
          _showDetails = true;
        });
        _detailsController.forward();
      }
    });
    final grade = widget.grade;
    isar.writeTxnSync(() {
      grade.wasRevealed = true;
      isar.grades.putSync(grade);
    });
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  Text(
                    "Nieuw cijfer voor",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.grade.subject.value?.naam.capitalized ?? "Geen naam",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: reveal,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: RevealGradeAvatar(
                        radius: 70,
                        heroTag: widget.grade.id,
                        gradeString: _isRevealed ? widget.grade.cijferStr : "?",
                        enableAnimatedSwitcher: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizeTransition(
              sizeFactor: _detailsHeightFactor,
              axisAlignment: -1.0,
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  AnimatedOpacity(
                    opacity: _showDetails ? 1.0 : 0.0,
                    duration: Durations.medium1,
                    curve: Easing.standard,
                    child: InverseCardElevation(
                      child: GradeInformation(
                        key: ValueKey(widget.grade.id),
                        grade: widget.grade,
                        showTile: false,
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
  }
}
