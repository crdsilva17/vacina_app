import 'package:flutter/material.dart';
import 'package:vacina_app/data/dto/campanha_request.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/campanha_model.dart';
import 'package:vacina_app/data/repositories/local_repository.dart';
import 'package:vacina_app/data/repositories/vaccine_repository.dart';
import 'package:vacina_app/data/store/local_store.dart';
import 'package:vacina_app/data/store/vaccine_store.dart';
import 'package:vacina_app/screens/campanha_form_screen.dart'; // Vamos criar a seguir

class CampanhaListScreen extends StatefulWidget {
  const CampanhaListScreen({super.key});

  @override
  State<CampanhaListScreen> createState() => _CampanhaListScreenState();
}

class _CampanhaListScreenState extends State<CampanhaListScreen> {
  final VaccineStore vaccineStore = VaccineStore(
    repository: VaccineRepository(client: HttpClient()),
  );
  final LocalStore localStore = LocalStore(
    repository: LocalRepository(client: HttpClient()),
  );

  // Simulando uma lista que viria da sua API Get
  List<CampanhaModel> campanhasMock = [
    CampanhaModel(
      id: "6a502db4e01100bfb67e3d60",
      nome: "Campanha da Gripe 2026",
      vacinaId: "vac-influenza",
      localIds: ["posto-central", "posto-bairro"],
      dataInicio: "2026-05-01",
      dataFim: "2026-06-01",
      ageMin: "10",
      ageMax: "60",
    ),
  ];

  void _excluirCampanha(String id) {
    setState(() {
      // No cenário real, faça o await client.delete("url/$id");
      campanhasMock.removeWhere((c) => c.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Campanha excluída com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campanhas de Vacinação')),
      body: campanhasMock.isEmpty
          ? const Center(child: Text('Nenhuma campanha cadastrada.'))
          : ListView.builder(
              itemCount: campanhasMock.length,
              itemBuilder: (context, index) {
                final campanha = CampanhaRequest.fromModel(
                  campanhasMock[index],
                );
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      campanha.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Período: ${campanha.dataInicio} até ${campanha.dataFim}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            // Abre a tela de formulário passando a campanha para EDIÇÃO
                            final resultado = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CampanhaFormScreen(
                                  campanha: campanha,
                                  vaccineStore: vaccineStore,
                                  localStore: localStore,
                                ),
                              ),
                            );
                            if (resultado != null)
                              setState(() {}); // Atualiza a lista
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _excluirCampanha(
                            campanhasMock
                                .firstWhere((c) => c.nome == campanha.nome)
                                .id,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // Abre a tela de formulário sem campanha para CRIAÇÃO
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CampanhaFormScreen(
                vaccineStore: vaccineStore,
                localStore: localStore,
              ),
            ),
          );
          if (resultado != null) {
            setState(() {
              campanhasMock.add(resultado as CampanhaModel);
            });
          }
        },
      ),
    );
  }
}
