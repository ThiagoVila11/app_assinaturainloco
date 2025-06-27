import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _eventos = [];
  int? consultorId;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _carregarConsultorId();
  }

  Future<void> _carregarConsultorId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('consultorId');

    if (id != null) {
      setState(() {
        consultorId = id;
      });
      _buscarEventos();
    } else {
      print("consultorId não encontrado na sessão.");
    }
  }

  Future<void> _buscarEventos() async {
    if (consultorId == null) return;

    final url = Uri.parse(
      'http://192.168.3.37:8002/api/agendamentos/?AgendamentoConsultorId=$consultorId',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _eventos = data.cast<Map<String, dynamic>>();
        });
      } else {
        print('Erro ao buscar agendamentos: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    }
  }

  List<Map<String, dynamic>> _eventosDoDia(DateTime? diaSelecionado) {
    if (diaSelecionado == null) return [];

    return _eventos.where((evento) {
      final dataEvento = DateTime.parse(evento['AgendamentoData']).toLocal();
      return dataEvento.year == diaSelecionado.year &&
          dataEvento.month == diaSelecionado.month &&
          dataEvento.day == diaSelecionado.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final eventosFiltrados = _eventosDoDia(_selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agenda Semanal"),
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'pt_BR',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.week,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: eventosFiltrados.isEmpty
                ? const Center(child: Text("Nenhum evento agendado."))
                : ListView.builder(
                    itemCount: eventosFiltrados.length,
                    itemBuilder: (context, index) {
                      final evento = eventosFiltrados[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.event),
                          title: Text(evento['AgendamentoTitulo']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Cliente: ${evento['AgendamentoClienteNome']}"),
                              Text("Fone: ${evento['AgendamentoClienteTelefone']} | Email: ${evento['AgendamentoClienteEmail']}"),
                              Text("Data/Hora: ${evento['AgendamentoData']}"),
                              Text("Status: ${evento['AgendamentoStatus']}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
