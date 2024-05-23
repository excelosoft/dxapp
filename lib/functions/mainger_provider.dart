import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

class MaingerProvide extends ChangeNotifier{
  bool _maingerStatus=true;
  bool get maingerStatus=>_maingerStatus;
  Future<void> statusUpdate() async {
    _maingerStatus= await GetStorage().read('userStatus');
    notifyListeners();

  }
}
