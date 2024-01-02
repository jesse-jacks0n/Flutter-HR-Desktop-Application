import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import '../components/interncard.dart';
import '../components/internlistcard.dart';
import '../database/database.dart';
import '../utils/addintern.dart';

class InternsTab extends StatefulWidget {
  const InternsTab({Key? key}) : super(key: key);

  @override
  _InternsTabState createState() => _InternsTabState();
}

class _InternsTabState extends State<InternsTab> {
  late Future<List<Intern>> _internFuture;
  List<Intern>? interns;
  bool _isGridMode = true;

  @override
  void initState() {
    super.initState();
    _internFuture = _fetchIntern();
  }

  Future<List<Intern>> _fetchIntern() async {
    return await MongoDatabase.fetchIntern();
  }

  void _refreshInterns() {
    setState(() {
      _internFuture = _fetchIntern();
    });
  }

  Future<void> generatePDF(List<Intern>? interns, BuildContext context) async {
    final pdf = pw.Document();

    // Create a list of data rows for the table
    final List<List<String>> tableData = [];

    // Add header row
    tableData.add(['No.', 'Name', 'Phone', 'Email']);

    // Add employee details to the table
    for (var i = 0; i < interns!.length; i++) {
      final intern = interns[i];
      tableData.add([
        (i + 1).toString(), // Row number
        intern.name,
        intern.phone,
        intern.email,
      ]);
    }

    // Create the table widget
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

    // Add table to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text('Interns', style: const pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            table,
          ],
        ),
      ),
    );

    // Get the directory for saving the PDF file
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/employee_list.pdf');
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF1D322F);
    const txtColor1 = Color(0xFFD7A564);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 500,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: txtColor1),
            onPressed: _refreshInterns,
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
                generatePDF(interns, context);
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
                    return AddInternDialog();
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
                '+   Add Intern',
                style: TextStyle(fontSize: 14, color: mainColor,fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Intern>?>(
        //future: _internFuture,
        stream: MongoDatabase.streamIntern(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.grey,
                size: 100,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')
            );
          } else if(snapshot.hasData) {
            final interns = snapshot.data;
            if(interns != null && interns.isNotEmpty){
              return _isGridMode
                  ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 1 / 1.1,
                ),
                itemCount: interns?.length,
                itemBuilder: (context, index) {
                  final intern = interns![index];
                  return InternCard(
                    name: intern.name,
                    email: intern.email,
                    phone: intern.phone,
                    department: intern.department,
                    school: intern.school,
                    course: intern.course,
                    dateOfJoining: intern.dateOfJoining,
                  );
                },
              )
                  :ListView.builder(
                itemCount: interns?.length,
                itemBuilder: (context, index) {
                  final intern = interns![index];
                  return InternListCard(
                    name: intern.name,
                    email: intern.email,
                    phone: intern.phone,
                    department: intern.department,
                    school: intern.school,
                    course: intern.course,
                    dateOfJoining: intern.dateOfJoining,

                  );
                },

              );
            }
            else {
              return const Center(
                child: Text('No interns found.'),
              );
            }
          }
          else {
            return const Center(
              child: Text('no interns found'),
            );
          }
        },
      ),
    );
  }
}
