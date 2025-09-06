import 'package:admin_page/screens/admin_screens/admin_dash.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CreateEventScreen(),
    );
  }
}

class CreateEventScreen extends StatelessWidget {
  const CreateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminDash(userType: "Admin")),
                );
              },
              icon: const Icon(Icons.arrow_back, color: Colors.blue),
            );
          },
        ),
        backgroundColor: const Color.fromARGB(23, 0, 0, 0),
        
        elevation: 0,
        title: const Text(
          "Create Event",
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
                    "Create Event",
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
                      color: Colors.black.withOpacity(0.5), // Darker opacity for better visibility
                      borderRadius: BorderRadius.circular(20), // Curved Borders
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextField("Event Name"),
                        const SizedBox(height: 15),
                        buildDateTimeRow("Start", context),
                        const SizedBox(height: 15),
                        buildDateTimeRow("End", context),
                        const SizedBox(height: 15),
                        buildTextField("Location"),
                        const SizedBox(height: 15),
                        buildTextField("Description", maxLines: 3),
                        const SizedBox(height: 15),
                        buildTextField("Capacity", isNumeric: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      child: ElevatedButton(onPressed: (){}, 
                      style:ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(249, 0, 0, 1),
                        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.white,width: 2)
                        )
                      ) ,
                      child:
                      Text("Create the Event",style: TextStyle(color: Colors.white),),),
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

  
  Widget buildTextField(String label, {int maxLines = 1, bool isNumeric = false}) {
    return TextField(
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

  
  Widget buildDateTimeRow(String label, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
        ),
        Row(
          children: [
            buildDateTimeButton("Jan 6, 2025", context),
            const SizedBox(width: 10),
            buildDateTimeButton("6:30 PM", context),
          ],
        ),
      ],
    );
  }

  
  Widget buildDateTimeButton(String text, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        
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
