import 'package:flutter/material.dart';

class CustomDataColumn {
  List<DataColumn> get columns {
    return const <DataColumn>[
      DataColumn(label: Expanded(child: Text('ID', textAlign: TextAlign.center))),
      DataColumn(label: Expanded(child: Text('Nome', textAlign: TextAlign.center))),
      DataColumn(label: Expanded(child: Text('Fabricante', textAlign: TextAlign.center))),
      DataColumn(label: Expanded(child: Text('Data de Fabricação', textAlign: TextAlign.center))),
      DataColumn(label: Expanded(child: Text('Data de Validade', textAlign: TextAlign.center))),
      DataColumn(label: Expanded(child: Text('Lote', textAlign: TextAlign.center))),
      DataColumn(label: Expanded(child: Text('Idade mínima Recomendada', textAlign: TextAlign.center))),
      DataColumn(label: Expanded(child: Text('Idade máxima Recomendada', textAlign: TextAlign.center))),
      DataColumn(label: Expanded(child: Text('Posto', textAlign: TextAlign.center))),
      DataColumn(label: Expanded(child: Text('Doses', textAlign: TextAlign.center))),
      DataColumn(label: Expanded(child: Text('Descrição', textAlign: TextAlign.center))),
      DataColumn(label: Expanded(child: Text('Quantidade em Estoque', textAlign: TextAlign.center))),
    ];
  }
}
