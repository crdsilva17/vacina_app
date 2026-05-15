import 'package:flutter/material.dart';

class CustomDataColumn {
  List<DataColumn> get columns {
    return const <DataColumn>[
      DataColumn(label: Text('ID')),
      DataColumn(label: Text('Nome')),
      DataColumn(label: Text('Fabricante')),
      DataColumn(label: Text('Data de Fabricação')),
      DataColumn(label: Text('Data de Validade')),
      DataColumn(label: Text('Lote')),
      DataColumn(label: Text('Idade mínima Recomendada')),
      DataColumn(label: Text('Idade máxima Recomendada')),
      DataColumn(label: Text('Posto')),
      DataColumn(label: Text('Doses')),
      DataColumn(label: Text('Descrição')),
      DataColumn(label: Text('Quantidade em Estoque')),
    ];
  }
}
