import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rick_and_morty_app/hive/character.dart';
import 'hive/hive_service.dart';
import 'screens/favorite_screen.dart';
import 'screens/main_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(CharacterAdapter());

  await Hive.openBox<Character>("characters");
  final hiveService = HiveService();
  runApp(MyApp(hiveService: hiveService));
}

class MyApp extends StatelessWidget {
  final HiveService hiveService;

  const MyApp({super.key, required this.hiveService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => MainScreen(),
        "/favorites": (context) => FavoritesScreen(hiveService: hiveService),
      },
    );
  }
}