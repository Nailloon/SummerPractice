import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui';


Gradient randomGradient() {
  Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  Color white = Colors.white;

  return LinearGradient(
    colors: [color, white],
    stops: [0.0, 1.0],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
}

class Contact{
  String name;
  String? avatar;
  String? lastMessage;
  int countUnreadMessages;
  DateTime? dateTime;
  Gradient contactGradient;

Contact(this.name, this.avatar, this.lastMessage, this.countUnreadMessages, this.dateTime, this.contactGradient);
  factory Contact.fromJson(Map json) => Contact(
      json['userName'],
      json['userAvatar'],
      json['lastMessage'],
      json['countUnreadMessages'],
      json['date'] == null ? null : DateTime.fromMillisecondsSinceEpoch(json['date']),
      randomGradient());
}
