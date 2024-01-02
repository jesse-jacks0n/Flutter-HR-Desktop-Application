import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';

class ExpandableContainer extends StatefulWidget {
  final String eventName;
  final String eventInfo;

  ExpandableContainer({required this.eventName, required this.eventInfo});

  @override
  _ExpandableContainerState createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    const cardBack = Color.fromARGB(81, 101, 103, 116);
    const cardBack2 = Color.fromARGB(207, 224, 225, 232);
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
                ? cardBack // Dark theme color
                : cardBack2,

            borderRadius: BorderRadius.circular(10)// Light theme color
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.eventName[0].toUpperCase() + widget.eventName.substring(1),
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            if (isExpanded)
              Text(
                widget.eventInfo.toLowerCase(),
                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
              ),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String eventname;
  final String eventinfo;
  final DateTime dateOfevent;

  const EventCard({
    required this.eventname,
    required this.eventinfo,
    required this.dateOfevent,
  });

  @override
  Widget build(BuildContext context) {

    const cardBack = Color.fromARGB(81, 101, 103, 116);
    const cardBack2 = Color.fromARGB(207, 224, 225, 232);
    const dateBack = Color(0xFFE5E3DF);
    const deleteBack = Color(0x45EAADCC);
    const cont1S = Color(0xFF3D616D);
    const cont1E = Color(0xFF414068);

    double blurValue = 8;
    double opacityValue = 0.7;

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),

        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
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
                      DateFormat('d').format(dateOfevent),
                      style:  TextStyle(fontSize: 16,color: Colors.grey[300]),
                    ),
                    Text(
                      DateFormat('MMM').format(dateOfevent),
                      style:  TextStyle(fontSize: 15,color: Colors.grey[300]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 5,),
            //name
            Expanded(
              flex: 15,
              child: ExpandableContainer(
                eventName: eventname,
                eventInfo: eventinfo,
              ),
            ),
            const SizedBox(width: 5,),
            Expanded(
              flex: 2,
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
                    MongoDatabase.deleteevent(eventinfo);
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
