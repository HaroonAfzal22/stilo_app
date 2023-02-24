import 'dart:developer';

import 'dart:math' as p;

String? pharma32Convert(String value) {
  int baseValue = 32;
  List reverse = value.split('').reversed.toList();
  String? pharmaCode32;
  log(reverse.toString(), name: "Reversed");
  List conversion_table = [
    {"key": "0", "value": 0},
    {"key": "1", "value": 1},
    {"key": "2", "value": 2},
    {"key": "3", "value": 3},
    {"key": "4", "value": 4},
    {"key": "5", "value": 5},
    {"key": "6", "value": 6},
    {"key": "7", "value": 7},
    {"key": "8", "value": 8},
    {"key": "9", "value": 9},
    {"key": "B", "value": 10},
    {"key": "C", "value": 11},
    {"key": "D", "value": 12},
    {"key": "F", "value": 13},
    {"key": "G", "value": 14},
    {"key": "H", "value": 15},
    {"key": "J", "value": 16},
    {"key": "K", "value": 17},
    {"key": "L", "value": 18},
    {"key": "M", "value": 19},
    {"key": "N", "value": 20},
    {"key": "P", "value": 21},
    {"key": "Q", "value": 22},
    {"key": "R", "value": 23},
    {"key": "S", "value": 24},
    {"key": "T", "value": 25},
    {"key": "U", "value": 26},
    {"key": "V", "value": 27},
    {"key": "W", "value": 28},
    {"key": "X", "value": 29},
    {"key": "Y", "value": 30},
    {"key": "Z", "value": 31},
  ];

  num finalValue = 0;
  for (int i = 0; i < reverse.length; i++) {
    for (int j = 0; j < conversion_table.length; j++) {
      if (reverse[i] == conversion_table[j]['key']) {
        finalValue = finalValue +
            (int.parse(conversion_table[j]['value'].toString()) *
                p.pow(baseValue, i));
        if (finalValue.toString().length <= 8) {
          pharmaCode32 = "0${finalValue.toString()}";
        } else {
          pharmaCode32 = finalValue.toString();
        }
        log("Key :${reverse[i]}  Value:${conversion_table[j]['value']}");
        // log(p.pow(32, i).toString() , name:"Pwoer");
      }
    }
  }
  return pharmaCode32;
}
