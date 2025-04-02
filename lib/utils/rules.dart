import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planetx_client/component/op_bar.dart';
import 'package:planetx_client/model/op.dart';
import 'package:planetx_client/model/room.dart';

void showRulesDialog(BuildContext context, MapType type) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("rule_title".tr),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("sector_rules".tr),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: _ruleSectorTypeRule(type)),
                  Divider(),
                  Text("operation_rules".tr),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: _opTypeRule()),
                  Divider(),
                  Text("gameplay_rules".tr),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: _gameplayRule()),
                ],
              ),
            ),
          ),
        );
      });
}

TableCell cell(Widget child) {
  return TableCell(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: child,
    ),
  );
}

Widget _ruleSectorTypeRule(MapType type) {
  return Table(
    columnWidths: {
      0: const FlexColumnWidth(1),
      1: const FlexColumnWidth(2),
      2: const FlexColumnWidth(4),
    },
    children: SectorType.values.map((e) {
      return TableRow(
        children: [
          cell(Image.asset(e.iconName, width: 24.0, height: 24.0)),
          cell(Text(e.toString())),
          cell(Text(e.ruleLimit(type))),
        ],
      );
    }).toList(),
  );
}

Widget _opTypeRule() {
  return Table(
    columnWidths: {
      0: const FlexColumnWidth(1),
      1: const FlexColumnWidth(3),
    },
    children: OpEnum.values.map((e) {
      return TableRow(
        children: [
          cell(Text(e.name)),
          cell(Text(e.ruleLimit)),
        ],
      );
    }).toList(),
  );
}

Widget _gameplayRule() {
  return Text("gameplay_rules_desc".tr, style: TextStyle(fontSize: 14.0, color: Colors.grey[700]));
}
