import 'package:flutter/material.dart';

class ComboBox extends StatelessWidget {
  const ComboBox(
      {super.key, required this.selecionados, required this.onClick});

  final List<String> selecionados;

  final Function onClick;

  //final double itemWidth = 100; //maxwidth if item container
  final double labelWidth = 20; //maxWidth of +label

  final double letterWidth = 12;

  _itemWidget(label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 242, 242, 242),
          border: Border.all(
            //color: Theme.of(context).inputDecorationTheme.border!.borderSide.color,
            color: const Color(0xFF8c888f),
            width: 1.0,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Text(
            label,
            style: TextStyle(
                fontFamily: 'Source Sans Pro',
                color: Color(0xFF525252),
                fontSize: letterWidth,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int totalItems = selecionados.length;
      int maxDisplayItems = 0;
      List<double> dynamicItemsWidth = []; //if want to use dynamic width

      //if want to calculate based on string length
      dynamicItemsWidth = selecionados
          .map((e) => e.length * letterWidth)
          .toList(); //calculate individual item width

      double _acumWidth = 0.0;
      for (var width in dynamicItemsWidth) {
        _acumWidth = _acumWidth + width;
        if (_acumWidth < (constraints.maxWidth - labelWidth)) {
          maxDisplayItems++;
        }
      }

      return GestureDetector(
        onTap: () {
          onClick();
        },
        child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 242, 242, 242),
          border: Border.all(
            //color: Theme.of(context).inputDecorationTheme.border!.borderSide.color,
            color: const Color(0xFF8c888f),
            width: 1.0,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: List<Widget>.generate(maxDisplayItems, (index) {
                return _itemWidget(selecionados[index]);
              }).toList(),
            ),
            if ((totalItems - maxDisplayItems) > 0)
            _itemWidget("+ ${totalItems - maxDisplayItems}"),
              const Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.arrow_drop_down),
              ),
            /*Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Colors.red,
            child: Text("+1"),)*/
          ],
        ),
      ),);
    });
  }
}
