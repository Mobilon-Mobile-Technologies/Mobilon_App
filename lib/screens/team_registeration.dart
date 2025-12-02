import 'package:eventa/widgets/gradient_box.dart';
import 'package:flutter/material.dart';
import 'package:eventa/models/events.dart';
import 'package:eventa/functions/reserve.dart';

class TeamMember {
  final TextEditingController nameController;
  final TextEditingController emailController;

  TeamMember()
      : nameController = TextEditingController(),
        emailController = TextEditingController();

  void dispose() {
    nameController.dispose();
    emailController.dispose();
  }

  Map<String, String> toMap() {
    return {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
    };
  }
}

class TeamRegistrationScreen extends StatefulWidget {
  final Events event;

  const TeamRegistrationScreen({super.key, required this.event});

  @override
  State<TeamRegistrationScreen> createState() => _TeamRegistrationScreenState();
}

class _TeamRegistrationScreenState extends State<TeamRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  late List<TeamMember> teamMembers;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Create team members for team_size - 1 (excluding the current user)
    final teamMembersNeeded = widget.event.team_size - 1;
    teamMembers = List.generate(
      teamMembersNeeded,
      (index) => TeamMember(),
    );
  }

  @override
  void dispose() {
    for (var member in teamMembers) {
      member.dispose();
    }
    super.dispose();
  }

  Future<void> _submitTeam() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSubmitting = true;
    });

    try {
      // Collect all team member data
      List<Map<String, String>> teamData = teamMembers
          .map((member) => member.toMap())
          .where((data) => data['email']!.isNotEmpty)
          .toList();

      // Reserve event with team
      await reserveEventWithTeam(widget.event.events_id, teamData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Team registered successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Return success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Registration'),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GradientBox(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.event.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Team Size: ${widget.event.team_size}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Enter team member details:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'You need ${widget.event.team_size - 1} more team member(s)',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...List.generate(
                                teamMembers.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.white12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Team Member ${index + 1}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        // Name field
                                        TextFormField(
                                          controller: teamMembers[index].nameController,
                                          style: const TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            labelText: 'Name',
                                            labelStyle: const TextStyle(color: Colors.white70),
                                            hintText: 'John Doe',
                                            hintStyle: const TextStyle(color: Colors.white38),
                                            filled: true,
                                            fillColor: Colors.white.withOpacity(0.1),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(color: Colors.white24),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(color: Colors.white24),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(color: Colors.blue, width: 2),
                                            ),
                                            prefixIcon: const Icon(Icons.person, color: Colors.white70),
                                          ),
                                          keyboardType: TextInputType.name,
                                          textCapitalization: TextCapitalization.words,
                                          validator: (value) {
                                            if (value == null || value.trim().isEmpty) {
                                              return 'Please enter a name';
                                            }
                                            if (value.length > 50) {
                                              return 'Name too long';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 12),
                                        // Email field
                                        TextFormField(
                                          controller: teamMembers[index].emailController,
                                          style: const TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            labelStyle: const TextStyle(color: Colors.white70),
                                            hintText: 'example@college.edu',
                                            hintStyle: const TextStyle(color: Colors.white38),
                                            filled: true,
                                            fillColor: Colors.white.withOpacity(0.1),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(color: Colors.white24),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(color: Colors.white24),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              borderSide: const BorderSide(color: Colors.blue, width: 2),
                                            ),
                                            prefixIcon: const Icon(Icons.email, color: Colors.white70),
                                          ),
                                          keyboardType: TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value == null || value.trim().isEmpty) {
                                              return 'Please enter an email';
                                            }
                                            if (value.length > 50) {
                                              return 'Email too long';
                                            }
                                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                                .hasMatch(value)) {
                                              return 'Please enter a valid email';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isSubmitting ? null : _submitTeam,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(125, 0, 0, 0),
                              disabledBackgroundColor: Colors.grey,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(color: Colors.white24, width: 1),
                              ),
                            ),
                            child: isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Register Team',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}