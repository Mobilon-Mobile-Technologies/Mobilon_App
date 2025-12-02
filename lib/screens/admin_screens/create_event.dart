import 'package:eventa/functions/event_db.dart';
import 'package:eventa/models/events.dart';
import 'package:eventa/widgets/border_button.dart';
import 'package:eventa/widgets/gradient_box.dart';
import 'package:eventa/widgets/large_title_app_bar.dart';
import 'package:flutter/material.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  // Text controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _teamSizeController = TextEditingController();
  
  // DateTime variables to store selected dates and times
  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;
  
  
  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
      TextStyle titleStyle = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: LargeAppBar(screenHeight: screenHeight, title: "Create Event", titleStyle: titleStyle),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 150),
                  Align(
                    alignment: Alignment.topCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/crowd_img_1.jpg",
                        height: 150,
                        width: 320,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Create Event",
                    style: titleStyle.copyWith(fontSize: 24)
                  ),
                  const SizedBox(height: 20),
                  GradientBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextField("Event Name", controller: _nameController),
                        const SizedBox(height: 15),
                        buildDateTimeRow("Start", true), // true for start
                        const SizedBox(height: 15),
                        buildDateTimeRow("End", false), // false for end
                        const SizedBox(height: 15),
                        buildTextField("Location", controller: _locationController),
                        const SizedBox(height: 15),
                        buildTextField("Description", maxLines: 3, controller: _descriptionController),
                        const SizedBox(height: 15),
                        buildTextField("Capacity", isNumeric: true, controller: _capacityController),
                        const SizedBox(height: 15),
                        buildTextField("Team Size", isNumeric: true, controller: _teamSizeController),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.center,
                    child: BorderButton(
                      height: 35,
                      text: "Create Event",
                      onTap: () async {
                        // Format dates and times for the Events object
                        String formattedStartDate = startDate != null ? 
                            "${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}" : 
                            "";
                        
                        String formattedStartTime = startTime != null ? 
                            "${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}" : 
                            "";
                        
                        String formattedEndDate = endDate != null ? 
                            "${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}" : 
                            "";
                        
                        String formattedEndTime = endTime != null ? 
                            "${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}" : 
                            "";
                        
                        // Create Events object with form data
                        final newEvent = Events(
                          "", // events_id will be generated by database
                          _nameController.text,
                          formattedStartDate,
                          formattedStartTime,
                          formattedEndDate,
                          formattedEndTime,
                          _locationController.text,
                          _descriptionController.text,
                          _capacityController.text,
                          int.tryParse(_teamSizeController.text) ?? 1,
                        );
                        
                        // Call makeEvent function with the newly created Events object
                        newEvent.events_id = (await makeEvent(newEvent))!;
                                  
                        Navigator.pushReplacementNamed(context, '/event_details', arguments: newEvent);
                      },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, {
    int maxLines = 1, 
    bool isNumeric = false,
    TextEditingController? controller
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
  
  Widget buildDateTimeRow(String label, bool isStart) {
    DateTime? selectedDate = isStart ? startDate : endDate;
    TimeOfDay? selectedTime = isStart ? startTime : endTime;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: buildDateTimeButton(
                selectedDate != null 
                  ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
                  : "Select Date",
                context,
                isDate: true,
                isStart: isStart,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: buildDateTimeButton(
                selectedTime != null 
                  ? "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}"
                  : "Select Time",
                context,
                isDate: false,
                isStart: isStart,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDateTimeButton(
    String text, 
    BuildContext context, {
    required bool isDate,
    required bool isStart,
  }) {
    return ElevatedButton(
      onPressed: () async {
        if (isDate) {
          // Show Date Picker
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2030),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: Colors.deepPurple,
                    onPrimary: Colors.white,
                    surface: Colors.black,
                    onSurface: Colors.white,
                  ),
                ),
                child: child!,
              );
            },
          );
          
          if (pickedDate != null) {
            setState(() {
              if (isStart) {
                startDate = pickedDate;
              } else {
                endDate = pickedDate;
              }
            });
          }
        } else {
          // Show Time Picker
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: Colors.deepPurple,
                    onPrimary: Colors.white,
                    surface: Colors.black,
                    onSurface: Colors.white,
                  ),
                ),
                child: child!,
              );
            },
          );
          
          if (pickedTime != null) {
            setState(() {
              if (isStart) {
                startTime = pickedTime;
              } else {
                endTime = pickedTime;
              }
            });
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.2),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isDate ? Icons.calendar_today : Icons.access_time,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
