import 'dart:convert';
import 'package:discipulus/api/models/grades.dart';
import 'package:discipulus/api/models/schoolyears.dart';
import 'package:discipulus/utils/extensions.dart';
import 'package:discipulus/widgets/global/skeletons/default.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart'; // For groupBy and sorting

// Represents the essential info needed for a cell in the grid
class GradeInfo {
  final String? cijferStr;
  final bool isVoldoende;
  final bool isSummaryColumn; // To determine blue background

  GradeInfo({
    this.cijferStr,
    required this.isVoldoende,
    required this.isSummaryColumn,
  });
}

// Represents a column in the table header and data grid
class ColumnDefinition implements Comparable<ColumnDefinition> {
  final String periodName;
  final int periodSortOrder;
  final String
      columnId; // Unique ID (e.g., "2_151", "1_941") built from period order and sort key
  final String
      headerLabel; // What to display in the second header row (e.g., "140", "R1")
  final String
      sortKey; // Original KolomVolgNummer or KolomNummer for sorting within period
  final bool isSummary; // KolomSoort == 2

  ColumnDefinition({
    required this.periodName,
    required this.periodSortOrder,
    required this.columnId,
    required this.headerLabel,
    required this.sortKey,
    required this.isSummary,
  });

  // Custom sorting logic: First by Period Order, then by Column Sort Key (numeric preferred)
  @override
  int compareTo(ColumnDefinition other) {
    int periodCompare = periodSortOrder.compareTo(other.periodSortOrder);
    if (periodCompare != 0) {
      return periodCompare;
    }
    // Try numeric comparison first for sortKey (KolomVolgNummer/KolomNummer)
    int? thisSortNum = int.tryParse(sortKey);
    int? otherSortNum = int.tryParse(other.sortKey);

    if (thisSortNum != null && otherSortNum != null) {
      return thisSortNum.compareTo(otherSortNum);
    }
    // Fallback to string comparison if not numeric (handles 'R1', 'R2', etc.)
    return sortKey.compareTo(other.sortKey);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColumnDefinition &&
          runtimeType == other.runtimeType &&
          columnId == other.columnId; // Uniqueness based on the combined ID

  @override
  int get hashCode => columnId.hashCode;
}

// Represents a subject row
class SubjectDefinition implements Comparable<SubjectDefinition> {
  final String name;
  final int sortOrder; // Based on Vak.Volgnr

  SubjectDefinition({required this.name, required this.sortOrder});

  // Sort by the Vak.Volgnr
  @override
  int compareTo(SubjectDefinition other) {
    return sortOrder.compareTo(other.sortOrder);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectDefinition &&
          runtimeType == other.runtimeType &&
          name == other.name; // Uniqueness based on name

  @override
  int get hashCode => name.hashCode;
}

// --- Main Widget ---

class GradesMagisterView extends StatefulWidget {
  final Schoolyear schoolyear;

  const GradesMagisterView({super.key, required this.schoolyear});

  @override
  State<GradesMagisterView> createState() => _GradesMagisterViewState();
}

class _GradesMagisterViewState extends State<GradesMagisterView> {
  List<SubjectDefinition> _subjects = [];
  List<ColumnDefinition> _columns = [];
  Map<String, Map<String, GradeInfo>> _gradeData =
      {}; // { SubjectName: { ColumnId: GradeInfo } }
  bool _isLoading = true;
  String? _error;

  // Scroll controllers for syncing horizontal scroll between header and body
  final ScrollController _headerScrollController = ScrollController();
  final ScrollController _bodyScrollController = ScrollController();

  // Constants for styling - Adjust these values to match the image precisely
  static const double _subjectColumnWidth = 160.0;
  static const double _gradeColumnWidth = 55.0; // Width for each grade column
  static const double _cellPaddingHorizontal = 8.0;
  static const double _cellPaddingVertical = 12.0;
  late final Color _borderColor =
      Theme.of(context).colorScheme.surfaceDim; // Light Grey for borders
  late final Color _summaryBgColor = Theme.of(context)
      .colorScheme
      .primaryContainer; // Light Blue for summary cols/headers
  late final Color _headerBgColor = Theme.of(context)
      .colorScheme
      .surfaceBright; // Background for regular headers
  late final Color _failingGradeColor = Theme.of(context).colorScheme.error;
  late final Color _passingGradeColor = Theme.of(context).colorScheme.onSurface;
  late final Color _evenRowColor = Theme.of(context).colorScheme.surface;
  late final Color _oddRowColor = Theme.of(context)
      .colorScheme
      .surfaceContainer; // Very light grey for alternating rows

  @override
  void initState() {
    super.initState();
    _processData();
    // Sync scroll controllers: If one scrolls horizontally, the other follows
    _headerScrollController.addListener(_syncHeaderScroll);
    _bodyScrollController.addListener(_syncBodyScroll);
  }

  @override
  void dispose() {
    _headerScrollController.removeListener(_syncHeaderScroll);
    _bodyScrollController.removeListener(_syncBodyScroll);
    _headerScrollController.dispose();
    _bodyScrollController.dispose();
    super.dispose();
  }

  // --- Scroll Synchronization Logic ---
  // Flags to prevent scroll listener feedback loops when setting offset programmatically
  bool _isSyncingHeader = false;
  bool _isSyncingBody = false;

  void _syncHeaderScroll() {
    if (_isSyncingHeader) return; // Prevent feedback loop

    _isSyncingBody =
        true; // Indicate that the body scroll is being synced programmatically
    if (_bodyScrollController.hasClients &&
        _bodyScrollController.offset != _headerScrollController.offset) {
      _bodyScrollController.jumpTo(_headerScrollController.offset);
    }
    // Reset the flag shortly after the frame, ensuring listener is ready for user scroll
    Future.delayed(Duration.zero, () {
      _isSyncingBody = false;
    });
  }

  void _syncBodyScroll() {
    if (_isSyncingBody) return; // Prevent feedback loop

    _isSyncingHeader =
        true; // Indicate that the header scroll is being synced programmatically
    if (_headerScrollController.hasClients &&
        _headerScrollController.offset != _bodyScrollController.offset) {
      _headerScrollController.jumpTo(_bodyScrollController.offset);
    }
    // Reset the flag shortly after the frame
    Future.delayed(Duration.zero, () {
      _isSyncingHeader = false;
    });
  }

  // --- Data Processing ---
  void _processData() {
    try {
      // final Map<String, dynamic> parsedJson = jsonDecode(widget.jsonData);
      // final List<dynamic> items = parsedJson['Items'];

      List<Grade> grades = widget.schoolyear.grades.toList();

      // Using Sets ensures uniqueness based on overridden == and hashCode
      final Set<SubjectDefinition> uniqueSubjects = {};
      final Set<ColumnDefinition> uniqueColumns = {};
      // Temporary map to build the final structured data
      final Map<String, Map<String, GradeInfo>> tempData = {};

      for (Grade grade in grades) {
        // Basic validation: Need at least a subject to define a row
        if (grade.subject.value == null || grade.subject.value?.naam == null) {
          continue;
        }

        final subjectName = grade.subject.value!.naam.capitalized;
        // Use Vak.Volgnr for sorting subjects, provide a high default if missing
        final subjectSortOrder = grade.subject.value?.volgnr ?? 9999;

        // Add Subject Definition (happens for every item with a Vak)
        uniqueSubjects.add(SubjectDefinition(
          name: subjectName,
          sortOrder: subjectSortOrder,
        ));

        // Only process column and grade info if CijferPeriode and CijferKolom exist
        if (grade.period.value != null) {
          final periodName = grade.period.value!.naam;
          final periodSortOrder = grade.period.value!.volgNummer;

          final kolom = grade.cijferKolom;

          // Determine the best key for sorting columns within a period
          // Prioritize KolomVolgNummer, fallback to KolomNummer, then KolomId as last resort
          final columnSortKey = kolom.kolomVolgNummer;
          // kolom.kolomNummer.toString() ??
          // 'ID_${kolom.id}'; // Ensure unique fallback

          // Determine the label for the second header row
          // Prioritize KolomNummer, fallback to KolomKop
          final columnHeaderLabel = kolom.kolomNummer ?? kolom.kolomKop ?? '?';

          final columnIsSummary = kolom.kolomSoort == 2;

          // Create a robust unique column identifier combining period order and sort key
          // This handles columns with the same number appearing in different periods
          final columnId = "${periodSortOrder}_${columnSortKey}";

          // Add Column Definition
          uniqueColumns.add(ColumnDefinition(
            periodName: periodName,
            periodSortOrder: periodSortOrder,
            columnId: columnId,
            headerLabel: columnHeaderLabel,
            sortKey: columnSortKey, // Use the determined sort key
            isSummary: columnIsSummary,
          ));

          // Prepare Grade Info for the lookup map
          final gradeInfo = GradeInfo(
            cijferStr: grade.cijferStr,
            // Default to true (passing) if IsVoldoende is null or missing
            isVoldoende: grade.isVoldoende,
            isSummaryColumn: columnIsSummary,
          );

          // Populate the nested lookup map: Subject -> ColumnId -> GradeInfo
          tempData.putIfAbsent(subjectName, () => {});
          tempData[subjectName]![columnId] = gradeInfo;
        }
      }

      // Convert Sets to Lists and sort them using their respective compareTo methods
      _subjects = uniqueSubjects.toList()..sort();
      _columns = uniqueColumns.toList()
        ..sort(); // Uses ColumnDefinition's compareTo
      _gradeData = tempData; // Assign the populated map

      setState(() {
        _isLoading = false;
        _error = null;
      });
    } catch (e, s) {
      print("Error processing grade data: $e");
      print("Stack trace: $s");
      setState(() {
        _isLoading = false;
        _error = "Failed to process grade data. See console for details.";
      });
    }
  }

  // --- UI Building ---

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
          child: Text(_error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error)));
    }
    // It's possible to have subjects but no columns/grades yet
    if (_subjects.isEmpty) {
      return const Center(child: Text("No subjects found."));
    }

    // The core layout: A Column containing the Header and the Expanded Body.
    // Horizontal scrolling is handled *within* the header and body rows.
    return ScaffoldSkeleton(
      appBar: (isRefreshing, trailingRefreshButton, leading) =>
          SliverAppBar.large(
        title: Text("Magister gemiddelden"),
      ),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              _buildHeaderRow(),
              // Single divider below the entire header structure
              Divider(height: 1, thickness: 1, color: _borderColor),
              // The body takes up the remaining vertical space
              _buildBody(),
            ],
          ),
        ),
      ],
    );
  }

  // Builds the two-level header row with fixed subject column and scrollable grade columns
  Widget _buildHeaderRow() {
    // Group columns by period name to calculate spans for the top header row
    final groupedColumns =
        groupBy(_columns, (ColumnDefinition col) => col.periodName);

    // Ensure periods are ordered correctly based on their defined sort order
    final orderedPeriods = groupedColumns.keys.toList()
      ..sort((a, b) {
        // Get the sort order from the first column definition within each period group
        int sortA = groupedColumns[a]?.first.periodSortOrder ?? 0;
        int sortB = groupedColumns[b]?.first.periodSortOrder ?? 0;
        return sortA.compareTo(sortB);
      });

    return Container(
      color: _headerBgColor, // Background for the entire header area
      // The Row structure separates the fixed 'Vak' header from the scrollable part
      child: Row(
        children: [
          // --- Fixed "Vak" Header ---
          // This part remains stationary on the left
          _buildHeaderCell('Vak', false,
              fixedWidth: _subjectColumnWidth, isFirstColumn: true),

          // --- Scrollable Grade Headers ---
          Container(
            // Apply a left border to visually separate from the fixed 'Vak' column
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: _borderColor, width: 1)),
            ),
            // The Column holds the two levels of the scrollable header
            child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align rows to the start
                children: [
                  // --- Top Header Row (Periods) ---
                  Row(
                    children: orderedPeriods.map((periodName) {
                      final columnsInPeriod = groupedColumns[periodName]!;
                      // A period header is blue if *any* column within it is a summary column
                      final bool periodHasSummary =
                          columnsInPeriod.any((c) => c.isSummary);
                      return _buildHeaderCell(
                        periodName,
                        periodHasSummary, // Blue background if any column is summary
                        colSpan: columnsInPeriod.length, // Determines the width
                        isTopHeader: true,
                      );
                    }).toList(),
                  ),
                  // Divider between the two header levels
                  Divider(height: 1, thickness: 1, color: _borderColor),
                  // --- Bottom Header Row (Column Numbers/Kop) ---
                  Row(
                    // Iterates through the fully sorted _columns list ensures correct order
                    children: _columns.map((col) {
                      // Each cell uses its own 'isSummary' flag for background color
                      return _buildHeaderCell(
                        col.headerLabel, // Display "140", "R1", etc.
                        col.isSummary, // Specific blue background if this column is summary
                      );
                    }).toList(),
                  ),
                ]),
          ),
        ],
      ),
    );
  }

  // Builds the main body using a ListView for vertical scrolling of subject rows
  Widget _buildBody() {
    // Column handles vertical layout of subject rows.
    return Column(
      children: [
        for (int rowIndex = 0; rowIndex < _subjects.length; rowIndex++)
          ...(() {
            final subject = _subjects[rowIndex];
            // Determine alternating row background color
            final rowColor = rowIndex.isEven ? _evenRowColor : _oddRowColor;

            return [
              // IntrinsicHeight ensures all cells in the Row expand to the tallest cell's height
              IntrinsicHeight(
                // The Row structure mirrors the header: Fixed Subject + Expanded Scrollable Grades
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch, // Make cells fill height
                  children: [
                    // --- Fixed Subject Cell ---
                    // This cell stays fixed on the left
                    _buildSubjectCell(subject.name, rowColor),

                    // --- Scrollable Grade Cells for this Row ---
                    Container(
                      // Apply the alternating row color and the left border
                      // to the entire scrollable area of the row.
                      decoration: BoxDecoration(
                        color: rowColor,
                        border: Border(
                            left: BorderSide(color: _borderColor, width: 1)),
                      ),
                      // The Row lays out the individual grade cells horizontally
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: _bodyScrollController,
                        child: Row(
                          children: _columns.map((col) {
                            // Look up the grade for this specific subject and column
                            final gradeInfo =
                                _gradeData[subject.name]?[col.columnId];
                            // Build the grade cell, passing summary status for background
                            return _buildGradeCell(gradeInfo, col.isSummary);
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Divider below each row (except the last one)
              if (rowIndex < _subjects.length - 1)
                Divider(height: 1, thickness: 1, color: _borderColor),
            ];
          })()
      ],
    );
  }

  // --- Cell Builder Helpers ---

  // Generic cell builder - used by header, subject, and grade cell builders
  Widget _buildCell({
    required String? text,
    required Color
        backgroundColor, // Base background (row color, header color, or specific blue)
    required Color textColor,
    required Alignment alignment,
    required double width,
    bool isHeader = false,
    bool isFirstColumn = false, // Is this the 'Vak'/Subject column?
    bool isDataCell = false, // Is this a grade data cell (vs header/subject)?
  }) {
    return Container(
      width: width,
      // If it's a data cell and the provided background is transparent,
      // let the underlying row color show through (don't set a color here).
      // Otherwise, use the provided background color (e.g., blue for summary, white for header).
      padding: const EdgeInsets.symmetric(
          horizontal: _cellPaddingHorizontal, vertical: _cellPaddingVertical),
      // Draw only the right border for every cell.
      // The left border for the scrollable area is handled by the Container wrapping it.
      decoration: BoxDecoration(
        color: (isDataCell && backgroundColor == Colors.transparent)
            ? null
            : backgroundColor,
        border: Border(
          right: BorderSide(color: _borderColor, width: 1),
        ),
      ),
      child: Align(
        alignment: alignment,
        child: Text(
          text ?? '', // Display empty string if text is null
          textAlign:
              alignment == Alignment.center ? TextAlign.center : TextAlign.left,
          style: TextStyle(
            color: textColor,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: 13, // Match font size from image
          ),
          overflow: TextOverflow.ellipsis, // Prevent text wrapping/overflow
          maxLines: 1,
        ),
      ),
    );
  }

  // Builds header cells (both top period row and bottom number/kop row)
  Widget _buildHeaderCell(String text, bool isSummary,
      {int colSpan = 1,
      double? fixedWidth,
      bool isTopHeader = false,
      bool isFirstColumn = false}) {
    // Calculate width: Use fixedWidth if provided (for 'Vak'), otherwise calculate based on grade column width and span
    final width = fixedWidth ?? (_gradeColumnWidth * colSpan);
    // Determine background: Blue if it's a summary column/period, otherwise standard header white
    final bgColor = isSummary ? _summaryBgColor : _headerBgColor;
    return _buildCell(
      text: text,
      backgroundColor: bgColor,
      textColor: _passingGradeColor, // Header text is always black
      // Align 'Vak' header left-of-center, others center
      alignment: isFirstColumn ? Alignment.centerLeft : Alignment.center,
      width: width,
      isHeader: true, // Mark as header for styling (bold text)
      isFirstColumn: isFirstColumn,
    );
  }

  // Builds the fixed subject cell in the data rows
  Widget _buildSubjectCell(String text, Color rowColor) {
    // Passes the alternating rowColor as the background color
    return _buildCell(
      text: text,
      backgroundColor: rowColor, // Use the determined row color
      textColor: _passingGradeColor,
      alignment: Alignment.centerLeft, // Left align subject names
      width: _subjectColumnWidth,
      isFirstColumn: true, // Mark as the first column
    );
  }

  // Builds the scrollable grade data cells within the body rows
  Widget _buildGradeCell(GradeInfo? gradeInfo, bool isSummaryColumn) {
    final text = gradeInfo?.cijferStr;
    // Treat null grade visually as sufficient (black text)
    final isVoldoende = gradeInfo?.isVoldoende ?? true;
    // Text color: Red if failing, black otherwise
    final textColor = isVoldoende ? _passingGradeColor : _failingGradeColor;
    // Background color: Blue if the *column* is designated as summary type,
    // otherwise transparent to let the alternating row color show through.
    final cellBgColor = isSummaryColumn ? _summaryBgColor : Colors.transparent;

    return _buildCell(
      text: text,
      backgroundColor: cellBgColor, // Will be blue or transparent
      textColor: textColor,
      alignment: Alignment.center, // Center align grades
      width: _gradeColumnWidth, // Use consistent grade column width
      isDataCell: true, // Mark as data cell for background logic
    );
  }
}
