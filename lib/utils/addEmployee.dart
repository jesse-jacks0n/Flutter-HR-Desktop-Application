import 'package:flutter/material.dart';
import '../database/database.dart';

class AddEmployeeDialog extends StatefulWidget {
  @override
  _AddEmployeeDialogState createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends State<AddEmployeeDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _dateOfJoining;
  String _status = '';
  String _activestatus = 'ACTIVE';
  String? _selectedDepartment;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _nameController.clear();
    _roleController.clear();
    _emailController.clear();
    _phoneController.clear();
    setState(() {
      _status = '';
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfJoining ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateOfJoining = picked;
      });
    }
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

    return  AlertDialog(
        title: const Text('Add Employee'),
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
                      decoration: const InputDecoration(
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
                      controller: _roleController,
                      decoration: const InputDecoration(
                        labelText: 'Role',
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: mainColor),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a role';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
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
                      controller: _phoneController,
                      decoration: const InputDecoration(
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
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
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
                  ListTile(
                    title: const Text('Full-time'),
                    leading: Radio(
                      value: 'Full-time',
                      groupValue: _status,
                      onChanged: (value) {
                        setState(() {
                          _status = value as String;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Part-time'),
                    leading: Radio(
                      value: 'Part-time',
                      groupValue: _status,
                      onChanged: (value) {
                        setState(() {
                          _status = value as String;
                        });
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _selectDate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Select Date'),
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: txtColor1,
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),

                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Create a new Employee instance with the input data
                            final newEmployee = Employee(
                              name: _nameController.text,
                              email: _emailController.text,
                              role: _roleController.text,
                              status: _status,
                              activestatus: _activestatus,
                              phone: _phoneController.text,
                              department: _selectedDepartment ?? '',
                              dateOfJoining: _dateOfJoining ?? DateTime.now(),
                            );

                            // Connect to the database
                            var db = await MongoDatabase.connect();

                            // Insert the new employee into the database
                            try {
                              await MongoDatabase.insertEmployee(newEmployee);

                              // Show a success message or perform any additional actions

                              // Close the dialog and refresh the employee page
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
                            const SnackBar(
                              content: Text('Add Successful !'),
                              duration: Duration(seconds: 5),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Add Employee'),
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
