import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';

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
  var _sideOfStreet = side == SideOfStreet.Left
      ? AppLocalizations.of(context).leftSide
      : AppLocalizations.of(context).rightSide;
  return Html(
    data: AppLocalizations.of(context)
        .streetContext(_sideOfStreet, startStreetName, endStreetName),
  );
}
