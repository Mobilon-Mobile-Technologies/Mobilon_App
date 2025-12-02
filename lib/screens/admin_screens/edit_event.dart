import 'package:eventa/functions/event_db.dart';
import 'package:eventa/models/events.dart';
import 'package:eventa/widgets/border_button.dart';
import 'package:eventa/widgets/gradient_box.dart';
import 'package:eventa/widgets/large_title_app_bar.dart';
import 'package:flutter/material.dart';

class EditEventScreen extends StatefulWidget {
  final Events event;
  const EditEventScreen({super.key, required this.event});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  // Controllers for text fields
  late TextEditingController nameController;
  late TextEditingController locationController;
  late TextEditingController descriptionController;
  late TextEditingController capacityController;
  late TextEditingController teamSizeController;
  
  // DateTime variables
  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;
  
  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing event data
    nameController = TextEditingController(text: widget.event.name);
    locationController = TextEditingController(text: widget.event.location);
    descriptionController = TextEditingController(text: widget.event.description);
    capacityController = TextEditingController(text: widget.event.capacity);
    teamSizeController = TextEditingController(text: widget.event.team_size.toString());
    
    // Parse existing dates and times
    startDate = DateTime.parse(widget.event.start_date);
    final startTimeParts = widget.event.start_time.split(':');
    startTime = TimeOfDay(
      hour: int.parse(startTimeParts[0]), 
      minute: int.parse(startTimeParts[1])
    );
    
    endDate = DateTime.parse(widget.event.end_date);
    final endTimeParts = widget.event.end_time.split(':');
    endTime = TimeOfDay(
      hour: int.parse(endTimeParts[0]), 
      minute: int.parse(endTimeParts[1])
    );
  }
  
  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
        double screenHeight = MediaQuery.sizeOf(context).height;
      TextStyle titleStyle = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 45);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: LargeAppBar(screenHeight: screenHeight, title: "Edit Event", titleStyle: titleStyle),
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
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
                Center(
                  child: Text(
                    "Edit Event",
                    style: titleStyle.copyWith(fontSize: 24)
                  ),
                ),
                const SizedBox(height: 20),
                GradientBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextField("Event Name", controller: nameController),
                      const SizedBox(height: 15),
                      buildDateTimeRow("Start", true),
                      const SizedBox(height: 15),
                      buildDateTimeRow("End", false),
                      const SizedBox(height: 15),
                      buildTextField("Location", controller: locationController),
                      const SizedBox(height: 15),
                      buildTextField("Description", maxLines: 3, controller: descriptionController),
                      const SizedBox(height: 15),
                      buildTextField("Capacity", isNumeric: true, controller: capacityController),
                      const SizedBox(height: 15),
                      buildTextField("Team Size", isNumeric: true, controller: teamSizeController),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    child: BorderButton(
                      height: 35,
                      text: "Save Changes",
                      onTap: () async {
                        // Format dates and times
                        String formattedStartDate = startDate != null ? 
                            "${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}" : 
                            widget.event.start_date;
                        
                        String formattedStartTime = startTime != null ? 
                            "${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}" : 
                            widget.event.start_time;
                        
                        String formattedEndDate = endDate != null ? 
                            "${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}" : 
                            widget.event.end_date;
                        
                        String formattedEndTime = endTime != null ? 
                            "${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}" : 
                            widget.event.end_time;
                        
                        final updatedEvent = Events(
                          widget.event.events_id,
                          nameController.text,
                          formattedStartDate,
                          formattedStartTime,
                          formattedEndDate,
                          formattedEndTime,
                          locationController.text,
                          descriptionController.text,
                          capacityController.text,
                          teamSizeController.text.isNotEmpty ? int.parse(teamSizeController.text) : widget.event.team_size,
                        );
                        
                        await updateEvent(updatedEvent);
                        
                        if (mounted) {
                          Navigator.pushReplacementNamed(context, '/event_details', arguments: updatedEvent);
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String label, {
    int maxLines = 1, 
    bool isNumeric = false,
    required TextEditingController controller
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
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
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
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: isStart ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now()),
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
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: isStart ? (startTime ?? TimeOfDay.now()) : (endTime ?? TimeOfDay.now()),
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
