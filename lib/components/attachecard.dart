import 'dart:ui';
import 'dart:core';
import 'package:flutter/material.dart';

import '../database/database.dart';

class AttacheCard extends StatelessWidget {
  final String name;
  final String school;
  final String course;
  final String email;
  final String phone;
  final String department;
  final String supervisor;

  // final DateTime joining;
  // final DateTime leaving;

  const AttacheCard({
    super.key,
    required this.name,
    required this.school,
    required this.course,
    required this.email,
    required this.phone,
    required this.supervisor,
    required this.department,
    // required this.joining,
    // required this.leaving,
  });

  Future<void> _editAttacheDetails(BuildContext context) async {
    // Show an alert dialog for editing attache details
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
        final TextEditingController supervisorController =
            TextEditingController(text: supervisor);

        return AlertDialog(
          title: const Text('Edit Attache Details'),
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
                TextField(
                  controller: supervisorController,
                  decoration: const InputDecoration(labelText: 'Supervisor'),
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
                final String updatedSupervisor = supervisorController.text;

                // Update the database with the new details
                MongoDatabase.updateAttache(
                    email,
                    updatedName,
                    updatedEmail,
                    updatedPhone,
                    updatedDepartment,
                    updatedSchool,
                    updatedCourse,
                    updatedSupervisor);

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
    const bodyBack = Color(0xFFFAF8F4);
    const CardBack = Color(0xFFFFFFFF);
    const borderBack = Color(0xFFD2D2D2);
    const gradientBack = Color(0xFF1AFB9A);
    const borderBack2 = Color(0xFFD2D2D2);
    const mainColor = Color(0xFF1D322F);
    const txtColor1 = Color(0xFFD7A564);
    const txtColor2 = Color(0xFFDEDEDE);
    const txtColor3 = Color(0xFF1D322F);
    //const txtColor3 = Color(0xFFDEDEDE);
    const circleBack = Color(0xFFECECEC);
    const selectedTabColor = Colors.grey;
    const cont1S = Color(0xFF27454F);
    const cont1E = Color(0xFF292848);
    const darkColor = Color(0xFF212327);
    const darkColor2 = Color(0xFF37393D);
    const boxDecor1 = Color(0xFFFBF5EB);
    const boxDecor2 = Color(0xFFEFEAFA);
    const statuscolor = Color(0xFFC08DF2);

    double blurValue = 8;
    double opacityValue = 0.5;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(5),
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
                  onPressed: () => _editAttacheDetails(context),
                  icon: Icon(Icons.edit,
                      color: Colors.grey.shade500, size: 17),
                ),
                IconButton(
                  onPressed: () {
                    // Delete the employee from the database
                    MongoDatabase.deleteAttache(
                        email); // Assuming email is a unique identifier for each employee

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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${name.toUpperCase()}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                //role
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'School:',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ' ${school.toUpperCase()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Course:',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ' ${course.toUpperCase()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Image.asset(
                          //   "lib/icons/envelope.png",
                          //   scale: 30,
                          // ),
                          // const SizedBox(
                          //   width: 5,
                          // ),
                          Expanded(
                            child: Text(
                              '${email.toLowerCase()}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  ),
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
                          // Image.asset(
                          //   "lib/icons/phone-call.png",
                          //   scale: 30,
                          // ),
                          // const SizedBox(
                          //   width: 5,
                          // ),
                          Text('$phone',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  )),
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
                        left: 10, right: 10, top: 5, bottom: 5),
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
                            const Expanded(
                              flex: 3,
                              child: Text(
                                'Department:',
                                style: TextStyle(
                                    fontSize: 12, ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                '${department.toUpperCase()}',
                                style: const TextStyle(
                                    fontSize: 13, ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 3,
                              child: const Text(
                                'Supervisor:',
                                style: TextStyle(
                                    fontSize: 12, ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                supervisor.toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 13, ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Expanded(
                        //         flex:3,
                        //         child:
                        //         const Text(
                        //             'Joined On:',
                        //             style: TextStyle(
                        //                 fontSize: 12,color:
                        //             txtColor3))),
                        //
                        //     // Expanded(
                        //     //   flex:4,
                        //     //   child: Text(
                        //     //     joining.substring(0,10),
                        //     //     style: const TextStyle(fontSize: 12, color: txtColor3),
                        //     //     overflow: TextOverflow.ellipsis,
                        //     //     maxLines: 1,
                        //     //   ),
                        //     // ),
                        //   ],
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Expanded(
                        //         flex:3,
                        //         child: const Text(
                        //             'Leaving On:', style: TextStyle(fontSize: 12, color: txtColor3))),
                        //
                        //     // Expanded(
                        //     //   flex:4,
                        //     //   child: Text(
                        //     //     leaving.substring(0,10),
                        //     //     style: const TextStyle(fontSize: 12, color: txtColor3),
                        //     //     overflow: TextOverflow.ellipsis,
                        //     //     maxLines: 1,
                        //     //   ),
                        //     // ),
                        //   ],
                        // ),
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
