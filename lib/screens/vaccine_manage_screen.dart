import 'package:flutter/material.dart';
import 'package:vacina_app/widget/custom_data_column.dart';

class VaccineManageScreen extends StatefulWidget {
  const VaccineManageScreen({super.key});

  @override
  State<VaccineManageScreen> createState() => _VaccineManageScreenState();
}

class _VaccineManageScreenState extends State<VaccineManageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Vacinas'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[900],
      ),
      body: _body(),
    );
  }

  Widget? _body() {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: CustomDataColumn().columns,
                rows: const [
                  DataRow(
                    cells: [
                      DataCell(Center(child: Text('1'))),
                      DataCell(Center(child: Text('Vacina A'))),
                      DataCell(Center(child: Text('Fabricante X'))),
                      DataCell(Center(child: Text('01/01/2023'))),
                      DataCell(Center(child: Text('01/01/2025'))),
                      DataCell(Center(child: Text('Lote 123'))),
                      DataCell(Center(child: Text('2020-01-01'))),
                      DataCell(Center(child: Text('2025-12-31'))),
                      DataCell(Center(child: Text('Posto Central'))),
                      DataCell(Center(child: Text('2 doses'))),
                      DataCell(Center(child: Text('Vacina contra o vírus X'))),
                      DataCell(Center(child: Text('50'))),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Center(child: Text('2'))),
                      DataCell(Center(child: Text('Vacina B'))),
                      DataCell(Center(child: Text('Fabricante Y'))),
                      DataCell(Center(child: Text('01/01/2023'))),
                      DataCell(Center(child: Text('01/01/2025'))),
                      DataCell(Center(child: Text('Lote 456'))),
                      DataCell(Center(child: Text('2020-01-01'))),
                      DataCell(Center(child: Text('2025-12-31'))),
                      DataCell(Center(child: Text('Posto Secundário'))),
                      DataCell(Center(child: Text('1 dose'))),
                      DataCell(Center(child: Text('Vacina contra o vírus Y'))),
                      DataCell(Center(child: Text('50'))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
