import 'package:flutter/material.dart';

class CustomDataColumn {
  List<DataColumn> get columnsVaccine {
    return const <DataColumn>[
      DataColumn(
        label: Expanded(child: Text('ID', textAlign: TextAlign.center)),
      ),
      DataColumn(
        label: Expanded(child: Text('Nome', textAlign: TextAlign.center)),
      ),
      DataColumn(
        label: Expanded(child: Text('Fabricante', textAlign: TextAlign.center)),
      ),
      DataColumn(
        label: Expanded(
          child: Text('Data de Fabricação', textAlign: TextAlign.center),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text('Data de Validade', textAlign: TextAlign.center),
        ),
      ),
      DataColumn(
        label: Expanded(child: Text('Lote', textAlign: TextAlign.center)),
      ),
      DataColumn(
        label: Expanded(child: Text('Doses', textAlign: TextAlign.center)),
      ),
      DataColumn(
        label: Expanded(child: Text('Descrição', textAlign: TextAlign.center)),
      ),
      DataColumn(label: Expanded(child: Text('Editar'))),
      DataColumn(label: Expanded(child: Text('Excluir'))),
    ];
  }

  List<DataColumn> get columnsLocal {
    return const <DataColumn>[
      DataColumn(
        label: Expanded(child: Text('ID', textAlign: TextAlign.center)),
      ),
      DataColumn(
        label: Expanded(child: Text('Nome', textAlign: TextAlign.center)),
      ),
      DataColumn(
        label: Expanded(child: Text('Numero', textAlign: TextAlign.center)),
      ),
      DataColumn(
        label: Expanded(child: Text('Rua', textAlign: TextAlign.center)),
      ),
      DataColumn(
        label: Expanded(child: Text('Bairro', textAlign: TextAlign.center)),
      ),
      DataColumn(
        label: Expanded(child: Text('Cidade', textAlign: TextAlign.center)),
      ),
      DataColumn(
        label: Expanded(child: Text('Estado', textAlign: TextAlign.center)),
      ),
      DataColumn(
        label: Expanded(child: Text('CEP', textAlign: TextAlign.center)),
      ),
      DataColumn(
        label: Expanded(
          child: Text('Horário de Funcionamento', textAlign: TextAlign.center),
        ),
      ),
      DataColumn(
        label: Expanded(child: Text('Editar', textAlign: TextAlign.center)),
      ),
      DataColumn(
        label: Expanded(child: Text('Excluir', textAlign: TextAlign.center)),
      ),
    ];
  }
}
