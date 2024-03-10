import 'package:flutter/material.dart';

class CustomRadio<T> extends StatelessWidget {
  const CustomRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.title,
    required this.onChanged,
  });

  final T value;

  final List<T> groupValue;

  final ValueChanged<T> onChanged;

  final String? title;

  bool get checked => groupValue.contains(value);

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

class RadioItem<T> {
  const RadioItem({
    required this.value,
    this.title,
  });

  final T value;
  final String? title;
}

class MultipleSelection<T> extends StatefulWidget {
  MultipleSelection({
    super.key,
    required this.itens,
    required this.onChange,
    required this.groupValue,
  });

  final List<RadioItem<T>> itens;

  final Function onChange;

  List<T> groupValue;

  @override
  State<MultipleSelection<T>> createState() => _MultipleSelectionState<T>();
}

class _MultipleSelectionState<T> extends State<MultipleSelection<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.itens.map(
        (e) {
          return CustomRadio<T>(
            title: e.title,
            value: e.value,
            groupValue: widget.groupValue,
            onChanged: (T value) {
              setState(() {
                if (!widget.groupValue.contains(value)) {
                  widget.groupValue.add(value);
                } else {
                  widget.groupValue.remove(value);
                }

                widget.onChange(widget.groupValue);
              });
            },
          );
        },
      ).toList(),
    );
  }
}
