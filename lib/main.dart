import 'package:complete_flutter_provider/services/RoutingService.dart';
import 'package:complete_flutter_provider/utils/connectivityService.dart';
import 'package:complete_flutter_provider/utils/theme_notifier.dart';
import 'package:complete_flutter_provider/values/theme.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print('${snapshot.error}');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return RouteBasedOnAuth(
              builder: (BuildContext context, localUserSnapshot) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<ThemeNotifier>(
                  create: (_) => ThemeNotifier(darkTheme),
                ),
                StreamProvider<ConnectivityResult>.value(
                  value:
                      ConnectivityService().connectionStatusController.stream,
                ),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: Routewidget(currentUserSnapshot: localUserSnapshot),
                // home: RoutingBasedOnAuth().checkAuth(),
              ),
            );
          });
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}
