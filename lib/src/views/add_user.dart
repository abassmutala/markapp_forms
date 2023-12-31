import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:markapp_forms/src/constans/regex_patterns.dart';
import 'package:markapp_forms/src/constans/ui_constants.dart';
import 'package:markapp_forms/src/models/user.dart';
import 'package:markapp_forms/src/services/db.dart';
import 'package:markapp_forms/src/utils/utils.dart';
import 'package:markapp_forms/src/views/users_list.dart';
import 'package:markapp_forms/src/widgets/input_field.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  static const routeName = '/add-user';

  @override
  State<AddUser> createState() => _AddUserState();
}

final List<Map<String, String>> titles = [
  {"Title": ""},
  {"Owner": "owner"},
  {"Worker": "worker"},
  {"Apprentice": "apprentice"}
];

class _AddUserState extends State<AddUser> {
  final DatabaseService db = DatabaseService();

  final _addUserFormKey = GlobalKey<FormState>();
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
  late bool isLoading;
  late String titleValue;

  @override
  void initState() {
    super.initState();
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
    isLoading = false;
    titleValue = "";
  }

  Future<void> registerUser() async {
    try {
      setState(() {
        isLoading = true;
      });
      User user = User(
        uid: "",
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        phone: phoneController.text,
        title: titleValue,
        shopName: shopNameController.text,
        shopLocation: shopLocationController.text,
        dateJoined: DateTime.now().millisecondsSinceEpoch,
        color: Utilities.generateRandomColor(),
      );
      final uid = await db.addUser(user);
      debugPrint("User added");
      await db.updateUID(uid);
      debugPrint("User uid updated");
      setState(() {
        isLoading = false;
        Navigator.pushReplacementNamed(context, UsersList.routeName);
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: kToolbarHeight * 3,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "assets/images/easy_waves_banner.png",
                fit: BoxFit.cover,
              ),
              // title: const Text("Register"),
            ),
          )
        ],
        body: Container(
          margin: EdgeInsets.symmetric(
            horizontal: ScreenSize.width >= 600 ? 64 : 16,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _addUserFormKey,
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
      ),
    );
  }

  InputField firstNameInput() {
    return InputField(
      enabled: isLoading == false,
      autofocus: true,
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
      validator: (val) => val!.length < 4 ? "Location is too short" : null,
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
        icon: const Icon(LucideIcons.chevronDown),
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
          !isLoading && _addUserFormKey.currentState!.validate()
              ? registerUser()
              : null;
        },
        child: isLoading
            ? const CircularProgressIndicator.adaptive()
            : const Text("Register"),
      ),
    );
  }
}
