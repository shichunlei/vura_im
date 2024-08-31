import 'package:flutter/cupertino.dart';
import 'package:vura/base/base_logic.dart';

class AddWayLogic extends BaseLogic {
  TextEditingController accountController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  AddWayLogic() {
    accountController.addListener(update);
    addressController.addListener(update);
  }
}
