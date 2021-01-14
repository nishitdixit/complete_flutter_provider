import 'package:complete_flutter_provider/screens/home_screen.dart';
import 'package:complete_flutter_provider/screens/login_screen.dart';
import 'package:complete_flutter_provider/services/firestoreService.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';

class RouteBasedOnAuth extends StatelessWidget {
  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;

  const RouteBasedOnAuth({Key key, this.builder}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data != null)
              return MultiProvider(providers: [
               
                Provider<FirestoreService>(
                  create: (_) =>
                      FirestoreService(phoneNo: snapshot.data.phoneNumber),
                )
              ], child: builder(context, snapshot));
            else
              return builder(context, snapshot);
          }

          return CircularProgressIndicator();
        });
  }
}

class Routewidget extends StatelessWidget {
  final AsyncSnapshot<User> currentUserSnapshot;

  const Routewidget({Key key, this.currentUserSnapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentUserSnapshot.data != null)
      return HomeScreen();
    else if (currentUserSnapshot.data == null) return LogInScreen();

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
