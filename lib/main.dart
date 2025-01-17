import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(CalendarApp());

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalendarScreen(),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime? _selectedDate;
  DateTime _focusedDate = DateTime.now();
  DateTime _calendarDate = DateTime.now();

  String getShortMonth(DateTime date) {
    return DateFormat.MMM().format(date);
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM d').format(date); // Форматирование в "Aug 27"
  }

  final Map<DateTime, String> events = {
    DateTime(2025, 1, 16): "🎉 Event",
    DateTime(2025, 1, 20): "📌 Task",
    DateTime(2025, 1, 25): "✔ Done",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Image(
          image: AssetImage('assets/images/leading_pic.png'),
        ),
        title: Text(
          getShortMonth(_calendarDate),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.calendar_month),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            flex: 4,
            child: TableCalendar(
              headerVisible: false,
              onPageChanged: (focusedDay) {
                setState(() {
                  _calendarDate = focusedDay;
                  _focusedDate = focusedDay;
                });
              },
              focusedDay: _focusedDate,
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDate, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDate = focusedDay;
                });
              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarStyle: CalendarStyle(
                canMarkersOverflow: true,
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.orange,
                ),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, context);
                },
                todayBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, context, isToday: true);
                },
                selectedBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, context, isSelected: true);
                },
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatDate(_selectedDate ?? _focusedDate),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Cycle Day 12 - Follicular Phase',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _editEvent(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.white),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.water_drop,
                              color: Colors.red,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Divider(
                    color: Color(0xffEEEEEE),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        'Medium - ',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Chance of getting pregnant',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _editEvent(BuildContext context) {
    if (_selectedDate == null) return;

    String? currentEvent = events[DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day)];

    TextEditingController controller = TextEditingController(text: currentEvent);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Event'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter event description'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  events[DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day)] = controller.text;
                });
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDayCell(DateTime day, BuildContext context,
      {bool isToday = false, bool isSelected = false}) {
    String? event = events[DateTime(day.year, day.month, day.day)];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: isToday
              ? BoxDecoration(
            color: Colors.orangeAccent,
            shape: BoxShape.circle,
          )
              : isSelected
              ? BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          )
              : null,

          child: Text(
            day.day.toString(),
            style: TextStyle(
              color: isToday ? Colors.white : null,
              fontWeight: isToday || isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        if (event != null) // Отображаем текст/эмодзи, если он есть
          Text(
            event,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
      ],
    );
  }
}
