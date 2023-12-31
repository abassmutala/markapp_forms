import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:markapp_forms/src/constans/ui_constants.dart';
import 'package:markapp_forms/src/services/db.dart';
import 'package:markapp_forms/src/views/edit_user.dart';
import 'package:markapp_forms/src/views/users_list.dart';

import '../models/user.dart';

/// Displays detailed information about a SampleItem.
class UserDetails extends StatelessWidget {
  UserDetails({super.key, required this.uid});
  final String uid;

  static const routeName = '/user';

  final DatabaseService db = DatabaseService();

  Future<User> getUserData() async {
    try {
      final data = await db.getUser(uid);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(BuildContext context, String uid) async {
    try {
      await db.deleteUser(uid).then(
            (value) =>
                Navigator.pushReplacementNamed(context, UsersList.routeName),
          );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Error, could not delete user"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return FutureBuilder<User>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final User? user = snapshot.data;

            return Hero(
              tag: uid,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('User Details'),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.restorablePushNamed(
                            context, EditUser.routeName,
                            arguments: uid);
                      },
                      icon: const Icon(LucideIcons.edit2),
                    ),
                    IconButton(
                      icon: Icon(
                        LucideIcons.trash,
                        color: theme.colorScheme.error,
                      ),
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) {
                            return deleteDialog(user!, theme, context);
                          }),
                    ),
                  ],
                ),
                body:
                    // final userColor = (user != null || user?.color != null)
                    //     ? int.parse(user!.color!)
                    //     : "0XFF000000";
                    ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenSize.width >= 600 ? 80 : 0,
                  ),
                  children: <Widget>[
                    Spacing.verticalSpace12,
                    CircleAvatar(
                      minRadius: 25,
                      maxRadius: 75,
                      backgroundColor: Color(
                          user != null ? int.parse(user.color!) : 0xFFF0F0F0),
                      child: Center(
                        child: Text(
                          "${user?.firstName![0]}${user?.lastName![0]}"
                              .toUpperCase(),
                          style: theme.textTheme.displayMedium,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(LucideIcons.user2),
                      title: Text(
                        "Name",
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: theme.hintColor),
                      ),
                      subtitle: Text(
                        "${user?.firstName} ${user?.lastName}",
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(LucideIcons.phone),
                      title: Text(
                        "Phone",
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: theme.hintColor),
                      ),
                      subtitle: Text(
                        "${user?.phone}",
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(LucideIcons.briefcase),
                      title: Text(
                        "Shop",
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: theme.hintColor),
                      ),
                      subtitle: Text(
                        "${user?.title} @ ${user?.shopName}",
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                    ListTile(
                      leading: const Icon(LucideIcons.mapPin),
                      title: Text(
                        "Location",
                        style: theme.textTheme.bodyMedium!
                            .copyWith(color: theme.hintColor),
                      ),
                      subtitle: Text(
                        "${user?.shopLocation}",
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator.adaptive());
        });
  }

  AlertDialog deleteDialog(User user, ThemeData theme, BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: const Text("Delete"),
      content: Text.rich(
        TextSpan(text: "Are you sure you want to delete ", children: [
          TextSpan(
            text: "${user.firstName} ${user.lastName}",
            style: TextStyle(
              color: theme.colorScheme.primary,
            ),
          ),
          const TextSpan(
            text: "?",
          )
        ]),
      ),
      actions: [
        TextButton(
          onPressed: () => deleteUser(
            context,
            user.uid,
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              theme.colorScheme.errorContainer,
            ),
          ),
          child: const Text("Delete"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
      ],
    );
  }
}
