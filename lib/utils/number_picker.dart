import 'package:flutter/material.dart';

class NumberPickerDialog extends StatefulWidget {
  final int initialValue;
  final List<int>? numbers;
  final int? from;
  final int? to;
  final int? step;
  final String title;

  const NumberPickerDialog({
    super.key,
    required this.initialValue,
    this.numbers,
    this.from,
    this.to,
    this.step = 1,
    this.title = '请选择',
  }) : assert(
          (numbers != null) ^ (from != null && to != null && step != null),
          '必须提供numbers列表或者from/to/step范围',
        );

  @override
  State<NumberPickerDialog> createState() => _NumberPickerDialogState();
}

class _NumberPickerDialogState extends State<NumberPickerDialog> {
  @override
  void initState() {
    super.initState();
  }

  List<int> _getNumbers() {
    if (widget.numbers != null) {
      return widget.numbers!;
    } else {
      final numbers = <int>[];
      for (var i = widget.from!; i <= widget.to!; i += widget.step!) {
        numbers.add(i);
      }
      return numbers;
    }
  }

  @override
  Widget build(BuildContext context) {
    final numbers = _getNumbers();

    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.minPositive,
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.center,
          children: [
            for (var number in numbers)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, number);
                },
                child: Text(number.toString()),
              ),
          ],
        ),
      ),
    );
  }
}

class NumberPicker extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final List<int>? numbers;
  final int? from;
  final int? to;
  final int? step;
  final String title;
  final TextStyle? style;
  final Color? color;

  const NumberPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.numbers,
    this.from,
    this.to,
    this.step = 1,
    this.title = '请选择',
    this.style,
    this.color,
  }) : assert(
          (numbers != null) ^ (from != null && to != null && step != null),
          '必须提供numbers列表或者from/to/step范围',
        );

  Future<void> _showNumberPickerDialog(BuildContext context) async {
    final result = await showDialog<int>(
      context: context,
      builder: (context) => NumberPickerDialog(
        initialValue: value,
        numbers: numbers,
        from: from,
        to: to,
        step: step,
        title: title,
      ),
    );

    if (result != null && result != value) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showNumberPickerDialog(context),
      child: Text(
        "  ${value.toString()}  ",
        style: (style ?? Theme.of(context).textTheme.bodyLarge)?.copyWith(
          color: color ?? Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
