import 'package:flutter/material.dart';
import 'package:vacina_app/data/dto/campanha_request.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/repositories/local_repository.dart';
import 'package:vacina_app/data/repositories/vaccine_repository.dart';
import 'package:vacina_app/data/repositories/campanha_repository.dart';
import 'package:vacina_app/data/store/local_store.dart';
import 'package:vacina_app/data/store/vaccine_store.dart';
import 'package:vacina_app/data/store/campanha_store.dart';
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

  final CampanhaStore campanhaStore = CampanhaStore(
    repository: CampanhaRepository(client: HttpClient()),
  );

  @override
  void initState() {
    super.initState();
    getCampanhas();
  }

  Future<void> getCampanhas() async {
    await campanhaStore.getList();
    setState(() {});
  }

  void _excluirCampanha(String id) async {
    await campanhaStore.deletar(id);
    getCampanhas();
    setState(() {});
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Campanha excluída com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campanhas de Vacinação')),
      body: campanhaStore.stateList.value.isEmpty
          ? const Center(child: Text('Nenhuma campanha cadastrada.'))
          : ListView.builder(
              itemCount: campanhaStore.stateList.value.length,
              itemBuilder: (context, index) {
                final campanha = campanhaStore.stateList.value[index];
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
                                  campanha: CampanhaRequest.fromModel(campanha),
                                  vaccineStore: vaccineStore,
                                  localStore: localStore,
                                ),
                              ),
                            );
                            if (resultado != null) {
                              await campanhaStore.atualizar(
                                campanha.id,
                                resultado,
                              );
                              setState(() {
                                getCampanhas();
                              }); // Atualiza a lista
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _excluirCampanha(campanha.id),
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
            await campanhaStore.criar(resultado);
            setState(() {
              getCampanhas();
            });
          }
        },
      ),
    );
  }
}
