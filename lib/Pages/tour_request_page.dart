// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TourRequestPage extends StatefulWidget {
  TourRequestPage({Key? key});

  @override
  State<TourRequestPage> createState() => _TourRequestPageState();
}

class _TourRequestPageState extends State<TourRequestPage> {
  DateTime today = DateTime.now();
  String selectedTourTime = '';
  bool isInPersonSelected = false;
  bool isVirtualSelected = false;
  DateTime selectedDay = DateTime.now(); // Initialize with the current date

  @override
  Widget build(BuildContext context) {
    void _handleTourTimeChange(String value) {
      setState(() {
        selectedTourTime = value;
      });
    }

    void _handleInPersonTap() {
      setState(() {
        isInPersonSelected = !isInPersonSelected;
        isVirtualSelected = false;
      });
    }

    void _handleVirtualTap() {
      setState(() {
        isVirtualSelected = !isVirtualSelected;
        isInPersonSelected = false;
      });
    }

    void _handleSubmit() {
      // Handle form submission here
      print('Form submitted!');
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            Text(
              'Tour Request',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _handleInPersonTap,
                  child: Container(
                    height: 50,
                    width: 160,
                    decoration: BoxDecoration(
                      color: isInPersonSelected
                          ? Colors.blue[600]
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'In person',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                GestureDetector(
                  onTap: _handleVirtualTap,
                  child: Container(
                    height: 50,
                    width: 160,
                    decoration: BoxDecoration(
                      color: isVirtualSelected
                          ? Colors.blue[600]
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Virtual',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.calendar_month),
                ),
                Text(
                  ' Select tour date',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.blue[600]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: TableCalendar(
                  locale: 'en_us',
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  rowHeight: 35,
                  selectedDayPredicate: (day) =>
                      isSameDay(day, selectedDay), // Updated predicate
                  focusedDay: today,
                  firstDay: today,
                  lastDay: DateTime.utc(2030, 01, 01),
                  onDaySelected: (selected, focused) {
                    setState(() {
                      selectedDay = selected;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.access_time),
                ),
                Text(
                  ' Select tour time',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                const SizedBox(width: 10),
                Radio(
                  value: '12:00 PM',
                  groupValue: selectedTourTime,
                  onChanged: (value) => _handleTourTimeChange(value as String),
                ),
                const Text('12:00 PM'),
                const SizedBox(width: 20),
                Radio(
                  value: '11:00 AM',
                  groupValue: selectedTourTime,
                  onChanged: (value) => _handleTourTimeChange(value as String),
                ),
                const Text('11:00 AM'),
                const SizedBox(width: 20),
                Radio(
                  value: '7:00 PM',
                  groupValue: selectedTourTime,
                  onChanged: (value) => _handleTourTimeChange(value as String),
                ),
                const Text('7:00 PM'),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 80, right: 80),
              child: MaterialButton(
                height: 50,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.blue[600],
                onPressed: _handleSubmit,
                child: const Text(
                  'Submit',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
