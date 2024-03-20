import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contratos_mpf/contratados/models/contratado.dart';
import 'package:contratos_mpf/contratados/screens/contratados_detalhes.dart';
import 'package:contratos_mpf/firebase_repository.dart';
import 'package:contratos_mpf/utils/ordem.dart';
import 'package:contratos_mpf/widgets/multiple_select.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:contratos_mpf/contratos/widgets/campo_busca.dart';

enum ClassificacaoContratados { cnpjcpf, nome, qtdContratos }

class ContratadosLista extends StatefulWidget {
  const ContratadosLista({super.key, required this.contratados});

  final List<Contratado> contratados;

  @override
  State<ContratadosLista> createState() => _ContratadosListaState();
}

class _ContratadosListaState extends State<ContratadosLista> {
  ClassificacaoContratados _classificacaoContrato =
      ClassificacaoContratados.cnpjcpf;

  OrdemClassificacao _ordemClassificacao = OrdemClassificacao.crescente;

  SliverWoltModalSheetPage classificarContratados(
      BuildContext modalSheetContext, TextTheme textTheme) {
    return WoltModalSheetPage(
      hasSabGradient: false,
      topBarTitle: Container(
        alignment: Alignment.centerLeft,
        constraints: const BoxConstraints.expand(),
        child: const Text(
          'ORDERNAR POR',
          style: TextStyle(
            fontFamily: 'Source Sans Pro',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF525252),
          ),
        ),
      ),
      isTopBarLayerAlwaysVisible: true,
      trailingNavBarWidget: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextButton(
          onPressed: () {
            Navigator.of(modalSheetContext).pop();
          },
          child: const Text("Aplicar"),
        ),
      ),
      child: Column(
        children: [
          MultipleSelection(
            groupValue: [_classificacaoContrato],
            itens: const [
              RadioItem(
                title: "CPF/CNP",
                value: ClassificacaoContratados.cnpjcpf,
              ),
              RadioItem(
                title: "Nome",
                value: ClassificacaoContratados.nome,
              ),
              RadioItem(
                title: "Quantidade De Contratos",
                value: ClassificacaoContratados.qtdContratos,
              )
            ],
            onChange: (ClassificacaoContratados value) {
              setState(() {
                _classificacaoContrato = value;
              });
            },
          ),
          const Divider(),
          MultipleSelection(
            groupValue: [_ordemClassificacao],
            itens: const [
              RadioItem(
                title: "Crescente",
                value: OrdemClassificacao.crescente,
              ),
              RadioItem(
                title: "Decrescente",
                value: OrdemClassificacao.decrescente,
              )
            ],
            onChange: (OrdemClassificacao value) {
              print(value.name);
              _ordemClassificacao = value;
            },
          ),
        ],
      ),
    );
  }

  Widget mostarResultadosBusca(BuildContext context, qtdContratados) {
    return Row(
      children: [
        Text('${qtdContratados} Resultados'),
        const Spacer(flex: 1),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              WoltModalSheet.show<void>(
                context: context,
                pageListBuilder: (modalSheetContext) {
                  final textTheme = Theme.of(context).textTheme;
                  return [
                    classificarContratados(modalSheetContext, textTheme),
                  ];
                },
                onModalDismissedWithBarrierTap: () {
                  Navigator.of(context).pop();
                },
                maxDialogWidth: 560,
                minDialogWidth: 400,
                minPageHeight: 0.0,
                maxPageHeight: 0.9,
              );
            },
          ),
        ),
        IconButton(icon: const Icon(Icons.download), onPressed: () {}),
      ],
    );
  }

  Widget criarLista() {
    CollectionReference<Contratado> collection =
        FirebaseRepository.instance.contratadosCollection;

    Query<Contratado> query1 = collection.limit(100);

    return FirestoreQueryBuilder<Contratado>(
      query: query1,
      pageSize: 5,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('error ${snapshot.error}');
        }

        final data = snapshot.docs;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: FutureBuilder<AggregateQuerySnapshot>(
                future: query1.count().get(),
                builder: (BuildContext context,
                    AsyncSnapshot<AggregateQuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return mostarResultadosBusca(context, snapshot.data!.count);
                  } else
                    return Text("");
                },
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: data.length,
                shrinkWrap: true,
                separatorBuilder: (BuildContext context, int index) =>
                    const SizedBox(height: 3),
                itemBuilder: (context, index) {
                  if (snapshot.hasMore && index + 1 == data.length) {
                    snapshot.fetchMore();
                  }

                  var contratado = data.elementAt(index).data();
                  return GestureDetector(
                    onTap: () {},
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.leftToRight,
                            child: ContratadoDetalhes(
                              contratado: contratado,
                            ),
                          ),
                        );
                      },
                      title: Text(contratado.cpfCnpj),
                      subtitle: Text(contratado.nome),
                      tileColor: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CampoBusca(
          onChanged: (text) {
            setState(() {
              //textoBusca = text;
            });
          },
        ),
        Expanded(
          child: criarLista(),
        ),
      ],
    );
  }
}
