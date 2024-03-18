class Item {
  String itemFornecido = '';
  String valorUnitario = '';
  String quantidade = '';
  String valorTotalDoItem = '';
  String unidade = '';

  Item(
      {required this.itemFornecido,
      required this.valorUnitario,
      required this.quantidade,
      required this.valorTotalDoItem,
      required this.unidade});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      itemFornecido: map['item_fornecido'] ?? '',
      valorUnitario: map['valor_unitario'] ?? '',
      quantidade: map['quantidade'] ?? '',
      valorTotalDoItem: map['valor_total'] ?? '',
      unidade: map['unidade_de_medida'] ?? '',
    );
  }
}
