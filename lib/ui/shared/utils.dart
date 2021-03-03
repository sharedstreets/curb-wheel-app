import 'package:curbwheel/ui/map/street_review_map_screen.dart';
import 'package:flutter/material.dart';

Color colorConvert(String color) {
  color = color.replaceAll("#", "");
  if (color.length == 6) {
    return Color(int.parse("0xFF" + color));
  } else if (color.length == 8) {
    return Color(int.parse("0x" + color));
  }
  return Color(0xFFFFFFFF);
}

enum SideOfStreet { Right, Left }

enum DirectionOfTravel { Forward, Backward }

SideOfStreet getSideOfStreetFromString(String side) {
  if (side == SideOfStreet.Left.toString() || side.toLowerCase() == 'left') {
    return SideOfStreet.Left;
  } else if (side == SideOfStreet.Right.toString() ||
      side.toLowerCase() == 'right') {
    return SideOfStreet.Right;
  } else {
    throw Exception("Unknown side of street string value");
  }
}

Widget buildStreetDescription(BuildContext context, SideOfStreet side,
    String startStreetName, String endStreetName) {
  return RichText(
    text: TextSpan(
      text: '',
      style: DefaultTextStyle.of(context).style,
      children: <TextSpan>[
        TextSpan(
            text: side == SideOfStreet.Left ? "Left side" : "Right side",
            style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: " between "),
        TextSpan(
            text: '${startStreetName}',
            style: TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: ' and '),
        TextSpan(
            text: '${endStreetName}',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
