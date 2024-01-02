import 'package:flutter/material.dart';

import '../database/database.dart';

class OnLeaveEmployeeListCard extends StatelessWidget {
  final String name;
  final String email;
  final String role;
  final String status;
  final String activestatus;
  final String phone;
  final String department;
  final String reasonforleave;
  final DateTime dateOfJoining;

  const OnLeaveEmployeeListCard({
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.activestatus,
    required this.phone,
    required this.department,
    required this.reasonforleave,
    required this.dateOfJoining,
  });

  Employee get employee => Employee(
      name: name,
      role: role,
      status: status,
      activestatus: activestatus,
      email: email,
      phone: phone,
      department: department,
      reasonForLeave: reasonforleave,
      dateOfJoining: dateOfJoining
  );

  Future<void> _editEmployeeDetails(BuildContext context) async {
    // Show an alert dialog for editing employee details
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController =
        TextEditingController(text: name);
        final TextEditingController emailController =
        TextEditingController(text: email);
        final TextEditingController roleController =
        TextEditingController(text: role);
        final TextEditingController phoneController =
        TextEditingController(text: phone);

        return AlertDialog(
          title: const Text('Edit Employee Details'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: roleController,
                  decoration: const InputDecoration(labelText: 'Role'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Update the employee details in the database
                final String updatedName = nameController.text;
                final String updatedEmail = emailController.text;
                final String updatedRole = roleController.text;
                final String updatedPhone = phoneController.text;

                // Update the database with the new details
                MongoDatabase.updateEmployee(
                  email,
                  updatedName,
                  updatedEmail,
                  updatedRole,
                  updatedPhone,
                );

                // Dismiss the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                // Dismiss the dialog
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        margin: EdgeInsets.only(left: 15,right: 15),
        decoration: BoxDecoration(
            color: Theme
                .of(context)
                .brightness == Brightness.dark
                ? Colors.grey[800] // Dark theme color
                : Colors.white70,
            borderRadius: BorderRadius.circular(10) // Light theme color
        ),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 10.0),
          title: Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      status.toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.w400,fontSize:13 ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "lib/icons/envelope.png",
                          scale: 30,
                          color: Theme
                              .of(context)
                              .brightness == Brightness.dark
                              ? Colors.white // Dark theme color
                              : Colors.grey[800],
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Text(
                            email,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "lib/icons/phone-call.png",
                          scale: 30,
                          color: Theme
                              .of(context)
                              .brightness == Brightness.dark
                              ? Colors.white // Dark theme color
                              : Colors.grey[800],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(phone,
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 13)),
                      ],
                    ),


                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(role.toUpperCase(),style: TextStyle(fontSize: 13),),
                    Text(department.toUpperCase(),style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(dateOfJoining.toString().substring(0, 10),style: TextStyle(fontSize: 14),),
                    Text(
                      reasonforleave.toUpperCase(),
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // IconButton(
                    //   onPressed: () => addToLeave(context, employee),
                    //   icon: Icon(Icons.call_missed_outgoing, color: Colors.green),
                    // ),
                    IconButton(
                      onPressed: () => _editEmployeeDetails(context),
                      icon: Icon(Icons.edit,
                          color: Colors.grey.shade500,
                          size: 17
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Delete the employee from the database
                        MongoDatabase.deleteOnLeaveEmployee(
                            email); // Assuming email is a unique identifier for each employee

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Remove Successful, Refresh the page to see changes.'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      },
                      icon:
                      Icon(Icons.delete, color: Colors.red.shade400, size: 17),
                    ),
                  ],
                ),
              )
            ],
          ),

        ),


      ),
    );
  }
}
