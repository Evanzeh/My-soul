import '../services/user_service.dart';
import 'profile_setup.dart';
if (user!= null) {
  final userData = await UserService().getCurrentUserData();
  if (userData == null) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileSetupScreen()));
  } else {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
  }
}
