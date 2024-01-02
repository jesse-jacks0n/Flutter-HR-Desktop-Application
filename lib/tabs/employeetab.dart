import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hrflutter/tabs/subpages/manegerial.dart';
import 'package:hrflutter/tabs/subpages/onleave.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../components/employeecard.dart';
import '../components/employeelistcard.dart';
import '../database/database.dart';
import '../utils/addEmployee.dart';

class EmployeeTab extends StatefulWidget {
  const EmployeeTab({Key? key}) : super(key: key);

  @override
  _EmployeeTabState createState() => _EmployeeTabState();
}

class _EmployeeTabState extends State<EmployeeTab> {
  late Future<List<Employee>?> _employeesFuture;
  List<Employee>? employees;
  List<Employee>? originalEmployees;
  bool _isGridMode = true;
  final TextEditingController _searchController = TextEditingController();
  late Stream<List<Employee>> _employeeStream;

  @override
  void initState() {
    super.initState();
    _employeesFuture = _fetchEmployees();
    _searchController.addListener(_onSearchTextChanged); // Add this line
  }

  void _onSearchTextChanged() {
    _performSearch(_searchController.text);
  }

  void _performSearch(String searchText) {
    setState(() {
      employees = originalEmployees
          ?.where((employee) =>
              employee.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  Future<List<Employee>?> _fetchEmployees() async {
    // Fetch the updated employee list from the database
    originalEmployees = await MongoDatabase.fetchEmployees();
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 500,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Container(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Manegerial()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // Set the desired border radius
                    ),
                  ),
                  child: const Text('Manegerial'),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OnLeave()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // Set the desired border radius
                    ),
                  ),
                  child: const Text('On Leave'),
                ),
              ],
            ),
          ),
        ),
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
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.picture_as_pdf, color: txtColor1),
              onPressed: () {
                generatePDF(employees, context);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddEmployeeDialog();
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: txtColor1,
                padding: const EdgeInsets.all(10),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Set the desired border radius
                ),
              ),
              child: const Text(
                '+   Add Employee',
                style: TextStyle(fontSize: 14, color: mainColor,fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
      body: StreamBuilder<List<Employee>?>(
        //future: _employeesFuture,
        stream: MongoDatabase.streamEmployees(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                size: 100,
                color: Colors.grey,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final employees = snapshot.data;

            if (employees != null && employees.isNotEmpty) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 10),
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          width: 400,
                          height: 40,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: Row(
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.call_missed_outgoing,
                                  color: Colors.green,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text('Leave')
                              ],
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Row(
                              children: const [
                                Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                  size: 17,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text('Edit')
                              ],
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.red[400],
                                  size: 17,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                const Text('Delete')
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
                            itemCount: employees.length,
                            itemBuilder: (context, index) {
                              final employee = employees[index];
                              return EmployeeCard(
                                name: employee.name,
                                email: employee.email,
                                role: employee.role,
                                status: employee.status,
                                activestatus: employee.activestatus,
                                phone: employee.phone,
                                department: employee.department,
                                dateOfJoining: employee.dateOfJoining,
                              );
                            },
                          )
                        : ListView.builder(
                          itemCount: employees.length,
                          itemBuilder: (context, index) {
                            final employee = employees[index];
                            return EmployeeListCard(
                              name: employee.name,
                              email: employee.email,
                              role: employee.role,
                              status: employee.status,
                              activestatus: employee.activestatus,
                              phone: employee.phone,
                              department: employee.department,
                              dateOfJoining: employee.dateOfJoining,
                            );
                          },
                        ),
                  ),
                ],
              );
            }
            else {
              return const Center(
                child: Text('No employees found.'),
              );
            }
          } else {
            return const Center(
              child: Text('no employees found'),
            );
          }
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: mainColor,
      //   onPressed: () async {
      //     final addedEmployee = await Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => AddEmployeeDialog()),
      //     );
      //     if (addedEmployee != null) {
      //       _refreshEmployees();
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(content: Text('Employee added: $addedEmployee')),
      //       );
      //     }
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
