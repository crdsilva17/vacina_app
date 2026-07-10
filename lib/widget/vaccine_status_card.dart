import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:vacina_app/data/http/api_endpoints.dart';
import 'package:vacina_app/data/models/agendamento_model.dart';
import 'package:vacina_app/data/models/campanha_model.dart';
import 'package:vacina_app/data/models/local_model.dart';
import 'package:vacina_app/data/models/vaccine_model.dart';
import 'package:vacina_app/data/repositories/agendamento_repository.dart';
import 'package:vacina_app/widget/_primary_button.dart';
import 'package:vacina_app/widget/secundary_button.dart';
import 'package:device_calendar_plus/device_calendar_plus.dart';

class VaccineStatusCard extends StatefulWidget {
  final VaccineModel vaccineModel;
  final LocalModel ubs;
  final String userId;
  final CampanhaModel campanhaModel;
  const VaccineStatusCard({
    super.key,
    required this.vaccineModel,
    required this.ubs,
    required this.userId,
    required this.campanhaModel,
  });

  @override
  State<VaccineStatusCard> createState() => _VaccineStatusCardState();
}

class _VaccineStatusCardState extends State<VaccineStatusCard> {
  bool hasAppointment = false;
  bool loadingAppointment = true;
  bool _carregandoHorarios = false;
  String dataAgendamento = '';
  String horarioAgendamento = '';

  @override
  void initState() {
    super.initState();

    _loadAppointment();
  }

  @override
  Widget build(BuildContext context) {
    return loadingAppointment
        ? Padding(
            padding: const EdgeInsets.all(40.0),
            child: SizedBox(child: CircularProgressIndicator()),
          )
        : Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 8,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.vaccines_outlined,
                            size: 50.0,
                            color: hasAppointment ? Colors.blue : Colors.green,
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
                                  color: hasAppointment
                                      ? Colors.blueAccent.withValues(alpha: 0.8)
                                      : Colors.greenAccent.withValues(
                                          alpha: 0.8,
                                        ),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: hasAppointment
                                        ? Colors.blueAccent
                                        : Colors.greenAccent,
                                    width: 0.4,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: hasAppointment
                                          ? Colors.blueAccent.withValues(
                                              alpha: 0.8,
                                            )
                                          : Colors.greenAccent.withValues(
                                              alpha: 0.8,
                                            ),
                                      blurRadius: 12,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  hasAppointment ? 'Agendada' : 'Boa Notícia!',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: hasAppointment
                                        ? Color.fromARGB(255, 7, 11, 112)
                                        : Color.fromARGB(255, 7, 112, 11),
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
                              SizedBox(height: 10),
                              Text(widget.vaccineModel.name),
                              SizedBox(height: 10),
                              if (_carregandoHorarios) ...[
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    SizedBox(
                                      width: 10,
                                      height: 10,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ), // Círculo pequeno e discreto
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "Buscando horários disponíveis...",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                              hasAppointment
                                  ? RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Icon(
                                              Icons.location_on_outlined,
                                              size: 18,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: Text(widget.ubs.name),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              hasAppointment
                                  ? RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Text(dataAgendamento),
                                          ),
                                          WidgetSpan(
                                            child: Text(horarioAgendamento),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
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
                          icon: hasAppointment
                              ? Icons.cancel
                              : Icons.calendar_month,
                          isAppointment: hasAppointment,
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

                            setState(() => _carregandoHorarios = true);

                            try {
                              await _selecionarHorario(context, data);
                            } finally {
                              // Desativa assim que o BottomSheet abrir ou se der erro
                              if (mounted) {
                                setState(() => _carregandoHorarios = false);
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: SecondaryButton(
                          label: 'Saiba mais',
                          icon: Icons.info_outline,
                          isAppointment: hasAppointment,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                        Text(
                                          widget.vaccineModel.manufactureDate,
                                        ),
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

    final horarios = await AgendamentoRepository(
      baseUrl: ApiEndpoints.baseUrl,
    ).getHorariosDisponiveis(widget.ubs.id, data, token);

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

      final local = widget.ubs;

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
        dataAgendamento = DateFormat('dd/MM/yyyy').format(data);
        horarioAgendamento = ' às $horario';
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
        dataAgendamento = '';
        horarioAgendamento = '';
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

      final agendamentos = await AgendamentoRepository(
        baseUrl: ApiEndpoints.baseUrl,
      ).getAgendamentos(widget.userId, token);

      if (!mounted) return;

      setState(() {
        if (agendamentos.isNotEmpty) {
          AgendamentoModel agendamentoModel = agendamentos.firstWhere(
            (a) => a.vacinaId == widget.vaccineModel.id,
          );
          DateTime data = DateTime.parse(agendamentoModel.data);
          dataAgendamento = DateFormat('dd/MM/yyyy').format(data);
          horarioAgendamento = ' às ${agendamentoModel.horario}';
        }
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
