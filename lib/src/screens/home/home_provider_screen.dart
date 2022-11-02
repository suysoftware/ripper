// ignore: implementation_imports
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripper/src/bloc/user_cubit.dart';
import 'package:ripper/src/screens/home/alive_screen.dart';
import 'package:ripper/src/screens/home/death_screen.dart';

class HomeProviderScreen extends StatefulWidget {
  const HomeProviderScreen({super.key});

  @override
  State<HomeProviderScreen> createState() => _HomeProviderScreenState();
}

class _HomeProviderScreenState extends State<HomeProviderScreen> {
    Future<void> initPlugin() async {
    if (await AppTrackingTransparency.trackingAuthorizationStatus ==
        TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
    //  await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }
  @override
  void initState() {
    super.initState();
       initPlugin();
  }
  @override
  Widget build(BuildContext context) {
    return context.read<RipperUserCubit>().state.userToken < DateTime.now().millisecondsSinceEpoch
        ? const DeathScreen()
        : const AliveScreen();
  }
}
