import 'package:flutter/material.dart';

int getRowsForPage(BoxConstraints constraint) {
  const double topViewHeight = 10.0;
  const double paginateDataTableHeaderRowHeight = 35.0;
  const double pagerWidgetHeight = 56;
  const double paginateDataTableRowHeight = kMinInteractiveDimension;

  return ((constraint.maxHeight -
              topViewHeight -
              paginateDataTableHeaderRowHeight -
              pagerWidgetHeight) ~/
          paginateDataTableRowHeight)
      .toInt();
}
