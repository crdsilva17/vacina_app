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
      child: SizedBox.expand(
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: CustomDataColumn().columns,
              rows: const [
                DataRow(
                  cells: [
                    DataCell(Text('1')),
                    DataCell(Text('Vacina A')),
                    DataCell(Text('Fabricante X')),
                    DataCell(Text('01/01/2023')),
                    DataCell(Text('01/01/2025')),
                    DataCell(Text('Lote 123')),
                    DataCell(Text('2020-01-01')),
                    DataCell(Text('2025-12-31')),
                    DataCell(Text('Posto Central')),
                    DataCell(Text('2 doses')),
                    DataCell(Text('Vacina contra o vírus X')),
                    DataCell(Text('50', textAlign: TextAlign.center)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('2')),
                    DataCell(Text('Vacina B')),
                    DataCell(Text('Fabricante Y')),
                    DataCell(Text('01/01/2023')),
                    DataCell(Text('01/01/2025')),
                    DataCell(Text('Lote 456')),
                    DataCell(Text('2020-01-01')),
                    DataCell(Text('2025-12-31')),
                    DataCell(Text('Posto Secundário')),
                    DataCell(Text('1 dose')),
                    DataCell(Text('Vacina contra o vírus Y')),
                    DataCell(Text('50')),
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
