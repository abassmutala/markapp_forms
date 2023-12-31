import 'package:flutter/material.dart';
import 'package:markapp_forms/src/constans/regex_patterns.dart';
import 'package:markapp_forms/src/constans/ui_constants.dart';
import 'package:markapp_forms/src/models/user.dart';
import 'package:markapp_forms/src/services/db.dart';
import 'package:markapp_forms/src/views/user_details.dart';
import 'package:markapp_forms/src/widgets/input_field.dart';

class EditUser extends StatefulWidget {
  const EditUser({super.key, required this.uid});

  final String uid;

  static const routeName = '/edit-user';

  @override
  State<EditUser> createState() => _AddUserState();
}

final List<Map<String, String>> titles = [
  {"Title": ""},
  {"Owner": "owner"},
  {"Worker": "worker"},
  {"Apprentice": "apprentice"}
];

class _AddUserState extends State<EditUser> {
  final DatabaseService db = DatabaseService();

  final _editUserFormKey = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late FocusNode firstNameFocus;
  late void Function()? firstNameEditingComplete;
  late TextEditingController lastNameController;
  late FocusNode lastNameFocus;
  late void Function()? lastNameEditingComplete;
  late TextEditingController phoneController;
  late FocusNode phoneFocus;
  late void Function()? phoneEditingComplete;
  late FocusNode titleFocus;
  late TextEditingController shopNameController;
  late FocusNode shopNameFocus;
  late void Function()? shopNameEditingComplete;
  late TextEditingController shopLocationController;
  late FocusNode shopLocationFocus;
  late void Function()? shopLocationEditingComplete;
  late bool isFetching;
  late bool isLoading;
  late String titleValue;

  @override
  void initState() {
    super.initState();
    getUserData();
    firstNameController = TextEditingController();
    firstNameFocus = FocusNode();
    firstNameEditingComplete = () => FocusScope.of(context).nextFocus();
    lastNameController = TextEditingController();
    lastNameFocus = FocusNode();
    lastNameEditingComplete = () => FocusScope.of(context).nextFocus();
    phoneController = TextEditingController();
    phoneFocus = FocusNode();
    phoneEditingComplete = () => FocusScope.of(context).nextFocus();
    titleFocus = FocusNode();
    shopNameController = TextEditingController();
    shopNameFocus = FocusNode();
    shopNameEditingComplete = () => FocusScope.of(context).nextFocus();
    shopLocationController = TextEditingController();
    shopLocationFocus = FocusNode();
    shopLocationEditingComplete = () => FocusScope.of(context).nextFocus();
    isFetching = false;
    isLoading = false;
    titleValue = "";
  }

  Future<void> getUserData() async {
    try {
      setState(() {
        isFetching = true;
      });
      final data = await db.getUser(widget.uid);
      final User user = data;
      firstNameController = TextEditingController(text: user.firstName);
      lastNameController = TextEditingController(text: user.lastName);
      phoneController = TextEditingController(text: user.phone);
      shopNameController = TextEditingController(text: user.shopName);
      shopLocationController = TextEditingController(text: user.shopLocation);
      // titleValue = titles.first[user.title]!;
      // debugPrint(titles.first[user.title]!);
      setState(() {
        isFetching = false;
      });
    } catch (e) {
      setState(() {
        isFetching = false;
      });
      rethrow;
    }
  }

  Future<void> updateUser() async {
    try {
      setState(() {
        isLoading = true;
      });
      final userData = {
        "uid": widget.uid,
        "firstName": firstNameController.text,
        "lastName": lastNameController.text,
        "phone": phoneController.text,
        "title": titleValue,
        "shopName": shopNameController.text,
        "shopLocation": shopLocationController.text,
      };
      await db.updateUser(widget.uid, userData);
      setState(() {
        isLoading = false;
        Navigator.pop(context);
        Navigator.pushReplacementNamed(
          context,
          UserDetails.routeName,
          arguments: widget.uid,
        );
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit user"),
      ),
      body: isFetching
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenSize.width >= 600 ? 80 : 16,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _editUserFormKey,
                  child: Column(
                    children: [
                      Spacing.verticalSpace24,
                      firstNameInput(),
                      Spacing.verticalSpace8,
                      lastNameInput(),
                      Spacing.verticalSpace8,
                      phoneInput(),
                      Spacing.verticalSpace8,
                      titleDropdown(theme),
                      Spacing.verticalSpace8,
                      shopNameInput(),
                      Spacing.verticalSpace8,
                      shopLocationInput(),
                      Spacing.verticalSpace24,
                      submitButton(context),
                      Spacing.verticalSpace24,
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  InputField firstNameInput() {
    return InputField(
      enabled: isLoading == false,
      labelText: "First name",
      hintText: "Enter your first name",
      controller: firstNameController,
      focusNode: firstNameFocus,
      keyboardType: TextInputType.name,
      onEditingComplete: firstNameEditingComplete,
      validator: (val) => val!.length < 3 ? "Name is too short" : null,
      textInputAction: TextInputAction.next,
    );
  }

  InputField lastNameInput() {
    return InputField(
      enabled: isLoading == false,
      labelText: "Last name",
      hintText: "Enter your last name",
      controller: lastNameController,
      focusNode: lastNameFocus,
      keyboardType: TextInputType.name,
      onEditingComplete: lastNameEditingComplete,
      validator: (val) => val!.length < 3 ? "Name is too short" : null,
      textInputAction: TextInputAction.next,
    );
  }

  InputField phoneInput() {
    return InputField(
      enabled: isLoading == false,
      labelText: "Phone number",
      hintText: "Enter your 10 digit phone number",
      controller: phoneController,
      focusNode: phoneFocus,
      keyboardType: TextInputType.phone,
      onEditingComplete: phoneEditingComplete,
      validator: (val) => !phoneNumberPattern.hasMatch(val!)
          ? "Phone number should be at least 10 digits"
          : null,
      textInputAction: TextInputAction.next,
    );
  }

  InputField shopNameInput() {
    return InputField(
      enabled: isLoading == false,
      labelText: "Shop name",
      hintText: "e.g. Chancellor Haircuts",
      controller: shopNameController,
      focusNode: shopNameFocus,
      keyboardType: TextInputType.text,
      onEditingComplete: shopNameEditingComplete,
      validator: (val) => val!.length < 3 ? "Shop name is too short" : null,
      textInputAction: TextInputAction.next,
    );
  }

  InputField shopLocationInput() {
    return InputField(
      enabled: isLoading == false,
      labelText: "Shop location",
      hintText: "e.g. Community 25, Tema",
      controller: shopLocationController,
      focusNode: shopLocationFocus,
      keyboardType: TextInputType.streetAddress,
      onEditingComplete: firstNameEditingComplete,
      validator: (val) => val!.length < 10 ? "Location is too short" : null,
      textInputAction: TextInputAction.done,
    );
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems(ThemeData theme) {
    return titles.map((titlesMap) {
      String key = titlesMap.keys.first;
      String value = titlesMap.values.first;

      return DropdownMenuItem<String>(
        value: value,
        enabled: value != "",
        child: Text(
          key,
          style: TextStyle(color: value == "" ? theme.hintColor : Colors.black),
        ),
      );
    }).toList();
  }

  Widget titleDropdown(ThemeData theme) {
    return Padding(
      padding: Insets.verticalPadding8,
      child: DropdownButtonFormField<String>(
        items: buildDropdownMenuItems(theme),
        value: titleValue,
        onChanged: (String? newValue) {
          setState(() {
            titleValue = newValue!;
          });
        },
        decoration: InputDecoration(
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        focusNode: titleFocus,
        style: theme.textTheme.titleLarge,
        validator: (value) =>
            (value == "owner" || value == "apprentice" || value == "worker")
                ? null
                : "Please select your title",
      ),
    );
  }

  ConstrainedBox submitButton(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 512.0,
        minWidth: MediaQuery.of(context).size.width / 2,
        minHeight: 45.0,
      ),
      child: ElevatedButton(
        onPressed: () async {
          !isLoading && _editUserFormKey.currentState!.validate()
              ? updateUser()
              : null;
        },
        child: isLoading
            ? const CircularProgressIndicator.adaptive()
            : const Text("Update"),
      ),
    );
  }
}
