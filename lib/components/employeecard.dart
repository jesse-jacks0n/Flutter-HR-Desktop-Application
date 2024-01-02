import 'package:flutter/material.dart';

import '../database/database.dart';

class EmployeeCard extends StatelessWidget {
  final String name;
  final String email;
  final String role;
  final String status;
  final String activestatus;
  final String phone;
  final String department;
  final DateTime dateOfJoining;
  String reasonForLeave;

   EmployeeCard({
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    required this.activestatus,
    required this.phone,
    required this.department,
    required this.dateOfJoining,
    this.reasonForLeave = '',
  });

  Employee get employee => Employee(
      name: name,
      role: role,
      status: status,
      email: email,
      phone: phone,
      department: department,
      dateOfJoining: dateOfJoining,
      activestatus: activestatus
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

  Future<void> addToLeave(BuildContext context, Employee employee) async {
    String reasonForLeave = '';

    final bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController reasonController = TextEditingController();

        return AlertDialog(
          title: const Text('Add to Leave'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Are you sure you want to add this employee to leave?'),
              TextField(
                controller: reasonController,
                onChanged: (value) {
                  reasonForLeave = value;
                },
                decoration: const InputDecoration(labelText: 'Reason for leave'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      employee.reasonForLeave = reasonForLeave; // Assign the reason for leave to the employee object
      await MongoDatabase.addSelectedUserToOnLeaveCollection(employee.email, reasonForLeave); // Pass the reason for leave to the database method
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee added to leave')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    const txtColor1 = Color(0xFFD7A564);
    const mainColor = Color(0xFF1D322F);
    const darkColor = Color(0xFF212327);
    const darkColor2 = Color(0xFF37393D);
    const boxDecor1 = Color(0xFFFBF5EB);
    const boxDecor2 = Color(0xFFEFEAFA);
    const statuscolor = Color(0xFFC08DF2);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Theme
                .of(context)
                .brightness == Brightness.dark
                ? darkColor // Dark theme color
                : Colors.white70,
            borderRadius: BorderRadius.circular(20) // Light theme color
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => addToLeave(context, employee),
                  icon: Icon(Icons.call_missed_outgoing, color: Colors.green),
                ),


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
                    MongoDatabase.deleteEmployee(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //name
                Text(
                  name.toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
                //role
                Text(
                  role.toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 12),
                ),
                const SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: status == 'Full-time'
                            ? mainColor
                            : statuscolor, // Light theme color
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10,),
                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: activestatus == 'on-leave'
                            ? txtColor1
                            : mainColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        activestatus.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),

                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .brightness == Brightness.dark
                          ? darkColor2 // Dark theme color
                          : boxDecor1,
                      borderRadius: BorderRadius.circular(
                          15) // Light theme color
                  ),
                  width: double.infinity,
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
                                  fontWeight: FontWeight.w400, fontSize: 11),
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
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .brightness == Brightness.dark
                          ? darkColor2// Dark theme color
                          : boxDecor2,
                      borderRadius: BorderRadius.circular(
                          15) // Light theme color
                  ),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Department:',
                            style: TextStyle(fontSize: 13),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              department.toUpperCase(),
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Joined On:',
                              style: TextStyle(fontSize: 13)),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Text(
                              dateOfJoining.toString().substring(0, 10),
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
