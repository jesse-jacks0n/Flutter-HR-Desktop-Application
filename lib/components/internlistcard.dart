import 'package:flutter/material.dart';
import '../database/database.dart';

class InternListCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String department;
  final String school;
  final String course;
  final DateTime dateOfJoining;

  const InternListCard({
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
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        margin: EdgeInsets.only(left: 15,right: 15),
        decoration: BoxDecoration(
            color: Theme
                .of(context)
                .brightness == Brightness.dark
                ? darkColor // Dark theme color
                : Colors.white70,
            borderRadius: BorderRadius.circular(10) // Light theme color
        ),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 10.0),
          title: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  name.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 13),
                ),
              ),
              SizedBox(width: 20,),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course.toUpperCase(),style: TextStyle(fontSize: 12),),
                    //Text(department.toUpperCase(),style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              SizedBox(width: 20,),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(school.toUpperCase(),style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      width: 5,
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
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    Text(department.toUpperCase(),style: TextStyle(fontSize: 14),),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dateOfJoining.toString().substring(0, 10),style: TextStyle(fontSize: 14),),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Delete the employee from the database
                        MongoDatabase.deleteIntern(
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
