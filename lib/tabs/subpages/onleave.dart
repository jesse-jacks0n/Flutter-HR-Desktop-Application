import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hrflutter/tabs/subpages/manegerial.dart';
import 'package:hrflutter/tabs/subpages/onleave.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../components/employeecard.dart';
import '../../components/employeelistcard.dart';
import '../../components/onleaveemployeecard.dart';
import '../../components/onleaveemployeelistcard.dart';
import '../../database/database.dart';
import '../../utils/addEmployee.dart';

class OnLeave extends StatefulWidget {
  const OnLeave({super.key});

  @override
  State<OnLeave> createState() => _OnLeaveState();
}

class _OnLeaveState extends State<OnLeave> {
  late Future<List<Employee>?> _employeesFuture;
  List<Employee>? employees; // Declare a list to store the employees
  List<Employee>? originalEmployees;
  bool _isGridMode = true;
  final TextEditingController _searchController = TextEditingController();

  void _performSearch(String searchText) {
    setState(() {
      employees = originalEmployees
          ?.where((employee) =>
          employee.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _employeesFuture = _fetchEmployees();
  }

  Future<List<Employee>?> _fetchEmployees() async {
    // Fetch the updated employee list from the database
    originalEmployees = await MongoDatabase.fetchOnLeaveEmployees();
    employees = List.from(originalEmployees!);
    return employees;
  }

  void _refreshEmployees() {
    setState(() {
      _employeesFuture = _fetchEmployees();
    });
  }

  Future<void> generatePDF(
      List<Employee>? employees, BuildContext context) async {
    final pdf = pw.Document();
    final List<List<String>> tableData = [];
    tableData.add(['No.', 'Name', 'Phone', 'Email', 'Role']);

    for (var i = 0; i < employees!.length; i++) {
      final employee = employees[i];
      tableData.add([
        (i + 1).toString(),
        employee.name,
        employee.phone,
        employee.email,
        employee.role,
      ]);
    }

    final table = pw.Table.fromTextArray(
      data: tableData,
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 12,
      ),
      cellStyle: const pw.TextStyle(
        fontSize: 10,
      ),
      cellAlignment: pw.Alignment.centerLeft,
      cellPadding: const pw.EdgeInsets.all(5),
      border: pw.TableBorder.all(width: 0.5),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(width: 0.5),
        ),
      ),
      columnWidths: {
        0: const pw.IntrinsicColumnWidth(),
        1: const pw.FlexColumnWidth(3),
        2: const pw.FlexColumnWidth(3),
        3: const pw.FlexColumnWidth(4),
        4: const pw.FlexColumnWidth(3),
      },
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text('Employees', style: const pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            table,
          ],
        ),
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/employee_list.pdf');
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    const txtColor1 = Color(0xFFD7A564);
    const mainColor = Color(0xFF1D322F);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900] // Dark theme color
            : Colors.grey[300], // Light theme color
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar:AppBar(
          backgroundColor: mainColor,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: txtColor1),
              onPressed: _refreshEmployees,
            ),
            IconButton(
              icon: Icon(
                _isGridMode ? Icons.list : Icons.grid_view,
                color: txtColor1,
              ),
              onPressed: () {
                setState(() {
                  _isGridMode = !_isGridMode;
                });
              },
            ),
            Container(
              margin: EdgeInsets.only(right: 10),
              child: IconButton(
                icon: const Icon(Icons.picture_as_pdf, color: txtColor1),
                onPressed: () {
                  generatePDF(employees, context);
                },
              ),
            ),
          ],
        ),

        body: FutureBuilder<List<Employee>?>(
          future: _employeesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Center(
                  child:  LoadingAnimationWidget.staggeredDotsWave(
                    size: 100,
                    color: Colors.grey,
                  )
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData && employees != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5,bottom:10,top: 10),
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          width: 400,
                          height: 40,
                          child: TextField(
                            controller: _searchController,
                            onChanged: _performSearch,
                            cursorColor: txtColor1,
                            style: const TextStyle(color: txtColor1),
                            decoration: InputDecoration(
                              labelText: 'Search',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0), // Set the desired border radius
                              ),
                              prefixIcon: const Icon(Icons.search,color: txtColor1,), // Add an icon
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: txtColor1), // Set the desired border color when focused
                                borderRadius: BorderRadius.circular(10.0), // Set the desired border radius when focused
                              ),
                              floatingLabelStyle: const TextStyle(color: txtColor1),

                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Row(
                          children:  [

                            SizedBox(width: 8,),
                            Row(
                              children: [
                                Icon(Icons.edit,color:Colors.grey,size: 17,),
                                SizedBox(width: 3,),
                                Text('Edit')
                              ],
                            ),
                            SizedBox(width: 8,),
                            Row(
                              children: [
                                Icon(Icons.delete,color: Colors.red[400],size: 17,),
                                SizedBox(width: 3,),
                                Text('Delete')
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  Expanded(
                    child: _isGridMode
                        ? GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: employees!.length,
                      itemBuilder: (context, index) {
                        final employee = employees![index];
                        return OnLeaveEmployeeCard(
                          name: employee.name,
                          email: employee.email,
                          role: employee.role,
                          status: employee.status,
                          activestatus: employee.activestatus,
                          phone: employee.phone,
                          department: employee.department,
                          dateOfJoining: employee.dateOfJoining,
                          reasonforleave: employee.reasonForLeave,
                        );
                      },
                    )
                        : ListView.builder(
                      itemCount: employees!.length,
                      itemBuilder: (context, index) {
                        final employee = employees![index];
                        return  OnLeaveEmployeeListCard(
                          name: employee.name,
                          email: employee.email,
                          role: employee.role,
                          status: employee.status,
                          activestatus: employee.activestatus,
                          phone: employee.phone,
                          department: employee.department,
                          dateOfJoining: employee.dateOfJoining,
                          reasonforleave: employee.reasonForLeave,
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text('No employees found.'),
              );
            }
          },
        ),

      ),
    );
  }
}
