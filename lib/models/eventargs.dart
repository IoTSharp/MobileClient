import 'package:flutter/material.dart';

class EventArgs<T> {
  const EventArgs(
      {required this.eventName, required this.item, required this.context});

  final BuildContext context;
  final T item;
  final String eventName;
}
