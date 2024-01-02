import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hrflutter/utils/addactivity.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Widgets/dashWidgets.dart';
import '../components/activitycard.dart';
import '../components/eventcard.dart';
import '../database/database.dart';
import '../utils/addeven.dart';

class DashTab extends StatefulWidget {
  const DashTab({super.key});

  @override
  State<DashTab> createState() => _DashTabState();
}

class _DashTabState extends State<DashTab> {
  late Future<List<Activity>> _activityFuture;
  late Future<List<EEvent>> _eventFuture;

  @override
  void initState() {
    super.initState();
    _activityFuture = _fetchActivity();
    _eventFuture = _fetchEvent();
  }

  Future<List<Activity>> _fetchActivity() async {
    // Fetch the updated activity list from the database
    return await MongoDatabase.fetchActivity();
  }

  Future<List<EEvent>> _fetchEvent() async {
    // Fetch the updated event list from the database
    return await MongoDatabase.fetchEvent();
  }

  void _refreshActivity() {
    setState(() {
      _activityFuture = _fetchActivity();
    });
  }

  void _refreshEvent() {
    setState(() {
      _eventFuture = _fetchEvent();
    });
  }

  @override
  Widget build(BuildContext context) {
    const mainColor = Color(0xFF1D322F);
    const txtColor2 = Color(0xFFEDEDED);
    const cardBack = Color.fromARGB(81, 101, 103, 116);
    const btn2Color = Color(0xFFC08DF2);
    const btn3Color = Color(0xFF74D7FE);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),

                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0,bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:dashWidgets(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: cardBack
                        ),
                        height: 370,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Upcoming Activities",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AddActivityDialog();
                                              });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: btn2Color,
                                          elevation: 0,
                                          padding: const EdgeInsets.all(15),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10), // Set the desired border radius
                                          ),
                                        ),
                                        child: const Text(
                                          '+  Add Activity',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: mainColor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: _refreshActivity,
                                        icon: const Icon(Icons.refresh),
                                        color: btn2Color,
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                              Expanded(
                                  child: StreamBuilder<List<Activity>?>(
                                    //future: _activityFuture,
                                    stream: MongoDatabase.streamActivity(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return LoadingAnimationWidget.staggeredDotsWave(
                                          color: mainColor,
                                          size: 100,
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        final activities = snapshot.data;

                                        return ListView.builder(
                                          scrollDirection: Axis.vertical,

                                          itemCount: activities?.length ?? 0,
                                          itemBuilder: (context, index) {
                                            final activity = activities![index];
                                            return ActivityCard(
                                              activityname: activity.activityname,
                                              activityinfo: activity.activityinfo,
                                              dateOfActivity: activity.dateOfActivity,

                                            );
                                          },
                                        );
                                      }
                                    },
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: cardBack
                          ),
                          height: 370,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Events",
                                      style: TextStyle(fontSize: 17,),
                                    ),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return const AddEventDialog();
                                                });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: btn3Color,
                                            padding: const EdgeInsets.all(15),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  10), // Set the desired border radius
                                            ),
                                          ),
                                          child: const Text(
                                            '+  Add Event',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: mainColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: _refreshEvent,
                                          icon: const Icon(Icons.refresh),
                                          color: btn3Color,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: StreamBuilder<List<EEvent>?>(
                                      //future: _eventFuture,
                                      stream: MongoDatabase.streamEvent(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return LoadingAnimationWidget.staggeredDotsWave(
                                            color: mainColor,
                                            size: 100,
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        } else {
                                          final events = snapshot.data;

                                          return ListView.builder(
                                            scrollDirection: Axis.vertical,

                                            itemCount: events?.length ?? 0,
                                            itemBuilder: (context, index) {
                                              final event = events![index];
                                              return EventCard(
                                                eventname: event.eventname,
                                                eventinfo: event.eventinfo,
                                                dateOfevent: event.dateOfevent,

                                              );
                                            },
                                          );
                                        }
                                      },
                                    )

                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


