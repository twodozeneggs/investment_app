import 'package:flutter/material.dart';
import '../models/swipe_dialog.dart';

void showStockSwipeDialog(
  BuildContext context,
  String stockName,
  double shares,
  int level,
  Function() onBuy,
  Function() onSell,
  Function() onMove,
  Function() onRemove,
) {
  showSwipeDialog(
    context,
    stockName: stockName,
    shares: shares,
    level: level,
    onBuy: onBuy,
    onSell: onSell,
    onMove: onMove,
    onRemove: onRemove,
  );
}
