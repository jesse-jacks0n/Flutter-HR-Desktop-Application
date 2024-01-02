import 'package:flutter/material.dart';
import '../database/database.dart';

class AddInternDialog extends StatefulWidget {
  @override
  _AddInternDialogState createState() => _AddInternDialogState();
}

class _AddInternDialogState extends State<AddInternDialog> {
  final TextEditingController _nameController = TextEditingController();
  //final TextEditingController _roleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  DateTime? _dateOfJoining;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _schoolController.dispose();
    _courseController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _schoolController.clear();
    _departmentController.clear();
    _courseController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bodyBack = Color(0xFFFAF8F4);
    const mainColor = Color(0xFF1D322F);
    const txtColor1 = Color(0xFFD7A564);
    const txtColor2 = Color(0xFFDEDEDE);
    const tabBack = Color(0xFF354A48);
    const selectedTabColor = Colors.grey;
    return AlertDialog(
      title: Text('Add Intern'),
      content: Container(
        width: 400,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            // autovalidateMode: AutovalidateMode.always, // Show validators on any change
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: mainColor),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: mainColor),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _schoolController,
                    decoration: InputDecoration(
                      labelText: 'School',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: mainColor),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _courseController,
                    decoration: InputDecoration(
                      labelText: 'Course',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: mainColor),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter course';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: mainColor),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _departmentController,
                    decoration: InputDecoration(
                      labelText: 'Department',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: mainColor),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter a department';
                      }
                      return null;
                    },
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _clearFields,
                      child: Text('Clear'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: txtColor1,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          // Set the desired border radius
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Create a new Employee instance with the input data
                          final newIntern = Intern(
                            name: _nameController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                            school: _schoolController.text,
                            course: _courseController.text,
                            department: _departmentController.text,
                            dateOfJoining: _dateOfJoining ?? DateTime.now(),
                          );

                          // Connect to the MongoDB database
                          var db = await MongoDatabase.connect();

                          // Insert the new employee into the database
                          try {
                            await MongoDatabase.insertIntern(newIntern);

                            // Show a success message or perform any additional actions

                            // Close the dialog
                            Navigator.of(context).pop();
                          } catch (e) {
                            // Handle any errors that occurred during the database operation
                            print('Error: $e');
                          } finally {
                            // Close the database connection
                            //await db.close();
                          }
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Add Successfull, Refresh to see changes.'),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          // Set the desired border radius
                        ),
                      ),
                      child: Text('Add Intern'),
                    ),

                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
