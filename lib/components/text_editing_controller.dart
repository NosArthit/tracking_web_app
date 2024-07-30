import 'package:flutter/material.dart';

class TextEditingControllers {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dateInfoUpdateController =
      TextEditingController();
  final TextEditingController timeInfoUpdateController =
      TextEditingController();

  // For the second set of controllers
  final TextEditingController dateController2 = TextEditingController();
  final TextEditingController timeController2 = TextEditingController();
  final TextEditingController userIdController2 = TextEditingController();
  final TextEditingController firstnameController2 = TextEditingController();
  final TextEditingController lastnameController2 = TextEditingController();
  final TextEditingController companyController2 = TextEditingController();
  final TextEditingController addressController2 = TextEditingController();
  final TextEditingController cityController2 = TextEditingController();
  final TextEditingController stateController2 = TextEditingController();
  final TextEditingController countryController2 = TextEditingController();
  final TextEditingController postalCodeController2 = TextEditingController();
  final TextEditingController phoneController2 = TextEditingController();
  final TextEditingController emailController2 = TextEditingController();
  final TextEditingController statusController2 = TextEditingController();
  final TextEditingController dateInfoUpdateController2 =
      TextEditingController();
  final TextEditingController timeInfoUpdateController2 =
      TextEditingController();

  // For the third set of controllers
  final TextEditingController userController3 = TextEditingController();
  final TextEditingController statusController3 = TextEditingController();

  // For the forth set of controllers
  final TextEditingController userController4 = TextEditingController();
  final TextEditingController statusController4 = TextEditingController();
  final TextEditingController refEmailController4 = TextEditingController();

  // For the fifth set of controllers
  final TextEditingController adminIdController5 = TextEditingController();
  final TextEditingController userIdController5 = TextEditingController();
  final TextEditingController emailController5 = TextEditingController();
  final TextEditingController statusController5 = TextEditingController();
  final TextEditingController registerDateController5 = TextEditingController();
  final TextEditingController registerTimeController5 = TextEditingController();
  final TextEditingController referenceEmailController5 = TextEditingController();

  void dispose() {
    dateController.dispose();
    timeController.dispose();
    userIdController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    companyController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    postalCodeController.dispose();
    phoneController.dispose();
    emailController.dispose();
    dateInfoUpdateController.dispose();
    timeInfoUpdateController.dispose();

    dateController2.dispose();
    timeController2.dispose();
    userIdController2.dispose();
    firstnameController2.dispose();
    lastnameController2.dispose();
    companyController2.dispose();
    addressController2.dispose();
    cityController2.dispose();
    stateController2.dispose();
    countryController2.dispose();
    postalCodeController2.dispose();
    phoneController2.dispose();
    emailController2.dispose();
    statusController2.dispose();
    dateInfoUpdateController2.dispose();
    timeInfoUpdateController2.dispose();

    userController3.dispose();
    statusController3.dispose();

    userController4.dispose();
    statusController4.dispose();
    refEmailController4.dispose();

    adminIdController5.dispose();
    userIdController5.dispose();
    emailController5.dispose();
    statusController5.dispose();
    registerDateController5.dispose();
    registerTimeController5.dispose();
    referenceEmailController5.dispose();
  }
}
