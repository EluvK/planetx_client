import 'package:flutter/material.dart';

class OpLog extends StatefulWidget {
  const OpLog({super.key});

  @override
  State<OpLog> createState() => _OpLogState();
}

class _OpLogState extends State<OpLog> {
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Op"),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Result"),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Other - A"),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Other - B"),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Other - C"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
