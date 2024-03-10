import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Selection<T> extends StatelessWidget {
  Selection({
    super.key,
    required this.value,
    required this.groupValue,
    this.title,
    required this.onChanged,
  });

  final T value;

  final T groupValue;

  final ValueChanged<T> onChanged;

  final String? title;

  bool get checked => groupValue == value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title == null ? '' : title!,
        style: TextStyle(
          fontFamily: 'Source Sans Pro',
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: (checked ? const Color(0xFF629784) : const Color(0xFF525252)),
        ),
      ),
      trailing: checked
          ? const Icon(Icons.check, color: Color(0xFF629784))
          : const SizedBox.shrink(),
      onTap: () {
        onChanged(value);
      },
    );
  }
}


class SelectItem<T> {
  const SelectItem({
    required this.value,
    this.title,
  });

  final T value;
  final String? title;
}

class Select<T> extends StatefulWidget {
  Select({
    super.key,
    required this.itens,
    required this.onChange,
    required this.groupValue,
  });

  final List<SelectItem<T>> itens;

  final Function onChange;

  T groupValue;

  @override
  State<Select<T>> createState() => _CustomRadioListState<T>();
}

class _CustomRadioListState<T> extends State<Select<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.itens.map(
            (e) {
          return Selection<T>(
            title: e.title,
            value: e.value,
            groupValue: widget.groupValue,
            onChanged: (T value) {
              setState(() {
                widget.onChange(value);
                widget.groupValue = value;
              });
            },
          );
        },
      ).toList(),
    );
  }
}
