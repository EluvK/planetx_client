import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planetx_client/model/op.dart';

class _PickerDialog<T> extends StatefulWidget {
  const _PickerDialog({super.key, required this.items, required this.title, required this.toItemWidget});
  final List<T> items;
  final String title;
  final Widget Function(T) toItemWidget;

  @override
  State<_PickerDialog<T>> createState() => _PickerDialogState<T>();
}

class _PickerDialogState<T> extends State<_PickerDialog<T>> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: double.minPositive,
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.center,
          children: [
            for (var item in widget.items)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(item);
                },
                child: widget.toItemWidget(item),
              ),
          ],
        ),
      ),
    );
  }
}

class _Picker<T> extends StatelessWidget {
  final T value;
  final ValueChanged<T> onChanged;
  final List<T> items;
  final String title;
  final Widget Function(T) toItemWidget;
  final Widget Function(T)? toResultWidget;

  const _Picker({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
    required this.title,
    required this.toItemWidget,
    this.toResultWidget,
  });

  Future<void> _showPickerDialog(BuildContext context) async {
    final result = await showDialog<T>(
      context: context,
      builder: (context) => _PickerDialog(items: items, title: title, toItemWidget: toItemWidget),
    );
    if (result != null) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showPickerDialog(context),
      child: toResultWidget?.call(value) ?? toItemWidget(value),
    );
  }
}

class SectorPicker extends _Picker<SectorType> {
  final bool includeX;

  SectorPicker({
    super.key,
    required super.value,
    required super.onChanged,
    this.includeX = true,
  }) : super(
          items: SectorType.values.where((t) => t != SectorType.X).toList(),
          title: '选择类型',
          toItemWidget: (SectorType t) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(t.iconName, width: 24, height: 24),
              Text(" ${t.name}"),
            ],
          ),
          toResultWidget: (SectorType t) => Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(t.iconName, width: 24, height: 24),
                Text(" ${t.name}"),
              ],
            ),
          ),
        );
}

class NumberPicker extends _Picker<int> {
  final int? from;
  final int? to;
  final int? step;
  final int? max;
  final List<int>? numbers;

  NumberPicker({
    super.key,
    required super.value,
    required super.onChanged,
    required super.title,
    this.numbers,
    this.from,
    this.to,
    this.step = 1,
    this.max,
    TextStyle? style,
    Color? color,
  })  : assert(
          (numbers != null) ^ (from != null && to != null && step != null && max != null),
          '必须提供numbers列表或者from/to/step/max范围',
        ),
        super(
          items: numbers?.toList() ?? _getNumbers(from!, to!, step!, max!),
          toItemWidget: (int number) => Text(" ${number.toString()} "),
          toResultWidget: (int number) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              number.toString(),
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
        );
}

List<int> _getNumbers(int from, int to, int step, int max) {
  assert(step > 0 && max > 0 && from <= max && to <= max);
  final numbers = <int>[];
  if (from <= to) {
    for (var i = from; i <= to; i += step) {
      numbers.add(i);
    }
  } else {
    var i = from;
    for (; i <= max; i += step) {
      numbers.add(i);
    }
    i = i - max;
    for (; i <= to; i += step) {
      numbers.add(i);
    }
  }
  return numbers;
}

class CluePicker extends _Picker<ClueEnum> {
  final List<ClueSecret> clueSecrets;
  final List<Clue> clueDetails;
  CluePicker({
    super.key,
    required this.clueSecrets,
    required this.clueDetails,
    required super.value,
    required super.onChanged,
  }) : super(
          items: clueSecrets.map((e) => e.index).toList(),
          title: '选择线索',
          toItemWidget: (ClueEnum t) {
            final current = clueSecrets.firstWhere((e) => e.index == t);
            final known = clueDetails.firstWhereOrNull((e) => e.index == t);
            if (known != null) {
              return Text("${current.index.name} ${current.secret} ✅");
            }
            return Text("${current.index.name} ${current.secret}");
          },
          toResultWidget: (ClueEnum t) {
            final current = clueSecrets.firstWhere((e) => e.index == t);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                current.index.name,
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            );
          },
        );
}
