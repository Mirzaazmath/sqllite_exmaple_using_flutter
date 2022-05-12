

import 'dbhelper.dart';

class Car {

 late String name;
 late String miles;

  Car(this.name, this.miles);

  Car.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    miles = map['miles'];
  }

  Map<String, dynamic> toMap() {
    return {

      DatabaseHelper.columnName: name,
      DatabaseHelper.columnMiles: miles,
    };
  }
}