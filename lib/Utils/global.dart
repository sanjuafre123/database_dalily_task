import 'package:flutter/cupertino.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';

import '../controller/database_controller.dart';

var controller = Get.put(DatabaseController());
GlobalKey<FormState> formKey = GlobalKey();
