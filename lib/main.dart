import 'package:curbwheel/ui/camera/camera_screen.dart';
import 'package:curbwheel/ui/camera/preview_screen.dart';
import 'package:curbwheel/ui/features/features_screen.dart';
import 'package:curbwheel/ui/map/street_select_map_screen.dart';
import 'package:curbwheel/ui/projects/project_list_screen.dart';
import 'package:curbwheel/service/bluetooth_service.dart';
import 'package:curbwheel/ui/map/map_database.dart';
import 'package:curbwheel/ui/splash/splash_screen.dart';
import 'package:curbwheel/ui/wheel/wheel_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/database.dart';

void main() => runApp(MultiProvider(providers: [
      Provider<CurbWheelDatabase>(create: (_) => CurbWheelDatabase()),
      Provider<ProjectMapDatastores>(create: (_) => ProjectMapDatastores()),
      ChangeNotifierProvider(create: (BuildContext context) => BleConnection()),
      ChangeNotifierProxyProvider<BleConnection, WheelCounter>(
        create: (BuildContext context) => WheelCounter(),
        update: (BuildContext context, BleConnection bleConnection,
                WheelCounter existingWheelCounter) =>
            existingWheelCounter.updateConnection(bleConnection),
      )
    ], child: CurbWheel()));

class CurbWheel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CurbWheel',
      theme: ThemeData(
          fontFamily: 'Raleway',
          primaryColor: Colors.black,
          textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 52.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            subtitle2: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          )
        ),
        onGenerateRoute: (settings) {
          if (settings.name == WheelScreen.routeName) {
            final WheelScreenArguments args = settings.arguments;
            return MaterialPageRoute(
              builder: (context) {
                return WheelScreen(args.project, args.survey, args.incompleteSpans,
                    listItem: args.listItem);
              },
            );
          } if (settings.name == MapScreen.routeName) {
            final MapScreenArguments args = settings.arguments;
            return MaterialPageRoute(
              builder: (context) {
                return MapScreen(project: args.project);
              },
            );
          } if (settings.name == CameraScreen.routeName) {
            final CameraScreenArguments args = settings.arguments;
            return MaterialPageRoute(
              builder: (context) {
                return CameraScreen(surveyItemId: args.surveyItemId, position: args.position, pointId: args.pointId,);
              },
            );
          } if (settings.name == PreviewScreen.routeName) {
            final PreviewScreenArguments args = settings.arguments;
            return MaterialPageRoute(
              builder: (context) {
                return PreviewScreen(surveyItemId: args.surveyItemId, filePath: args.filePath, position: args.position, pointId: args.pointId);
              },
            );
          } if (settings.name == StreetSelectMapScreen.routeName) {
            final StreetSelectMapScreenArguments args = settings.arguments;
            return MaterialPageRoute(
              builder: (context) {
                return StreetSelectMapScreen(project: args.project);
              },
            );
          } else {
            return null;
          }
        },
        routes: {
          SplashScreen.routeName: (context) => SplashScreen(),
          ProjectListScreen.routeName: (context) => ProjectListScreen(),
          FeatureSelectScreen.routeName: (context) => FeatureSelectScreen(),
        },
      );
  }
}
