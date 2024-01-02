import 'package:flutter/material.dart';
import '../database/database.dart';

class AddAttacheDialog extends StatefulWidget {
  @override
  _AddAttacheDialogState createState() => _AddAttacheDialogState();
}

class _AddAttacheDialogState extends State<AddAttacheDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _supervisorController = TextEditingController();
  String? _selectedDepartment;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _schoolController.dispose();
    _courseController.dispose();
    _phoneController.dispose();
    _supervisorController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _nameController.clear();
    _schoolController.clear();
    _emailController.clear();
    _courseController.clear();
    _phoneController.clear();
    _supervisorController.clear();

  }

  @override
  Widget build(BuildContext context) {
    const dateColor = Color(0xFFA968EB);
    const bodyBack = Color(0xFFFAF8F4);
    const mainColor = Color(0xFF1D322F);
    const txtColor1 = Color(0xFFD7A564);
    const txtColor2 = Color(0xFFDEDEDE);
    const tabBack = Color(0xFF354A48);
    const selectedTabColor = Colors.grey;

    final List<String> departments = ['ICT', 'TRADE', 'AGRICULTURE', 'LAND', 'ENVIRONMENT', 'EDUCATION'];

    return AlertDialog(
      title: Text('Add Attache'),
      content: Container(
        width: 400,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        return 'Please enter email';
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
                        return 'Please enter school';
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
                    controller: _supervisorController,
                    decoration: InputDecoration(
                      labelText: 'Supervisor',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: mainColor),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter Supervisor';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Department',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: mainColor),
                    ),
                    value: _selectedDepartment,
                    items: departments.map((String department) {
                      return DropdownMenuItem<String>(
                        value: department,
                        child: Text(department),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedDepartment = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a department';
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(height: 10,),
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Create a new Employee instance with the input data
                          final newAttache = Attache(
                            name: _nameController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                            department: _selectedDepartment ?? '',
                            school: _schoolController.text,
                            course: _courseController.text,
                            supervisor: _supervisorController.text,

                          );

                          // Connect to the MongoDB database
                          var db = await MongoDatabase.connect();

                          // Insert the new employee into the database
                          try {
                            await MongoDatabase.insertAttache(newAttache);

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
                            content: Text('Add Successful, Refresh to see changes.'),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        padding: EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Add Attache'),
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
