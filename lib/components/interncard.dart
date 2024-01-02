import 'package:flutter/material.dart';
import 'package:hrflutter/tabs/employeetab.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../database/database.dart';

class InternCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String department;
  final String school;
  final String course;
  final DateTime dateOfJoining;

  const InternCard({
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.school,
    required this.dateOfJoining,
    required this.course,
  });

  Future<void> _editInternDetails(BuildContext context) async {
    // Show an alert dialog for editing intern details
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController =
        TextEditingController(text: name);
        final TextEditingController emailController =
        TextEditingController(text: email);
        final TextEditingController phoneController =
        TextEditingController(text: phone);
        final TextEditingController departmentController =
        TextEditingController(text: department);
        final TextEditingController schoolController =
        TextEditingController(text: school);
        final TextEditingController courseController =
        TextEditingController(text: course);

        return AlertDialog(
          title: const Text('Edit Intern Details'),
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
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                TextField(
                  controller: departmentController,
                  decoration: const InputDecoration(labelText: 'Department'),
                ),
                TextField(
                  controller: schoolController,
                  decoration: const InputDecoration(labelText: 'School'),
                ),
                TextField(
                  controller: courseController,
                  decoration: const InputDecoration(labelText: 'Course'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Update the attache details in the database
                final String updatedName = nameController.text;
                final String updatedEmail = emailController.text;
                final String updatedPhone = phoneController.text;
                final String updatedDepartment = departmentController.text;
                final String updatedSchool = schoolController.text;
                final String updatedCourse = courseController.text;

                // Update the database with the new details
                MongoDatabase.updateIntern(
                  email,
                  updatedName,
                  updatedEmail,
                  updatedPhone,
                  updatedDepartment,
                  updatedSchool,
                  updatedCourse,
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
        padding: EdgeInsets.all(5),
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
                  onPressed: () => _editInternDetails(context),
                  icon: Icon(Icons.edit, color: Colors.grey.shade500, size: 17),
                ),
                IconButton(
                  onPressed: () {
                    // Delete the employee from the database
                    MongoDatabase.deleteIntern(email); // Assuming email is a unique identifier for each employee
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Remove Successfull, Refresh the page to see changes.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red.shade400,
                    size: 20,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${name.toUpperCase()}',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                //role
                Text(
                  'School: ${school.toUpperCase()}',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  'Course: ${course.toUpperCase()}',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),

                SizedBox(
                  height: 2,
                ),

                Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${email.toLowerCase()}',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      SizedBox(
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
                          SizedBox(
                            width: 5,
                          ),
                          Text('$phone',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                    padding:
                    EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
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
                            Text(
                              'Department:',
                              style: TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text('${department.toUpperCase()}',
                                style: TextStyle(fontSize: 13)),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Joined On:', style: TextStyle(fontSize: 12)),
                            SizedBox(
                              width: 30,
                            ),
                            Text('${dateOfJoining.toString().substring(0, 10)}',
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    )),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
