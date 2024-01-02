import 'package:flutter/material.dart';

import '../database/database.dart';

class AddEventDialog extends StatefulWidget {
  const AddEventDialog({super.key});

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final TextEditingController _eventnameController = TextEditingController();
  final TextEditingController _eventinfoController = TextEditingController();
  DateTime? _dateOfevent;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _eventnameController.dispose();
    _eventinfoController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _eventnameController.clear();
    _eventinfoController.clear();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfevent ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateOfevent = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF1D322F);
    const txtColor1 = Color(0xFFD7A564);
    const dateColor = Color(0xFFA968EB);
    return AlertDialog(
      title: Text('Add Event'),
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
                    controller: _eventnameController,
                    decoration: InputDecoration(
                      labelText: 'Event Name',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: mainColor),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter Event';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _eventinfoController,
                    decoration: InputDecoration(
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
                  child: Text('Select Date'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: dateColor,
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                          final newEEvent = EEvent(
                            eventname: _eventnameController.text,
                            eventinfo: _eventinfoController.text,
                            dateOfevent: _dateOfevent ?? DateTime.now(),
                          );

                          // Connect to the MongoDB database
                          var db = await MongoDatabase.connect();

                          // Insert the new employee into the database
                          try {
                            await MongoDatabase.insertevent(newEEvent);

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
                      child: Text('Add Event'),
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
