// ignore_for_file: prefer_const_constructors, camel_case_types
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripper/src/bloc/time_screen_cubit.dart';
import 'package:ripper/src/bloc/user_cubit.dart';
import 'package:ripper/src/constants/language_constants.dart';
import 'package:ripper/src/constants/time_calculator.dart';
import 'package:ripper/src/dialogs/legal_sheet.dart';
import 'package:ripper/src/models/user.dart';
import 'package:ripper/src/screens/help_support_screen.dart';
import 'package:ripper/src/screens/home/alive_screen.dart';
import 'package:ripper/src/screens/home/death_screen.dart';
import 'package:ripper/src/screens/home/home_provider_screen.dart';
import 'package:ripper/src/screens/leaderboard_screen.dart';
import 'package:ripper/src/screens/logged_out_screen.dart';
import 'package:ripper/src/screens/login_screens.dart';
import 'package:ripper/src/screens/profile_screen.dart';
import 'package:ripper/src/screens/recieve_qr_screen.dart';
import 'package:ripper/src/screens/register_screens.dart';
import 'package:ripper/src/services/firebase_auth_service.dart';
import 'package:ripper/src/services/firebase_options.dart';
import 'package:sizer/sizer.dart';
import 'src/screens/intro_screen.dart';

bool isLogged = false;
// ignore: prefer_typing_uninitialized_variables
var ripperUser;

Future<void> main() async {
  await init();

  runApp(EasyLocalization(
      supportedLocales: AppConstant.SUPPORTED_LOCALE,
      path: AppConstant.LANG_PATH,
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp()));
}

//fdsf
Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseOptionsClass.firebaseConfig);
  await FirebaseAuthService.loggedCheck().then((value) => ripperUser = value);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiBlocProvider(providers: [
        BlocProvider(
          create: (context) => RipperUserCubit(),
        ),
        BlocProvider(create: (context) => TimeScreenCubit())
      ], child: _cupertinoApp());
    });
  }
}

class _cupertinoApp extends StatefulWidget {
  // ignore: unused_element
  const _cupertinoApp({super.key});

  @override
  State<_cupertinoApp> createState() => __cupertinoAppState();
}

class __cupertinoAppState extends State<_cupertinoApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    if (ripperUser != null) {
      context.read<RipperUserCubit>().changeUser(ripperUser);

      var ripperUserQua = ripperUser as RipperUser;
      TimeCalculator.timeGetter(ripperUserQua.userToken).then(
          (value) => context.read<TimeScreenCubit>().changeTimeScreen(value));

      isLogged = true;
    } else {
      isLogged = false;
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.inactive) {}

    if (state == AppLifecycleState.paused) {
      //  print(" altta atıldı");

    }

    if (state == AppLifecycleState.resumed) {
      //"alta atıp geri gelince");

    }

    if (state == AppLifecycleState.detached) {}
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      routes: {
        "/": (BuildContext context) => const LoggedOutScreen(),
        "/LoggedOut": (BuildContext context) => const LoggedOutScreen(),
        "/Login": (BuildContext context) => const LoginScreen(),
        "/Register": (BuildContext context) => const RegisterScreen(),
        "/Intro": (BuildContext context) => const IntroScreen(),
        "/Alive": (BuildContext context) => const AliveScreen(),
        "/Profile": (BuildContext context) => const ProfileScreen(),
        "/RecieveQr": (BuildContext context) => const RecieveQrScreen(),
        // "/QrCamera": (BuildContext context) => QrCameraScreen(),
        "/Death": (BuildContext context) => const DeathScreen(),
        "/HomeProvider": (BuildContext context) => const HomeProviderScreen(),
        "/HelpSupport": (BuildContext context) => const HelpAndSupportScreen(),
        "/Legal": (BuildContext context) => const LegalSheet(),
        "/LeaderBoard":(BuildContext context) => const LeaderBoardScreen(),
      },
      initialRoute: isLogged == false ? "/LoggedOut" : "/HomeProvider",
      // initialRoute: "/LoggedOut",
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
