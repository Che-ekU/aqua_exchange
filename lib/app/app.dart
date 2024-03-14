import 'package:aqua_exchange/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AquaExchange extends StatelessWidget {
  const AquaExchange({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          bottomSheetTheme: const BottomSheetThemeData(
            surfaceTintColor: Colors.transparent,
          ),
        ),
        home: const Home(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
