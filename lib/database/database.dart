import 'dart:async';
import 'dart:ffi';
import 'package:mongo_dart/mongo_dart.dart' show ObjectId;
import 'package:mongo_dart/mongo_dart.dart';
import 'constants.dart';

class Employee {
  final String name;
  final String role;
  final String status;
  final String activestatus;
  final String email;
  final String phone;
  final String department;
  final DateTime dateOfJoining;
  String reasonForLeave;

  Employee({
    required this.name,
    required this.role,
    required this.status,
    required this.activestatus,
    required this.email,
    required this.phone,
    required this.department,
    required this.dateOfJoining,
    this.reasonForLeave = '',
  });


}
class Student {
  final String name;
  final String role;
  final String status;
  final String email;
  final String phone;
  final String department;
  final DateTime dateOfJoining;

  Student({
    required this.name,
    required this.role,
    required this.status,
    required this.email,
    required this.phone,
    required this.department,
    required this.dateOfJoining,
  });
}

class Attache {
  ObjectId? id;
  final String name;
  final String school;
  final String course;
  final String email;
  final String phone;
  final String department;
  final String supervisor;

  Attache({
    this.id,
    required this.name,
    required this.school,
    required this.course,
    required this.email,
    required this.phone,
    required this.supervisor,
    required this.department,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'Name': name,
      'Email': email,
      'School': school,
      'Course': course,
      'Phone number': phone,
      'Department Assigned': department,
      'Name of Supervisor': supervisor,
    };
  }
}


class Intern {
  final String name;
  final String school;
  final String course;
  final String email;
  final String phone;
  final String department;
  final DateTime dateOfJoining;

  Intern({
    required this.name,
    required this.school,
    required this.course,
    required this.email,
    required this.phone,
    required this.department,
    required this.dateOfJoining,
  });
}

class Activity {
  final String activityname;
  final String activityinfo;
  final DateTime dateOfActivity;

  Activity({
    required this.activityname,
    required this.activityinfo,
    required this.dateOfActivity,
  });
}

class EEvent {
  final String eventname;
  final String eventinfo;
  final DateTime dateOfevent;

  EEvent({
    required this.eventname,
    required this.eventinfo,
    required this.dateOfevent,
  });
}

class MongoDatabase {
  static Future<List<int>> connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(COLLECTION_NAME);
    var onleavecollection = db.collection(ON_LEAVE_COLLECTION_NAME);
    var interncollection = db.collection(INTERN_NAME);
    var attachecollection = db.collection(ATTACHE_NAME);
    var eventcollection = db.collection(EVENT_NAME);
    var activitycollection = db.collection(ACTIVITY_NAME);

    var onLeaveUserCount = await onleavecollection.count();
    var userCount = await collection.count();
    var internCount = await interncollection.count();
    var attacheCount = await attachecollection.count();
    var activeCount = (userCount - onLeaveUserCount);
    var totalCount = (userCount + onLeaveUserCount + internCount + attacheCount);

    // calculating percentages
    var userPercentage = (userCount/totalCount) * 100;
    var onLeavePercentage = (onLeaveUserCount/totalCount) * 100;
    var internPercentage = (internCount/totalCount) * 100;
    var attachePercentage = (attacheCount/totalCount) * 100;
    await db.close();
    return [userCount, onLeaveUserCount, internCount, attacheCount, activeCount,];
  }

  static Future<List<double>> calculatePercentage() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(COLLECTION_NAME);
    var onleavecollection = db.collection(ON_LEAVE_COLLECTION_NAME);
    var interncollection = db.collection(INTERN_NAME);
    var attachecollection = db.collection(ATTACHE_NAME);
    var eventcollection = db.collection(EVENT_NAME);
    var activitycollection = db.collection(ACTIVITY_NAME);

    var onLeaveUserCount = await onleavecollection.count();
    var userCount = await collection.count();
    var internCount = await interncollection.count();
    var attacheCount = await attachecollection.count();
    //var activeCount = (userCount - onLeaveUserCount);
    var totalCount = (userCount + onLeaveUserCount + internCount + attacheCount);

    // calculating percentages
    var userPercentage = (userCount/totalCount) * 100;
    var onLeavePercentage = (onLeaveUserCount/totalCount) * 100;
    var internPercentage = (internCount/totalCount) * 100;
    var attachePercentage = (attacheCount/totalCount) * 100;
    await db.close();
    return [userPercentage, onLeavePercentage, internPercentage, attachePercentage,];
  }

  static Future<void> insertEmployee(Employee employee) async {
    // var db = await connect();
    // var collection = db.collection(COLLECTION_NAME);
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(COLLECTION_NAME);

    var newEmployee = {
      'name': employee.name,
      'role': employee.role,
      'status': employee.status,
      'activestatus': employee.activestatus,
      'email': employee.email,
      'phone': employee.phone,
      'department': employee.department,
      'dateOfJoining': employee.dateOfJoining,
    };

    await collection.insert(newEmployee);
    await db.close();
  }

  static Future<List<Employee>> fetchEmployees() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(COLLECTION_NAME);

    var employeeData = await collection.find().toList();
    var employees = employeeData.map((data) {
      var name = data['name'];
      var role = data['role'];
      var status = data['status'];
      var activestatus = data['activestatus'];
      var email = data['email'];
      var phone = data['phone'];
      var department = data['department'];
      var dateOfJoining = data['dateOfJoining'];
      return Employee(
        name: name,
        role: role,
        status: status,
        activestatus: activestatus,
        email: email,
        phone: phone,
        department: department,
        dateOfJoining: dateOfJoining,
      );
    }).toList();

    await db.close();
    return employees;
  }
  static Future<List<Employee>> fetchOnLeaveEmployees() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(ON_LEAVE_COLLECTION_NAME);

    var employeeData = await collection.find().toList();
    var employees = employeeData.map((data) {
      var name = data['name'];
      var role = data['role'];
      var status = data['status'];
      var activestatus = data['status'];
      var email = data['email'];
      var phone = data['phone'];
      var department = data['department'];
      var dateOfJoining = data['dateOfJoining'];
      var reasonForLeave = data['reasonForLeave'];
      return Employee(
        name: name,
        role: role,
        status: status,
        activestatus: activestatus,
        email: email,
        phone: phone,
        department: department,
        reasonForLeave: reasonForLeave,
        dateOfJoining: dateOfJoining,
      );
    }).toList();

    await db.close();
    return employees;
  }
  static Future<void> deleteEmployee(String email) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(COLLECTION_NAME);
    var onLeaveCollection = db.collection(ON_LEAVE_COLLECTION_NAME);

    // Delete the employee from the main collection
    await collection.remove({'email': email});

    // Delete the employee from the on-leave collection
    await onLeaveCollection.remove({'email': email});

    await db.close();
  }

  static Future<void> deleteOnLeaveEmployee(String email) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var onLeaveCollection = db.collection(ON_LEAVE_COLLECTION_NAME);
    var userCollection = db.collection(COLLECTION_NAME);

    // Remove the user from the on-leave collection
    await onLeaveCollection.remove({'email': email});

    // Update the active status of the user in the user collection
    await userCollection.update(
      where.eq('email', email),
      modify.set('activestatus', 'active'),
    );

    await db.close();
  }

  static Future<void> updateEmployee(
    String email,
    String updatedName,
    String updatedEmail,
    String updatedRole,
    String updatedPhone,
  ) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(COLLECTION_NAME);

    await collection.update(
      where.eq('email', email),
      modify
          .set('name', updatedName)
          .set('email', updatedEmail)
          .set('role', updatedRole)
          .set('phone', updatedPhone),
    );

    await db.close();
  }

  static Future<void> addSelectedUserToOnLeaveCollection(String email, String reasonForLeave) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(COLLECTION_NAME);
    var onLeaveCollection = db.collection(ON_LEAVE_COLLECTION_NAME);

    var user = await collection.findOne(where.eq('email', email));

    if (user != null) {
      // Update the user object with the reason for leave
      user['reasonForLeave'] = reasonForLeave;

      // Insert the user into the on-leave collection
      await onLeaveCollection.insert(user);

      // Update the active status of the user in the user collection
      await collection.update(
        where.eq('email', email),
        modify.set('activestatus', 'on-leave'),
      );
    }

    await db.close();
  }

  //attache
  static Future<void> insertStudent(Student student) async {
    // var db = await connect();
    // var collection = db.collection(COLLECTION_NAME);
    var db = await Db.create(MONGO_URL);
    await db.open();
    var collection = db.collection(ATTACHE_NAME);

    var newStudent = {
      'name': student.name,
      'role': student.role,
      'status': student.status,
      'email': student.email,
      'phone': student.phone,
      'department': student.department,
      'dateOfJoining': student.dateOfJoining,
    };

    await collection.insert(newStudent);
    await db.close();
  }
  static Future<void> insertAttache(Attache attache) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var attachecollection = db.collection(ATTACHE_NAME);

    var newAttache = attache.toJson();

    await attachecollection.insert(newAttache);
    await db.close();
  }


  static Future<List<Attache>> fetchAttache() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var attachecollection = db.collection(ATTACHE_NAME);

    var attacheData = await attachecollection.find().toList();
    var attache = attacheData.map((data) {
      var name = data['Name'];
      var email = data['Email'];
      var phone = data['Phone number'];
      var department = data['Department Assigned'];
      var course = data['Course'];
      var school = data['School'];
      // var joining = data['Start Date'];
      // var leaving = data['End Date'];
      var supervisor = data['Name of Supervisor'];
      return Attache(
        name: name,
        email: email,
        phone: phone,
        department: department,
        school: school,
        course: course,
        supervisor: supervisor,
        // joining: joining,
        // leaving: leaving,
      );
    }).toList();

    await db.close();
    return attache;
  }

  static Future<void> deleteAttache(String email) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var attachecollection = db.collection(ATTACHE_NAME);

    await attachecollection.remove({'Email': email});
    await db.close();
  }

  static void updateAttache(
      String email,
      String updatedName,
      String updatedEmail,
      String updatedPhone,
      String updatedDepartment,
      String updatedSchool,
      String updatedCourse,
      String updatedSupervisor,
      ) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var attacheCollection = db.collection(ATTACHE_NAME);

    await attacheCollection.update(
        where.eq('Email', email),
        modify
            .set('Name', updatedName)
            .set('Email', updatedEmail)
            .set('Phone number', updatedPhone)
            .set('Department Assigned', updatedDepartment)
            .set('School', updatedSchool)
            .set('Course', updatedCourse)
            .set('Name of Supervisor', updatedSupervisor)
            );

    await db.close();
  }

  //intern

  static Future<void> insertIntern(Intern intern) async {
    // var db = await connect();
    // var collection = db.collection(COLLECTION_NAME);
    var db = await Db.create(MONGO_URL);
    await db.open();
    var interncollection = db.collection(INTERN_NAME);

    var newIntern = {
      'name': intern.name,
      'email': intern.email,
      'phone': intern.phone,
      'department': intern.department,
      'school': intern.school,
      'course': intern.course,
      'dateOfJoining': intern.dateOfJoining,
    };

    await interncollection.insert(newIntern);
    await db.close();
  }

  static Future<List<Intern>> fetchIntern() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var internCollection = db.collection(INTERN_NAME);

    var internData = await internCollection.find().toList();
    var intern = internData.map((data) {
      var name = data['name'];
      var email = data['email'];
      var phone = data['phone'];
      var department = data['department'];
      var course = data['course'];
      var school = data['school'];
      var dateOfJoining = data['dateOfJoining'];
      return Intern(
        name: name,
        email: email,
        phone: phone,
        department: department,
        school: school,
        course: course,
        dateOfJoining: dateOfJoining,
      );
    }).toList();

    await db.close();
    return intern;
  }

  static Future<void> deleteIntern(String email) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var internCollection = db.collection(INTERN_NAME);

    await internCollection.remove({'email': email});
    await db.close();
  }

  static void updateIntern(
      String email,
      String updatedName,
      String updatedEmail,
      String updatedPhone,
      String updatedDepartment,
      String updatedSchool,
      String updatedCourse) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var internCollection = db.collection(INTERN_NAME);

    await internCollection.update(
        where.eq('email', email),
        modify
            .set('name', updatedName)
            .set('email', updatedEmail)
            .set('phone', updatedPhone)
            .set('phone', updatedDepartment)
            .set('phone', updatedSchool)
            .set('phone', updatedCourse));

    await db.close();
  }

  //activity

  static Future<void> insertActivity(Activity activity) async {
    // var db = await connect();
    // var collection = db.collection(COLLECTION_NAME);
    var db = await Db.create(MONGO_URL);
    await db.open();
    var activitycollection = db.collection(ACTIVITY_NAME);

    var newActivity = {
      'activityname': activity.activityname,
      'activityinfo': activity.activityinfo,
      'dateOfActivity': activity.dateOfActivity,
    };

    await activitycollection.insert(newActivity);
    await db.close();
  }

  static Future<List<Activity>> fetchActivity() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var activitycollection = db.collection(ACTIVITY_NAME);

    var activityData = await activitycollection.find().toList();
    var activity = activityData.map((data) {
      var activityname = data['activityname'];
      var activityinfo = data['activityinfo'];
      var dateOfActivity = data['dateOfActivity'];
      return Activity(
          activityname: activityname,
          activityinfo: activityinfo,
          dateOfActivity: dateOfActivity);
    }).toList();

    await db.close();
    return activity;
  }

  static Future<void> deleteActivity(String activityinfo) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var activitycollection = db.collection(ACTIVITY_NAME);

    await activitycollection.remove({'activityinfo': activityinfo});
    await db.close();
  }

  //event

  static Future<void> insertevent(EEvent event) async {
    // var db = await connect();
    // var collection = db.collection(COLLECTION_NAME);
    var db = await Db.create(MONGO_URL);
    await db.open();
    var eventcollection = db.collection(EVENT_NAME);

    var newEEvent = {
      'eventname': event.eventname,
      'eventinfo': event.eventinfo,
      'dateOfevent': event.dateOfevent,
    };

    await eventcollection.insert(newEEvent);
    await db.close();
  }

  static Future<List<EEvent>> fetchEvent() async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var eventcollection = db.collection(EVENT_NAME);

    var eventData = await eventcollection.find().toList();
    var event = eventData.map((data) {
      var eventname = data['eventname'];
      var eventinfo = data['eventinfo'];
      var dateOfevent = data['dateOfevent'];
      return EEvent(
          eventname: eventname, eventinfo: eventinfo, dateOfevent: dateOfevent);
    }).toList();

    await db.close();
    return event;
  }

  static Future<void> deleteevent(String eventinfo) async {
    var db = await Db.create(MONGO_URL);
    await db.open();
    var eventcollection = db.collection(EVENT_NAME);

    await eventcollection.remove({'eventinfo': eventinfo});
    await db.close();
  }
//streams
  static Stream<List<Employee>> streamEmployees() async* {
    // Fetch the initial employee list from the database
    final initialEmployees = await fetchEmployees();

    // Emit the initial employee list through the stream
    yield initialEmployees;

    // Fetch the updated employee list whenever a change occurs
    while (true) {
      final employees = await fetchEmployees();
      yield employees;
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
  static Stream<List<Intern>> streamIntern() async* {
    // Fetch the initial employee list from the database
    final initialInterns = await fetchIntern();

    // Emit the initial employee list through the stream
    yield initialInterns;

    // Fetch the updated employee list whenever a change occurs
    while (true) {
      final interns = await fetchIntern();
      yield interns;
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
  static Stream<List<Attache>> streamAttache() async* {
    // Fetch the initial employee list from the database
    final initialAttaches = await fetchAttache();

    // Emit the initial employee list through the stream
    yield initialAttaches;

    // Fetch the updated employee list whenever a change occurs
    while (true) {
      final attaches = await fetchAttache();
      yield attaches;
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
  static Stream<List<Activity>> streamActivity() async* {
    // Fetch the initial employee list from the database
    final initialActivity = await fetchActivity();

    // Emit the initial employee list through the stream
    yield initialActivity;

    // Fetch the updated employee list whenever a change occurs
    while (true) {
      final activity = await fetchActivity();
      yield activity;
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
  static Stream<List<EEvent>> streamEvent() async* {
    // Fetch the initial employee list from the database
    final initialEvent = await fetchEvent();

    // Emit the initial employee list through the stream
    yield initialEvent;

    // Fetch the updated employee list whenever a change occurs
    while (true) {
      final event = await fetchEvent();
      yield event;
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
}
