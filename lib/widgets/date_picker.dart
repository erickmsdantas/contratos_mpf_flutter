import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  CustomDatePicker(
      {super.key,
      required this.onChanged,
      required this.anoInicial,
      required this.anoFinal,
      required this.data});

  int anoInicial;
  int anoFinal;

  ({String ano, String mes, String dia}) data;

  Function onChanged;

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  double _kItemExtent = 32.0;

  int _qtdAnos = 0;

  final List<String> _meses = [
    "Janeiro",
    "Fevereiro",
    "Março",
    "Abril",
    "Maio",
    "Junho",
    "Julho",
    "Agosto",
    "Setembro",
    "Outubro",
    "Novembro",
    "Dezembro"
  ];

  int _anoSelecionado = 0;
  int _mesSelecionado = 0;
  int _diaSelecionado = 0;

  int qtdDiasMeses = 0;

  @override
  void initState() {
    _qtdAnos = widget.anoFinal - widget.anoInicial + 1;

    _anoSelecionado = widget.data.ano.isEmpty
        ? 0
        : (int.parse(widget.data.ano) - widget.anoInicial + 1);

    _atualizarQtdDiasMes();
  }

  _atualizarQtdDiasMes() {
    if (_anoSelecionado != 0 && _mesSelecionado != 0) {
      qtdDiasMeses = DateUtils.getDaysInMonth(_anoSelecionado, _mesSelecionado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CupertinoPicker(
            magnification: 1.22,
            squeeze: 1.2,
            useMagnifier: true,
            itemExtent: _kItemExtent,
            scrollController:
                FixedExtentScrollController(initialItem: _anoSelecionado),
            onSelectedItemChanged: (int selectedItem) {
              setState(
                () {
                  _anoSelecionado = selectedItem;
                  _atualizarQtdDiasMes();
                  if (_anoSelecionado == 0) {
                    _mesSelecionado = 0;
                  }
                  widget.onChanged(
                      _anoSelecionado, _mesSelecionado, _diaSelecionado);
                },
              );
            },
            children: [
              const Text('--'),
              ...List<Widget>.generate(
                _qtdAnos,
                (int index) {
                  return Center(
                    child: Text((widget.anoInicial + index).toString()),
                  );
                },
              ),
            ],
          ),
        ),
        //
        Expanded(
          child: CupertinoPicker(
              magnification: 1.22,
              squeeze: 1.2,
              useMagnifier: true,
              itemExtent: _kItemExtent,
              onSelectedItemChanged: (int selectedItem) {
                setState(() {
                  _mesSelecionado = selectedItem;
                  _atualizarQtdDiasMes();
                  print('mes alterado: ${_anoSelecionado}');
                  widget.onChanged(
                      _anoSelecionado, _mesSelecionado, _diaSelecionado);
                });
              },
              children: [
                const Text('--'),
                ...List<Widget>.generate(
                  _anoSelecionado == 0 ? 0 : _meses.length,
                  (int index) {
                    return Center(
                      child: Text(
                        _meses[index],
                      ),
                    );
                  },
                ),
              ]),
        ),
        //
        Expanded(
          child: CupertinoPicker(
              magnification: 1.22,
              squeeze: 1.2,
              useMagnifier: true,
              itemExtent: _kItemExtent,
              // This sets the initial item.
              scrollController: FixedExtentScrollController(
                  //initialItem: _selectedFruit,
                  ),
              // This is called when selected item is changed.
              onSelectedItemChanged: (int selectedItem) {
                setState(() {
                  _diaSelecionado = selectedItem;
                  widget.onChanged(
                      _anoSelecionado, _mesSelecionado, _diaSelecionado);
                });
              },
              children: [
                const Text("--"),
                ...List<Widget>.generate(
                  _mesSelecionado == 0 ? 0 : qtdDiasMeses,
                  (int index) {
                    return Center(
                      child: Text((index + 1).toString()),
                    );
                  },
                ),
              ]),
        ),
      ],
    );
  }
}
