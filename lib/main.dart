import 'package:cron/cron.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:telaa_app/screen/common/splash_screen.dart';
import 'package:telaa_app/screen/home.dart';
import 'package:telaa_app/screen/login_telaa.dart';
import 'package:telaa_app/screen/profile.dart';
import 'package:telaa_app/screen/suscription.dart';
import 'package:telaa_app/screen/synchronise_data.dart';
import 'package:telaa_app/services/service_locator.dart';
import 'package:telaa_app/services/telaaService.dart';
import 'package:telaa_app/styleguide/colors.dart';
// For changing the language
import 'package:connectivity/connectivity.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telaa_app/utilities/utility.dart';

void main(){
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool internetStatus = false;
  int isPresent = 0;
  String idAtelier = "";
  final TelaaService telaaService = new TelaaService();
  SendBackup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isPresent = prefs.getInt("isPresent");
    String datefin = prefs.getString("datefin");
    DateTime todayDate = DateTime.now();
    DateTime datefinabn = DateTime.parse(datefin);
    var diff = datefinabn.difference(todayDate);
    if ((isPresent == 1) && (diff.inDays >= 0)) {
      idAtelier = prefs.getString("idAtelier");
      String path = await Utility.generateCsvClient();
      telaaService.sendBackup(path, "client", idAtelier);
      String path2 = await Utility.generateCsvClMesure();
      telaaService.sendBackup(path2, "client_mesure", idAtelier);
      String path3 = await Utility.generateCsvCmd();
      telaaService.sendBackup(path3, "commandes", idAtelier);
    }
  }

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    print(result.toString());
    if (result == ConnectivityResult.none) {
    } else if (result == ConnectivityResult.mobile) {
      internetStatus = true;
      SendBackup();
    } else if (result == ConnectivityResult.wifi) {
      internetStatus = true;
      SendBackup();
    }
  }

  @override
  Widget build(BuildContext context) {
    var cron = new Cron();
   // cron.schedule(new Schedule.parse('*/3 * * * *'), () async {
   //   _checkInternetConnectivity();
   // });
    cron.schedule(new Schedule.parse('30 12 * * 0,4'), () async {
      _checkInternetConnectivity();
   });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      routes: {
        '/profile': (context) => ProfilePage(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginTelaa(),
        '/inscrire': (context) => SuscriptionPage(),
        '/synchro': (context) => SynchroniseData(),
       // '/publicite': (context) => PublicitePage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Telaa',
      theme: ThemeData(primaryColor: primaryColor, primarySwatch: Colors.green),
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        // GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('es'), // Spanish
        const Locale('fr'), // French
        const Locale('zh'), // Chinese
      ],
      home: ScreenSplash(),
    );
  }
}
