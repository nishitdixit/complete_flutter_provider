import 'package:complete_flutter_provider/screens/settings.dart';
import 'package:complete_flutter_provider/services/firestoreService.dart';
import 'package:complete_flutter_provider/services/phone_auth.dart';
import 'package:complete_flutter_provider/utils/theme_notifier.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService = Provider.of<FirestoreService>(context);
    // ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    print('************************');
    ConnectivityResult connectivityResult =
        Provider.of<ConnectivityResult>(context);
        //  ThemeData theme=themeNotifier.getTheme();
    return Consumer<ThemeNotifier>(builder: (context,themenotifier,child){
    ThemeData  theme=themenotifier.getTheme();
          return Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: appBar(context),
        body: Center(
          child: Column(
            children: [
              Text('Welcome',style: TextStyle(color: theme.accentColor)),
              SizedBox(height: 10),
              Text('Your registered no. is: ${firestoreService.phoneNo}'),
              SizedBox(height: 10),
              Container(
                color: connectivityResult == ConnectivityResult.none
                    ? Colors.red
                    : Colors.green,
                height: 20,
                width: double.infinity,
              ),
              SizedBox(height: 10),
              MaterialButton(
                child: Text('Sign out'),
                color: Colors.blue,
                onPressed: () {
                  PhoneAuth().signout();
                },
              )
            ],
          ),
        ),
      );}
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text('Home Screen',),
      actions: [
        IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (BuildContext context) => SettingsPage()));
            })
      ],
    );
  }
}
