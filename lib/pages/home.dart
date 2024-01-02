import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hrflutter/tabs/attachestab.dart';
import 'package:hrflutter/tabs/dashtab.dart';
import 'package:hrflutter/tabs/internstab.dart';
import 'package:hrflutter/tabs/inventorytab.dart';
import 'package:provider/provider.dart';
import '../tabs/employeetab.dart';
import '../tabs/repository.dart';
import '../theme_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final mainColor = const Color(0xFF1D322F);
  final mainColor2 = const Color(0xFF9CB79C);
  final bodyBack = const Color(0xFFE8ECEF);
  final txtColor1 = const Color(0xFFA78764);
  final txtColor2 = const Color(0xFFDEDEDE);
  final tabBack = const Color(0xFF354A48);
  final tabBack2 = const Color(0xFFBDD2BD);

  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String getGreeting() {
    final currentTime = DateTime.now();
    final int hour = currentTime.hour;

    if (hour >= 0 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    String greeting = getGreeting();
    const dark = Color(0xFF131515);
    String customImagePathLight = 'assets/images/custom_image_light.png';
    String customImagePathDark = 'lib/icons/night-mode.png';

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? dark // Dark theme color
            : Colors.grey[300], // Light theme color
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 50),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                  greeting,
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.grey.shade900,
                      letterSpacing: 1.5)
              ),
            ),
            actions: [

              SizedBox(
                width: 20,
              ),
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) {
                  IconData iconData = themeProvider.isDarkMode
                      ? Icons.wb_sunny
                      : Icons.nightlight_round;

                  return Row(
                    children: [
                      Transform.rotate(
                        angle: -30 * (3.1415926535897932 / 180),
                        // Rotate by 45 degrees (convert to radians)
                        child: Icon(
                          iconData,
                          color: themeProvider.isDarkMode
                              ? Colors.grey[200]
                              : Colors.grey[800],
                        ),
                      ),
                      Transform.scale(
                        scale: 0.5,
                        // Adjust the scale factor to make it smaller
                        child: CupertinoSwitch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) {
                            Provider.of<ThemeProvider>(context, listen: false)
                                .toggleTheme();
                          },
                          activeColor: Colors.grey[200],
                          trackColor: Colors.grey[800],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
            bottom: TabBar(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              controller: _tabController,
              indicator: BoxDecoration(
                color: tabBack,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorColor: Colors.white,
              tabs: const [
                Tab(text: 'Dashboard'),
                Tab(text: 'Employees'),
                Tab(text: 'Interns'),
                Tab(text: 'Attaches'),
                //Tab(text: 'Inventory'),
                Tab(text: 'Repository'),
              ],
              labelColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.white,
              unselectedLabelColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                // Disable scroll physics to prevent swipe gesture
                children: const [
                  DashTab(),
                  EmployeeTab(),
                  InternsTab(),
                  AttachesTab(),
                  // InventoryTab(),
                  RepositoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

// body: TabBarView(
// controller: _tabController,
// physics: NeverScrollableScrollPhysics(), // Disable scroll physics to prevent swipe gesture
// children: [
// DashTab(),
// EmployeeTab(),
// InternsTab(),
// AttachesTab(),
// InventoryTab(),
// RepositoryTab(),
// ],
// ),
