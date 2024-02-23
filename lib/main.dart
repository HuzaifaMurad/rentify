import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentify/admin/admin_login.dart';
import 'package:rentify/admin/admin_screen.dart';
// import 'package:rentify/features/auth/screen/fingerprint_screen.dart';
import 'package:rentify/features/auth/screen/login_screen.dart';
import 'package:rentify/features/dashboard.dart/dashboard_screen.dart';
// import 'package:rentify/features/home/screen/home_screen.dart';
// import 'package:rentify/features/home/screen/product_detail_screen.dart';
// import 'package:rentify/features/home/screen/user_details_scrreen.dart';
import 'package:rentify/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/common/error_text.dart';
import 'core/common/loader.dart';
import 'features/auth/controller/auth_controller.dart';
import 'firebase_options.dart';
import 'models/user_models.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'RENTIFY',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       // onGenerateRoute: (settings) => generateRoute(settings),
//       home: const LoginScreen(),
//     );
//   }
// }

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;
  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUSerData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateProvider).when(
          data: (data) {
            if (kIsWeb) {
              return ScreenUtilInit(
                designSize: const Size(1366, 768),
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'RENTIFY',
                  theme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                  ),
                  // onGenerateRoute: (settings) => generateRoute(settings),
                  home: const AdminPanelDashboard(),
                ),
              );
            }
            if (data != null) {
              getData(ref, data);
              if (userModel != null) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'RENTIFY',
                  theme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                  ),
                  onGenerateRoute: (settings) => generateRoute(settings),
                  home: userModel!.status == 'active'
                      ? const DashBoard()
                      : const Loaders(), // Use your logged-in route here
                );
              }
            } else {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'RENTIFY',
                theme: ThemeData(
                  colorScheme:
                      ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                  useMaterial3: true,
                ),
                onGenerateRoute: (settings) => generateRoute(settings),
                home: const LoginScreen(),
              );
            }
            return const Loader();
          },
          error: (error, stackTrace) {
            return ErrorText(errorText: error.toString());
          },
          loading: () => const Loader(),
        );
  }
}
