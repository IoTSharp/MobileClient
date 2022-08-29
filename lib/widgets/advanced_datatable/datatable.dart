import 'advancedDataTableSource.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'dart:math' as math;
typedef GetWidgetCallBack = Widget Function();
typedef GetFooterRowText = String Function(
    int startRow,
    int pageSize,
    int? totalFilter,
    int totalRowsWithoutFilter,
    );

/// Based on the 'original' data table from the Flutter Dev Team
/// Extended to support async data loading and other changes to be more
/// flexible
/// A material design data table that shows data using multiple pages.
///
/// A paginated data table shows [rowsPerPage] rows of data per page and
/// provides controls for showing other pages.
///
/// Data is read lazily from from a [DataTableSource]. The widget is presented
/// as a [Card].
///
/// See also:
///
///  * [DataTable], which is not paginated.
///  * <https://material.io/go/design-data-tables#data-tables-tables-within-cards>
class AdvancedPaginatedDataTable extends StatefulWidget {
  /// Creates a widget describing a paginated [DataTable] on a [Card].
  ///
  /// The [header] should give the card's header, typically a [Text] widget.
  ///
  /// The [columns] argument must be a list of as many [DataColumn] objects as
  /// the table is to have columns, ignoring the leading checkbox column if any.
  /// The [columns] argument must have a length greater than zero and cannot be
  /// null.
  ///
  /// If the table is sorted, the column that provides the current primary key
  /// should be specified by index in [sortColumnIndex], 0 meaning the first
  /// column in [columns], 1 being the next one, and so forth.
  ///
  /// The actual sort order can be specified using [sortAscending]; if the sort
  /// order is ascending, this should be true (the default), otherwise it should
  /// be false.
  ///
  /// The [source] must not be null. The [source] should be a long-lived
  /// [DataTableSource]. The same source should be provided each time a
  /// particular [PaginatedDataTable] widget is created; avoid creating a new
  /// [DataTableSource] with each new instance of the [PaginatedDataTable]
  /// widget unless the data table really is to now show entirely different
  /// data from a new source.
  ///
  /// The [rowsPerPage] and [availableRowsPerPage] must not be null (they
  /// both have defaults, though, so don't have to be specified).
  ///
  /// Themed by [DataTableTheme]. [DataTableThemeData.decoration] is ignored.
  /// To modify the border or background color of the [PaginatedDataTable], use
  /// [CardTheme], since a [Card] wraps the inner [DataTable].
  AdvancedPaginatedDataTable({
    Key? key,
    this.header,
    this.actions,
    required this.columns,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSelectAll,
    this.dataRowHeight = kMinInteractiveDimension,
    this.headingRowHeight = 56.0,
    this.horizontalMargin = 24.0,
    this.columnSpacing = 56.0,
    this.showCheckboxColumn = true,
    this.showFirstLastButtons = false,
    this.initialFirstRowIndex = 0,
    this.onPageChanged,
    this.rowsPerPage = defaultRowsPerPage,
    this.availableRowsPerPage = const <int>[
      defaultRowsPerPage,
      defaultRowsPerPage * 2,
      defaultRowsPerPage * 5,
      defaultRowsPerPage * 10
    ],
    this.onRowsPerPageChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    required this.source,
    this.checkboxHorizontalMargin,
    this.addEmptyRows = true,
    this.loadingWidget,
    this.errorWidget,
    this.getFooterRowText,
  })  : assert(actions == null || header != null),
        assert(columns.isNotEmpty),
        assert(sortColumnIndex == null ||
            (sortColumnIndex >= 0 && sortColumnIndex < columns.length)),
        assert(rowsPerPage > 0),
        assert(() {
          if (onRowsPerPageChanged != null) {
            assert(availableRowsPerPage.contains(rowsPerPage));
          }
          return true;
        }()),
        super(key: key);

  /// Add empty/blank lines to the table if not enough records are present
  /// If the source doesnt have enough data add empty/blank lines to fill a page
  /// Default true
  final bool addEmptyRows;

  final GetFooterRowText? getFooterRowText;

  /// Called while the page is loading
  /// If not set a default loading will be shown
  final GetWidgetCallBack? loadingWidget;

  /// Called once the page loading encountered an error in the future
  /// If not provided a default message will be shown
  final GetWidgetCallBack? errorWidget;

  /// The table card's optional header.
  ///
  /// This is typically a [Text] widget, but can also be a [Row] of
  /// [TextButton]s. To show icon buttons at the top end side of the table with
  /// a header, set the [actions] property.
  ///
  /// If items in the table are selectable, then, when the selection is not
  /// empty, the header is replaced by a count of the selected items. The
  /// [actions] are still visible when items are selected.
  final Widget? header;

  /// Icon buttons to show at the top end side of the table. The [header] must
  /// not be null to show the actions.
  ///
  /// Typically, the exact actions included in this list will vary based on
  /// whether any rows are selected or not.
  ///
  /// These should be size 24.0 with default padding (8.0).
  final List<Widget>? actions;

  /// The configuration and labels for the columns in the table.
  final List<DataColumn> columns;

  /// The current primary sort key's column.
  ///
  /// See [DataTable.sortColumnIndex].
  final int? sortColumnIndex;

  /// Whether the column mentioned in [sortColumnIndex], if any, is sorted
  /// in ascending order.
  ///
  /// See [DataTable.sortAscending].
  final bool sortAscending;

  /// Invoked when the user selects or unselects every row, using the
  /// checkbox in the heading row.
  ///
  /// See [DataTable.onSelectAll].
  final ValueSetter<bool?>? onSelectAll;

  /// The height of each row (excluding the row that contains column headings).
  ///
  /// This value is optional and defaults to kMinInteractiveDimension if not
  /// specified.
  final double dataRowHeight;

  /// The height of the heading row.
  ///
  /// This value is optional and defaults to 56.0 if not specified.
  final double headingRowHeight;

  /// The horizontal margin between the edges of the table and the content
  /// in the first and last cells of each row.
  ///
  /// When a checkbox is displayed, it is also the margin between the checkbox
  /// the content in the first data column.
  ///
  /// This value defaults to 24.0 to adhere to the Material Design specifications.
  ///
  /// If [checkboxHorizontalMargin] is null, then [horizontalMargin] is also the
  /// margin between the edge of the table and the checkbox, as well as the
  /// margin between the checkbox and the content in the first data column.
  final double horizontalMargin;

  /// The horizontal margin between the contents of each data column.
  ///
  /// This value defaults to 56.0 to adhere to the Material Design specifications.
  final double columnSpacing;

  /// {@macro flutter.material.dataTable.showCheckboxColumn}
  final bool showCheckboxColumn;

  /// Flag to display the pagination buttons to go to the first and last pages.
  final bool showFirstLastButtons;

  /// The index of the first row to display when the widget is first created.
  final int? initialFirstRowIndex;

  /// Invoked when the user switches to another page.
  ///
  /// The value is the index of the first row on the currently displayed page.
  final ValueChanged<int>? onPageChanged;

  /// The number of rows to show on each page.
  ///
  /// See also:
  ///
  ///  * [onRowsPerPageChanged]
  ///  * [defaultRowsPerPage]
  final int rowsPerPage;

  /// The default value for [rowsPerPage].
  ///
  /// Useful when initializing the field that will hold the current
  /// [rowsPerPage], when implemented [onRowsPerPageChanged].
  static const int defaultRowsPerPage = 10;

  /// The options to offer for the rowsPerPage.
  ///
  /// The current [rowsPerPage] must be a value in this list.
  ///
  /// The values in this list should be sorted in ascending order.
  final List<int> availableRowsPerPage;

  /// Invoked when the user selects a different number of rows per page.
  ///
  /// If this is null, then the value given by [rowsPerPage] will be used
  /// and no affordance will be provided to change the value.
  final ValueChanged<int?>? onRowsPerPageChanged;

  /// The data source which provides data to show in each row. Must be non-null.
  ///
  /// This object should generally have a lifetime longer than the
  /// [PaginatedDataTable] widget itself; it should be reused each time the
  /// [PaginatedDataTable] constructor is called.
  final AdvancedDataTableSource source;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// Horizontal margin around the checkbox, if it is displayed.
  ///
  /// If null, then [horizontalMargin] is used as the margin between the edge
  /// of the table and the checkbox, as well as the margin between the checkbox
  /// and the content in the first data column. This value defaults to 24.0.
  final double? checkboxHorizontalMargin;

  @override
  PaginatedDataTableState createState() => PaginatedDataTableState();
}

/// Holds the state of a [PaginatedDataTable].
///
/// The table can be programmatically paged using the [pageTo] method.
class PaginatedDataTableState extends State<AdvancedPaginatedDataTable> {
  late int _firstRowIndex;
  late int _rowCount;
  late bool _rowCountApproximate;
  int _selectedRowCount = 0;
  //Used to load the next page if needed
  late Future<int> loadNextPage;
  final Map<int, DataRow?> _rows = <int, DataRow?>{};
  int? lastOffset;
  int? lastRecordsByPage;
  int? lastOrderColumn;
  bool? lastOrderDirection;

  @override
  void initState() {
    super.initState();
    _firstRowIndex = PageStorage.of(context)?.readState(context) as int? ??
        widget.initialFirstRowIndex ??
        0;
    widget.source.addListener(_handleDataSourceChanged);
    setLoadNextPage(firstRowIndex: 0);

    _rowCount = widget.source.rowCount;
    _rowCountApproximate = widget.source.isRowCountApproximate;
    _selectedRowCount = widget.source.selectedRowCount;
    _rows.clear();
  }

  @override
  void didUpdateWidget(AdvancedPaginatedDataTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source) {
      oldWidget.source.removeListener(_handleDataSourceChanged);
      widget.source.addListener(_handleDataSourceChanged);
      _handleDataSourceChanged();
    }
    if (oldWidget.sortColumnIndex != widget.sortColumnIndex ||
        oldWidget.sortAscending != widget.sortAscending) {
      _handleDataSourceChanged();
    }
  }

  @override
  void dispose() {
    widget.source.removeListener(_handleDataSourceChanged);
    super.dispose();
  }

  void _handleDataSourceChanged() {
    setState(() {
      _rowCount = widget.source.rowCount;
      _rowCountApproximate = widget.source.isRowCountApproximate;
      _selectedRowCount = widget.source.selectedRowCount;
      setLoadNextPage();
    });
  }

  bool remoteReloadRequired(int? rowsPerPage, int? firstRowIndex) {
    if (widget.source.requireRemoteReload()) {
      //We only want to force the reload once
      widget.source.forceRemoteReload = false;
      return true;
    }
    rowsPerPage ??= widget.rowsPerPage;
    firstRowIndex ??= _firstRowIndex;

    if (lastOrderColumn != widget.sortColumnIndex ||
        lastOrderDirection != widget.sortAscending ||
        lastRecordsByPage != rowsPerPage ||
        lastOffset != firstRowIndex) {
      lastOrderColumn = widget.sortColumnIndex;
      lastOrderDirection = widget.sortAscending;
      lastRecordsByPage = rowsPerPage;
      lastOffset = firstRowIndex;

      return true;
    }
    return false;
  }

  void setLoadNextPage({int? rowsPerPage, int? firstRowIndex}) {
    _rows.clear();

    rowsPerPage ??= widget.rowsPerPage;
    if (widget.source.nextStartIndex != null) {
      firstRowIndex = widget.source.nextStartIndex!;
      _firstRowIndex = firstRowIndex;
      widget.source.nextStartIndex = null;
    } else {
      firstRowIndex ??= _firstRowIndex;
    }

    if (remoteReloadRequired(rowsPerPage, firstRowIndex)) {
      loadNextPage = widget.source.loadNextPage(
        rowsPerPage,
        firstRowIndex,
        widget.sortColumnIndex,
        widget.sortAscending,
      );
    }
  }

  /// Ensures that the given row is visible.
  void pageTo(int rowIndex) {
    final oldFirstRowIndex = _firstRowIndex;
    setState(() {
      final rowsPerPage = widget.rowsPerPage;
      _firstRowIndex = (rowIndex ~/ rowsPerPage) * rowsPerPage;
      setLoadNextPage();
    });
    if ((widget.onPageChanged != null) &&
        (oldFirstRowIndex != _firstRowIndex)) {
      widget.onPageChanged!(_firstRowIndex);
    }
  }

  DataRow _getBlankRowFor(int index) {
    return DataRow.byIndex(
      index: index,
      cells: widget.columns
          .map<DataCell>((DataColumn column) => DataCell.empty)
          .toList(),
    );
  }

  DataRow _getProgressIndicatorRowFor(int index) {
    var haveProgressIndicator = false;
    final cells = widget.columns.map<DataCell>((DataColumn column) {
      if (!column.numeric) {
        haveProgressIndicator = true;
        return const DataCell(CircularProgressIndicator());
      }
      return DataCell.empty;
    }).toList();
    if (!haveProgressIndicator) {
      haveProgressIndicator = true;
      cells[0] = const DataCell(CircularProgressIndicator());
    }
    return DataRow.byIndex(
      index: index,
      cells: cells,
    );
  }

  /// Adjusted to work in the context of a datasource _not_ having all rows
  List<DataRow> _getRows(int firstRowIndex, int rowsPerPage) {
    final result = <DataRow>[];
    final nextPageFirstRowIndex = firstRowIndex + rowsPerPage;
    var haveProgressIndicator = false;
    for (var index = firstRowIndex; index < nextPageFirstRowIndex; index += 1) {
      DataRow? row;
      if (index < _rowCount || _rowCountApproximate) {
        row = _rows.putIfAbsent(
            index,
                () => widget.source.getRow(index -
                firstRowIndex)); //index - (firstRowIndex ~/ rowsPerPage) * rowsPerPage)

        if (row == null && !haveProgressIndicator) {
          row ??= _getProgressIndicatorRowFor(index);
          haveProgressIndicator = true;
        }
      }
      if (widget.addEmptyRows) {
        row ??= _getBlankRowFor(index);
      }
      if (row != null) {
        result.add(row);
      }
    }
    return result;
  }

  void _handleFirst() {
    pageTo(0);
  }

  void _handlePrevious() {
    pageTo(math.max(_firstRowIndex - widget.rowsPerPage, 0));
  }

  void _handleNext() {
    pageTo(_firstRowIndex + widget.rowsPerPage);
  }

  void _handleLast() {
    pageTo(((_rowCount - 1) / widget.rowsPerPage).floor() * widget.rowsPerPage);
  }

  bool _isNextPageUnavailable() =>
      !_rowCountApproximate &&
          (_firstRowIndex + widget.rowsPerPage >= _rowCount);

  final GlobalKey _tableKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    //Adjusted to first request the data followed by rendering the original table
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return FutureBuilder<int>(
            future: loadNextPage,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                _rowCount = snapshot.data ?? 0;
                return buildTableWhenReady(constraints);
              } else {
                if (snapshot.hasError) {
                  if (widget.errorWidget != null) {
                    return widget.errorWidget!();
                  } else {
                    return Center(
                      child: Text(
                          'Something went wrong: ${snapshot.error?.toString() ?? 'No error information'}'),
                    );
                  }
                } else {
                  if (widget.loadingWidget != null) {
                    return widget.loadingWidget!();
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              }
            },
          );
        });
  }

  ///Original build method from the Flutter PageinatedDataTable
  Widget buildTableWhenReady(BoxConstraints constraints) {
    assert(debugCheckHasMaterialLocalizations(context));
    final themeData = Theme.of(context);
    final localizations = MaterialLocalizations.of(context);
    // HEADER
    final headerWidgets = <Widget>[];
    var startPadding = 24.0;
    if (_selectedRowCount == 0 && widget.header != null) {
      headerWidgets.add(Expanded(child: widget.header!));
      if (widget.header is ButtonBar) {
        // We adjust the padding when a button bar is present, because the
        // ButtonBar introduces 2 pixels of outside padding, plus 2 pixels
        // around each button on each side, and the button itself will have 8
        // pixels internally on each side, yet we want the left edge of the
        // inside of the button to line up with the 24.0 left inset.
        startPadding = 12.0;
      }
    } else if (widget.header != null) {
      headerWidgets.add(Expanded(
        child: Text(localizations.selectedRowCountTitle(_selectedRowCount)),
      ));
    }
    if (widget.actions != null) {
      headerWidgets.addAll(
        widget.actions!.map<Widget>((Widget action) {
          return Padding(
            // 8.0 is the default padding of an icon button
            padding: const EdgeInsetsDirectional.only(start: 24.0 - 8.0 * 2.0),
            child: action,
          );
        }).toList(),
      );
    }

    // FOOTER
    final footerTextStyle = themeData.textTheme.caption;
    final footerWidgets = <Widget>[];
    if (widget.onRowsPerPageChanged != null) {
      final List<Widget> availableRowsPerPage =
      widget.availableRowsPerPage.map<DropdownMenuItem<int>>((int value) {
        return DropdownMenuItem<int>(
          value: value,
          key: ValueKey('opt_$value'),
          child: Text(
            '$value',
          ),
        );
      }).toList();
      footerWidgets.addAll(<Widget>[
        Container(
            width:
            14.0), // to match trailing padding in case we overflow and end up scrolling
        Text(localizations.rowsPerPageTitle),
        ConstrainedBox(
          constraints: const BoxConstraints(
              minWidth: 64.0), // 40.0 for the text, 24.0 for the icon
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: DropdownButtonHideUnderline(
              key: Key('rowsPerPageParent'),
              child: DropdownButton<int>(
                key: Key('rowsPerPage'),
                items: availableRowsPerPage.cast<DropdownMenuItem<int>>(),
                value: widget.rowsPerPage,
                onTap: () {},
                onChanged: (newRowsPerPage) {
                  if (newRowsPerPage != null &&
                      newRowsPerPage != widget.rowsPerPage) {
                    setLoadNextPage(rowsPerPage: newRowsPerPage);
                    if (widget.onRowsPerPageChanged != null) {
                      widget.onRowsPerPageChanged!(newRowsPerPage);
                    }
                  }
                },
                style: footerTextStyle,
                iconSize: 24.0,
              ),
            ),
          ),
        ),
      ]);
    }
    footerWidgets.addAll(<Widget>[
      Container(width: 32.0),
      Text(
        buildDataAmountText(),
      ),
      Container(width: 32.0),
      if (widget.showFirstLastButtons)
        IconButton(
          icon: const Icon(Icons.skip_previous),
          padding: EdgeInsets.zero,
          onPressed: _firstRowIndex <= 0 ? null : _handleFirst,
        ),
      IconButton(
        icon: const Icon(Icons.chevron_left),
        padding: EdgeInsets.zero,
        tooltip: localizations.previousPageTooltip,
        onPressed: _firstRowIndex <= 0 ? null : _handlePrevious,
      ),
      Container(width: 24.0),
      IconButton(
        icon: const Icon(Icons.chevron_right),
        padding: EdgeInsets.zero,
        tooltip: localizations.nextPageTooltip,
        onPressed: _isNextPageUnavailable() ? null : _handleNext,
      ),
      if (widget.showFirstLastButtons)
        IconButton(
          icon: const Icon(Icons.skip_next),
          padding: EdgeInsets.zero,
          onPressed: _isNextPageUnavailable() ? null : _handleLast,
        ),
      Container(width: 14.0),
    ]);
    return Card(
      semanticContainer: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (headerWidgets.isNotEmpty)
            Semantics(
              container: true,
              child: DefaultTextStyle(
                // These typographic styles aren't quite the regular ones. We pick the closest ones from the regular
                // list and then tweak them appropriately.
                // See https://material.io/design/components/data-tables.html#tables-within-cards
                style: _selectedRowCount > 0
                    ? themeData.textTheme.subtitle1!
                    .copyWith(color: themeData.colorScheme.secondary)
                    : themeData.textTheme.headline6!
                    .copyWith(fontWeight: FontWeight.w400),
                child: IconTheme.merge(
                  data: const IconThemeData(
                    opacity: 0.54,
                  ),
                  child: Ink(
                    height: 64.0,
                    color: _selectedRowCount > 0
                        ? themeData.secondaryHeaderColor
                        : null,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                          start: startPadding, end: 14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: headerWidgets,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            dragStartBehavior: widget.dragStartBehavior,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                key: _tableKey,
                columns: widget.columns,
                sortColumnIndex: widget.sortColumnIndex,
                sortAscending: widget.sortAscending,
                onSelectAll: widget.onSelectAll,
                // Make sure no decoration is set on the DataTable
                // from the theme, as its already wrapped in a Card.
                decoration: const BoxDecoration(),
                dataRowHeight: widget.dataRowHeight,
                headingRowHeight: widget.headingRowHeight,
                horizontalMargin: widget.horizontalMargin,
                columnSpacing: widget.columnSpacing,
                showCheckboxColumn: widget.showCheckboxColumn,
                showBottomBorder: true,
                rows: _getRows(_firstRowIndex, widget.rowsPerPage),
              ),
            ),
          ),
          DefaultTextStyle(
            style: footerTextStyle!,
            child: IconTheme.merge(
              data: const IconThemeData(
                opacity: 0.54,
              ),
              child: SizedBox(
                height: 56.0,
                child: SingleChildScrollView(
                  dragStartBehavior: widget.dragStartBehavior,
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Row(
                    children: footerWidgets,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String buildDataAmountText() {
    if (widget.getFooterRowText != null) {
      return widget.getFooterRowText!(
        _firstRowIndex + 1,
        math.min(_firstRowIndex + widget.rowsPerPage, _rowCount),
        widget.source.lastDetails?.filteredRows,
        widget.source.lastDetails?.totalRows ?? 0,
      );
    }

    final localizations = MaterialLocalizations.of(context);
    var amountText = localizations.pageRowsInfoTitle(
      _firstRowIndex + 1,
      math.min(_firstRowIndex + widget.rowsPerPage, _rowCount),
      _rowCount,
      _rowCountApproximate,
    );

    if (widget.source.lastDetails != null &&
        widget.source.lastDetails!.filteredRows != null) {
      //Filtered data source show addtional information
      amountText += ' from (${widget.source.lastDetails!.totalRows})';
    }

    return amountText;
  }
}