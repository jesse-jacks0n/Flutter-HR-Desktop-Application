import 'package:flutter/material.dart';
import 'package:hrflutter/utils/adddattach.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import '../components/attachecard.dart';
import '../database/database.dart';

class AttachesTab extends StatefulWidget {
  const AttachesTab({Key? key}) : super(key: key);

  @override
  _AttachesTabState createState() => _AttachesTabState();
}

class _AttachesTabState extends State<AttachesTab> {
  late Future<List<Attache>> _attacheFuture;
  List<Attache>? attaches;

  @override
  void initState() {
    super.initState();
    _attacheFuture = _fetchAttache();
  }

  Future<List<Attache>> _fetchAttache() async {
    return await MongoDatabase.fetchAttache();
  }

  void _refreshAttaches() {
    setState(() {
      _attacheFuture = _fetchAttache();
    });
  }

  Future<void> generatePDF(List<Attache>? attaches, BuildContext context) async {
    final pdf = pw.Document();

    // Create a list of data rows for the table
    final List<List<String>> tableData = [];

    // Add header row
    tableData.add(['No.', 'Name', 'Phone', 'School', 'Course']);

    // Add attache details to the table
    for (var i = 0; i < attaches!.length; i++) {
      final attache = attaches[i];
      tableData.add([
        (i + 1).toString(), // Row number
        attache.name,
        attache.phone,
        attache.school,
        attache.course,
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
        5: const pw.FlexColumnWidth(3),
      },
    );

    // Add table to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text('Attache', style: const pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            table,
          ],
        ),
      ),
    );

    // Get the directory for saving the PDF file
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/Attache_report.pdf';

    // Save the PDF file
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    final snackBar = SnackBar(content: Text('PDF saved at: $filePath'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF1D322F);
    const txtColor1 = Color(0xFFD7A564);
    return Scaffold(
      backgroundColor:Colors.transparent,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
            width: double.infinity,
            // Customize the container's properties as needed
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Text(
                //   " Attaches",
                //   style: TextStyle(color: txtColor1, fontSize: 25),
                // ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddAttacheDialog();
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: txtColor1,
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Set the desired border radius
                        ),
                      ),
                      child: const Text(
                        '+   Add Attache',
                        style: TextStyle(
                            fontSize: 14,
                            color: mainColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        generatePDF(attaches, context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: txtColor1,
                        padding: const EdgeInsets.all(15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'PDF',
                        style: TextStyle(
                            fontSize: 14,
                            color: mainColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton(
                      onPressed: _refreshAttaches,
                      icon: const Icon(Icons.refresh),
                      color: txtColor1,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Attache>?>(
              //future: _attacheFuture,
              stream: MongoDatabase.streamAttache(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingAnimationWidget.staggeredDotsWave(
                    color: mainColor,
                    size: 100,
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  attaches = snapshot.data;

                  return GridView.builder(
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      childAspectRatio: 1 / 1.1,
                    ),
                    itemCount: attaches?.length ?? 0,
                    itemBuilder: (context, index) {
                      final attache = attaches![index];
                      return AttacheCard(
                        name: attache.name,
                        email: attache.email,
                        phone: attache.phone,
                        department: attache.department,
                        school: attache.school,
                        course: attache.course,
                        supervisor: attache.supervisor,
                        // joining: attache.joining,
                        // leaving: attache.leaving,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
