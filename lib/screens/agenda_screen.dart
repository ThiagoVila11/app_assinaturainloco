import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
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
            selectedDayPredicate: (day) =>
                isSameDay(_selectedDay, day),
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
            child: _buildEventList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    // Aqui você pode buscar eventos reais da API depois
    final mockEventos = {
      DateTime.now(): [
        "Reunião com cliente",
        "Assinatura de contrato",
      ],
    };

    final eventosDoDia = mockEventos[_selectedDay] ?? [];

    if (eventosDoDia.isEmpty) {
      return const Center(
        child: Text("Nenhum evento agendado."),
      );
    }

    return ListView.builder(
      itemCount: eventosDoDia.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.event),
          title: Text(eventosDoDia[index]),
        );
      },
    );
  }
}
