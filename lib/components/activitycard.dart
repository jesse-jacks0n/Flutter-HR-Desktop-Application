import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';

class ExpandableContainer extends StatefulWidget {
  final String activityName;
  final String activityInfo;

  ExpandableContainer({required this.activityName, required this.activityInfo});

  @override
  _ExpandableContainerState createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  bool isExpanded = false;



  @override
  Widget build(BuildContext context) {
    const cardBack = Color.fromARGB(81, 101, 103, 116);
    const cardBack2 = Color.fromARGB(207, 224, 225, 232);
    const txtColor2 = Color(0xFFDEDEDE);
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? cardBack// Dark theme color
                :cardBack2,
            borderRadius: BorderRadius.circular(10)// Light theme color
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.activityName[0].toUpperCase() + widget.activityName.substring(1),
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15,),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            if (isExpanded)
              Text(
                widget.activityInfo.toLowerCase(),
                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13,),
              ),
          ],
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String activityname;
  final String activityinfo;
  final DateTime dateOfActivity;

  const ActivityCard({
    required this.activityname,
    required this.activityinfo,
    required this.dateOfActivity,
  });



  @override
  Widget build(BuildContext context) {
    const bodyBack = Color(0xFFFAF8F4);
    const cardBack = Color.fromARGB(81, 101, 103, 116);
    const cardBack2 = Color.fromARGB(207, 224, 225, 232);
    const borderBack = Color(0xFFD2D2D2);
    const borderBack2 = Color(0xFFD2D2D2);
    const mainColor = Color(0xFF1D322F);
    const txtColor1 = Color(0xFFD7A564);
    const txtColor2 = Color(0xFFDEDEDE);

    const dateBack = Color(0xFFF8F3E8);
    const deleteBack = Color(0x45EAADCC);
    const boxDecor1 = Color(0xFFFBF5EB);
    const boxDecor2 = Color(0xFFEFEAFA);
    const selectedTabColor = Colors.grey;
    const cont1S = Color(0xFF3D616D);
    const cont1E = Color(0xFF414068);

    double blurValue = 8;
    double opacityValue = 0.7;

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  // color: dateBack,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      cont1S.withOpacity(opacityValue), // Adjust opacity as desired
                      cont1E.withOpacity(opacityValue), // Adjust opacity as desired
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('d').format(dateOfActivity),
                      style: const TextStyle(fontSize: 16,color: txtColor2),
                    ),
                    Text(
                      DateFormat('MMM').format(dateOfActivity),
                      style: const TextStyle(fontSize: 15,color: txtColor2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 5,),
            //name
            Expanded(
              flex: 14,
              child: ExpandableContainer(
                activityName: activityname.toUpperCase(),
                activityInfo: activityinfo,
              ),
            ),
            const SizedBox(width: 5,),
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? cardBack // Dark theme color
                        : cardBack2,
                    borderRadius: BorderRadius.circular(10)// Light theme color
                ),
                child: IconButton(
                  onPressed: () {
                    // Delete the activity from the database
                    MongoDatabase.deleteActivity(activityinfo);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Remove Successful. Refresh the page to see changes.'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                  icon: Icon(Icons.delete, color: Colors.red.shade400, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
