import '../screens/detail_screen.dart';
import '../screens/home_screen.dart';
import '../screens/input_screen.dart';
import 'route_names.dart';

class AppRoute {
  static final routes = {
    RouteNames.homeScreen: (context) => const HomeScreen(),
    RouteNames.detailScreen: (context) => const DetailScreen(),
    RouteNames.inputScreen: (context) => const InputScreen(),
  };
}
