import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:vacina_app/data/http/api_endpoints.dart';
import 'package:vacina_app/data/http/http_client.dart';
import 'package:vacina_app/data/models/campanha_model.dart';
import 'package:vacina_app/data/models/local_model.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';
import 'package:vacina_app/data/repositories/agendamento_repository.dart';
import 'package:vacina_app/data/repositories/local_repository.dart';
import 'package:vacina_app/widget/_primary_button.dart';
import 'package:vacina_app/widget/secundary_button.dart';
import 'package:device_calendar_plus/device_calendar_plus.dart';

class VaccineStatusCard extends StatefulWidget {
  final VaccineModel vaccineModel;
  final String ubs;
  final CampanhaModel campanhaModel;
  const VaccineStatusCard({
    super.key,
    required this.vaccineModel,
    required this.ubs,
    required this.campanhaModel,
  });

  @override
  State<VaccineStatusCard> createState() => _VaccineStatusCardState();
}

class _VaccineStatusCardState extends State<VaccineStatusCard> {
  bool hasAppointment = false;
  bool loadingAppointment = true;

  @override
  void initState() {
    super.initState();

    _loadAppointment();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.vaccines_outlined,
                      size: 50.0,
                      color: Colors.green,
                    ),
                    SizedBox(width: 22),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.greenAccent,
                              width: 0.4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.greenAccent.withValues(
                                  alpha: 0.8,
                                ),
                                blurRadius: 12,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Text(
                            'Boa Notícia!',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 7, 112, 11),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        const Text(
                          'Vacina disponível para você!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(widget.vaccineModel.name),
                        RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    label: hasAppointment
                        ? 'Cancelar Agendamento'
                        : 'Agendar Agora',
                    icon: hasAppointment ? Icons.cancel : Icons.calendar_month,
                    onPressed: () async {
                      if (loadingAppointment) {
                        return;
                      }
                      if (hasAppointment) {
                        await _cancelarAgendamento();
                        return;
                      }

                      DateFormat formatoData = DateFormat('dd/MM/yyy');
                      DateTime firstDate = formatoData.parse(
                        widget.campanhaModel.dataInicio,
                      );
                      DateTime endDate = formatoData.parse(
                        widget.campanhaModel.dataFim,
                      );
                      final data = await showDatePicker(
                        context: context,
                        firstDate: firstDate,
                        lastDate: endDate,
                      );

                      if (data == null) return;

                      if (!mounted) return;

                      await _selecionarHorario(context, data);
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: SecondaryButton(
                    label: 'Saiba mais',
                    icon: Icons.info_outline,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      widget.vaccineModel.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 22.0),
                                  Text(
                                    'Descrição',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(widget.vaccineModel.description),
                                  Text(
                                    'Fabricante',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(widget.vaccineModel.manufacturer),
                                  Text(
                                    'Data de Fabricação',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(widget.vaccineModel.manufactureDate),
                                  Text(
                                    'Validade',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(widget.vaccineModel.expiryDate),
                                  Text(
                                    'Doses',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(widget.vaccineModel.doses),
                                  Text(
                                    'Número do Lote',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(widget.vaccineModel.lot),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selecionarHorario(BuildContext context, DateTime data) async {
    final FlutterSecureStorage storage = FlutterSecureStorage();

    final token = await storage.read(key: 'token');

    if (token == null) return;

    LocalModel local = await LocalRepository(
      client: HttpClient(),
    ).getLocalByNome(widget.ubs);

    final horarios = await AgendamentoRepository(
      baseUrl: ApiEndpoints.baseUrl,
    ).getHorariosDisponiveis(local.id, data, token);

    if (!context.mounted) return;
    final parentContext = context;
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView.builder(
          itemCount: horarios.length,

          itemBuilder: (context, index) {
            final horario = horarios[index];

            return ListTile(
              leading: const Icon(Icons.access_time),

              title: Text(horario),

              onTap: () async {
                Navigator.pop(context);

                await _agendar(parentContext, data, horario);
              },
            );
          },
        );
      },
    );
  }

  Future<void> _agendar(
    BuildContext context,
    DateTime data,
    String horario,
  ) async {
    final FlutterSecureStorage storage = FlutterSecureStorage();

    try {
      final token = await storage.read(key: 'token');

      if (token == null) return;
      LocalModel local = await LocalRepository(
        client: HttpClient(),
      ).getLocalByNome(widget.ubs);

      // Create appointment in calendar
      DateTime appointment = DateTime(
        data.year,
        data.month,
        data.day,
        int.parse(horario.split(":")[0]),
        int.parse(horario.split(":")[1]),
        int.parse(horario.split(":")[2]),
      );

      final plugin = DeviceCalendar.instance;
      final listCalendarId = await plugin.listCalendars();
      String? calendarId = '0';

      for (final c in listCalendarId) {
        if (c.isPrimary) {
          calendarId = c.id;
          break;
        }
      }

      // 1. Permissions - either ask for them yourself...
      final status = await plugin.requestPermissions();
      if (status != CalendarPermissionStatus.granted) return;

      final eventId = await plugin.createEvent(
        calendarId: calendarId,
        title: 'Vacinação',
        description: 'Agendamento para vacina ${widget.vaccineModel.name}',
        location:
            '${local.rua} ${local.numero}, ${local.bairro} - ${local.cidade} ${local.estado} - ${local.cep}; ${local.name}',
        startDate: appointment,
        endDate: appointment.add(const Duration(minutes: 30)),
        reminders: [Duration(hours: 1)],
      );
      await storage.write(key: widget.vaccineModel.id, value: eventId);

      await AgendamentoRepository(
        baseUrl: ApiEndpoints.baseUrl,
      ).agendar(widget.vaccineModel.id, local.id, data, horario, token);

      if (!context.mounted) return;

      setState(() {
        hasAppointment = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agendamento realizado com sucesso')),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _cancelarAgendamento() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancelar agendamento'),
        content: const Text('Deseja realmente cancelar este agendamento?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sim'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;
    final FlutterSecureStorage storage = FlutterSecureStorage();

    try {
      final token = await storage.read(key: 'token');

      if (token == null) return;

      final id = await storage.read(key: widget.vaccineModel.id);
      final plugin = DeviceCalendar.instance;
      final event = await plugin.getEvent(id!);

      // 1. Permissions - either ask for them yourself...

      final status = await plugin.requestPermissions();
      if (status != CalendarPermissionStatus.granted) return;
      await plugin.deleteEvent(eventId: event!.eventId);

      await AgendamentoRepository(
        baseUrl: ApiEndpoints.baseUrl,
      ).cancelar(widget.vaccineModel.id, token);

      if (!mounted) return;

      setState(() {
        hasAppointment = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agendamento cancelado com sucesso')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _loadAppointment() async {
    final FlutterSecureStorage storage = FlutterSecureStorage();

    try {
      final token = await storage.read(key: 'token');

      if (token == null) {
        if (mounted) {
          setState(() {
            loadingAppointment = false;
          });
        }

        return;
      }

      final scheduled = await AgendamentoRepository(
        baseUrl: ApiEndpoints.baseUrl,
      ).isScheduled(widget.vaccineModel.id, token);

      if (!mounted) return;

      setState(() {
        hasAppointment = scheduled;

        loadingAppointment = false;
      });
    } catch (e) {
      debugPrint('Erro ao verificar agendamento: $e');

      if (!mounted) return;

      setState(() {
        loadingAppointment = false;
      });
    }
  }
}
