import 'package:eventa/functions/event_db.dart';
import 'package:eventa/models/events.dart';
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

  late String startDate;
  late String startTime;
  late String endDate;
  late String endTime;
  
  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing event data
    nameController = TextEditingController(text: widget.event.name);
    locationController = TextEditingController(text: widget.event.location);
    descriptionController = TextEditingController(text: widget.event.description);
    capacityController = TextEditingController(text: widget.event.capacity);

    startDate = widget.event.start_date;
    startTime = widget.event.start_time;
    endDate = widget.event.end_date;
    endTime = widget.event.end_time;
  }
  
  @override
  void dispose() {
    // Clean up controllers
    nameController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(23, 0, 0, 0),
        elevation: 0,
        title: const Text(
          "Edit Event",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
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
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Align(
                    alignment: Alignment.topCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        "assets/Background.png",
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Edit Event",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextField("Event Name", controller: nameController),
                        const SizedBox(height: 15),
                        buildDateTimeRow("Start", context, widget.event.start_date, widget.event.start_time),
                        const SizedBox(height: 15),
                        buildDateTimeRow("End", context, widget.event.end_date, widget.event.end_time),
                        const SizedBox(height: 15),
                        buildTextField("Location", controller: locationController),
                        const SizedBox(height: 15),
                        buildTextField("Description", maxLines: 3, controller: descriptionController),
                        const SizedBox(height: 15),
                        buildTextField("Capacity", isNumeric: true, controller: capacityController),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      child: ElevatedButton(
                        onPressed: () async {
                            final updatedEvent = Events(
                            widget.event.events_id, // Keep the original ID
                            nameController.text,
                            startDate,
                            startTime,
                            endDate,
                            endTime,
                            locationController.text,
                            descriptionController.text,
                            capacityController.text,
                          );
                          
                          // Call updateEvent function
                          await updateEvent(updatedEvent);
                          
                          // Navigate back
                          if (mounted) {
                            Navigator.pushReplacementNamed(context, '/event_details', arguments: updatedEvent);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(249, 0, 0, 1),
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.white, width: 2)
                          )
                        ),
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
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

  Widget buildDateTimeRow(String label, BuildContext context, String date, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
        ),
        Row(
          children: [
            buildDateTimeButton(date, context),
            const SizedBox(width: 10),
            buildDateTimeButton(time, context),
          ],
        ),
      ],
    );
  }

  Widget buildDateTimeButton(String text, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Date/time picker would go here
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withOpacity(0.2),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
