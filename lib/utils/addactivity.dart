import 'package:flutter/material.dart';
import '../database/database.dart';

class AddActivityDialog extends StatefulWidget {
  @override
  _AddActivityDialogState createState() => _AddActivityDialogState();
}

class _AddActivityDialogState extends State<AddActivityDialog> {
  final TextEditingController _activitynameController = TextEditingController();
  final TextEditingController _activityinfoController = TextEditingController();
  DateTime? _dateOfActivity;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _activitynameController.dispose();
    _activityinfoController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _activityinfoController.clear();
    _activitynameController.clear();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfActivity ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateOfActivity = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF1D322F);
    const txtColor1 = Color(0xFFD7A564);
    const dateColor = Color(0xFFA968EB);
    return AlertDialog(
      title: const Text('Add Activity'),
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
                    controller: _activitynameController,
                    decoration: const InputDecoration(
                      labelText: 'Activity Name',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: mainColor),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter activity';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _activityinfoController,
                    decoration: const InputDecoration(
                      labelText: 'Info',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: mainColor),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter info';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectDate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dateColor,
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Select Date'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _clearFields,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: txtColor1,
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          // Set the desired border radius
                        ),
                      ),
                      child: const Text('Clear'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Create a new Employee instance with the input data
                          final newActivity = Activity(
                            activityname: _activitynameController.text,
                            activityinfo: _activityinfoController.text,
                            dateOfActivity: _dateOfActivity ?? DateTime.now(),
                          );

                          var db = await MongoDatabase.connect();

                          // Insert the new employee into the database
                          try {
                            await MongoDatabase.insertActivity(newActivity);

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
                          const SnackBar(
                            content: Text('Add Successful, Refresh to see changes.'),
                            duration: Duration(seconds: 5),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          // Set the desired border radius
                        ),
                      ),
                      child: const Text('Add Activity'),
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
