import 'package:admin_page/constants/style.dart';
import 'package:admin_page/models/events.dart';
import 'package:admin_page/widgets/border_button.dart';
import 'package:admin_page/widgets/gradient_box.dart';
import 'package:admin_page/widgets/gradient_line.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:confetti/confetti.dart';

// Event info row widget used by both dialogs
class EventInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const EventInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(0.7),
            size: 18,
          ),
          SizedBox(width: 10),
          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardCard extends StatefulWidget {
  const DashboardCard({super.key, required this.event});
  final Events event;

  @override
  _DashboardCardState createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool isRegistered = false; // Track registration status

  @override
  void initState() {
    super.initState();
    checkRegistrationStatus(); // Check registration status on init
  }

  Future<void> checkRegistrationStatus() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user != null) {

      final profileData = await supabase
            .from('profile')
            .select('user_id')
            .eq('Email', user.email.toString())
            .single();

        final userId = profileData['user_id'];

      final response = await supabase
          .from('dashboard')
          .select('user_id')
          .eq('user_id', userId) // Assuming user.id is the user ID
          .eq('event_id', widget.event.events_id)
          .single();

      if (response.isNotEmpty) {
        setState(() {
          isRegistered = true; // User is registered
        });
      }
    }
  }

  // Show RSVP confirmation dialog
  void showRSVPDialog(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return _RSVPDialog(event: widget.event, screenSize: screenSize);
      },
    );
  }

  // Show event details dialog
  void showDetailsDialog(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: screenSize.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: screenSize.height * 0.8,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // Main content (removed close button)
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Event Details",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.5),
                                Colors.transparent,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          widget.event.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        EventInfoRow(
                          icon: Icons.calendar_today,
                          label: "Date",
                          value: "${widget.event.start_date} - ${widget.event.end_date}",
                        ),
                        EventInfoRow(
                          icon: Icons.access_time,
                          label: "Time",
                          value: "${widget.event.start_time} - ${widget.event.end_time}",
                        ),
                        EventInfoRow(
                          icon: Icons.location_on,
                          label: "Location",
                          value: widget.event.location,
                        ),
                        EventInfoRow(
                          icon: Icons.people,
                          label: "Capacity",
                          value: widget.event.capacity,
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                widget.event.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        // Add Done button at the bottom
                        ElevatedButton(
                          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "Done",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GradientBox(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Show the image in a dialog when tapped
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Image.asset(
                        "assets/mobile_next.jpeg", 
                        fit: BoxFit.fitHeight,
                        width: screenSize.width * 0.9,
                        height: screenSize.height * 0.5,
                      ),
                    );
                  },
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/mobile_next.jpeg",
                  fit: BoxFit.fitHeight,
                  height: screenSize.height * 0.2,
                  width: screenSize.width * 0.8, 
                ),
              ),
            ),
            GradLine(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.name,
                        style: bodyStyle
                      ),
                      Text(
                        widget.event.start_date.toString(),
                        style: subStyle,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BorderButton(
                      height: screenSize.width * 0.075,
                      text: isRegistered ? "Reserved" : "Reserve", // Change button text based on registration status
                      onTap: isRegistered ?  (){} : () => showRSVPDialog(context) 
                    ),
                    BorderButton(
                      height: screenSize.width * 0.075,
                      text: "Details",
                      onTap: () => showDetailsDialog(context)
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Stateful dialog widget to handle confetti and drag-to-confirm
class _RSVPDialog extends StatefulWidget {
  final Events event;
  final Size screenSize;

  const _RSVPDialog({required this.event, required this.screenSize});

  @override
  _RSVPDialogState createState() => _RSVPDialogState();
}

class _RSVPDialogState extends State<_RSVPDialog> {
  late ConfettiController _confettiController;
  bool _isConfirmed = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  // Method to handle RSVP confirmation
  void _confirmRSVP() async {
    if (_isConfirmed) return; // Prevent multiple confirmations
    
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    
    if (user != null) {
        // Get user profile to access enrollment number and user_id
        final profileData = await supabase
            .from('profile')
            .select('EnrollNo, user_id')
            .eq('Email', user.email.toString())
            .single();
            
        final enrollmentNumber = profileData['EnrollNo'];
        final userId = profileData['user_id'];
        
        // Generate unique key for QR code
        final uniqueKey = "${user.email}_$enrollmentNumber";
        
        // Insert RSVP record into dashboard table using the numeric user_id
        await supabase.from('dashboard').insert({
          'user_id': userId,  // Using the numeric ID from profile table
          'event_id': widget.event.events_id,
          'key': uniqueKey,
        });
        
        if (mounted) {
          setState(() {
            _isConfirmed = true;
          });
          _confettiController.play();
          
          // Show success message and close after animation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully RSVP\'d for the event!'),
              backgroundColor: Colors.green,
            ),
          );
          
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              Navigator.of(context).pop(true); // Return success
            }
          });
        }
        
       
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You need to be logged in to RSVP'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop(false); // Return failure
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isConfirmed,  // Allow popping only when not confirmed
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Confetti animation
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: 3.14, // radians (downward)
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.2,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.yellow,
              ],
            ),
          ),
          
          // Dialog content
          Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: widget.screenSize.width * 0.9,
              constraints: BoxConstraints(
                maxHeight: widget.screenSize.height * 0.8,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  // Main content (removed close button)
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _isConfirmed ? "Booking Confirmed!" : "RSVP Confirmation",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _isConfirmed ? Colors.green : Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.5),
                                  Colors.transparent,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            widget.event.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          EventInfoRow(
                            icon: Icons.calendar_today,
                            label: "Date",
                            value: "${widget.event.start_date} - ${widget.event.end_date}",
                          ),
                          EventInfoRow(
                            icon: Icons.access_time,
                            label: "Time",
                            value: "${widget.event.start_time} - ${widget.event.end_time}",
                          ),
                          EventInfoRow(
                            icon: Icons.location_on,
                            label: "Location",
                            value: widget.event.location,
                          ),
                          EventInfoRow(
                            icon: Icons.people,
                            label: "Capacity",
                            value: widget.event.capacity,
                          ),
                          SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              widget.event.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(height: 20),
                          
                          // Conditional content based on confirmation state
                          if (!_isConfirmed) ...[
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _confirmRSVP,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.withOpacity(0.8),
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Confirm RSVP",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "By confirming, you agree to attend this event",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ] else ...[
                            // Confirmation message
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 60,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Your spot has been reserved!",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "We look forward to seeing you there.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          SizedBox(height: 20),
                        ],
                      ),
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
}
