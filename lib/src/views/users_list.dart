import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:markapp_forms/src/services/db.dart';
import 'package:markapp_forms/src/views/add_user.dart';
import 'package:markapp_forms/src/widgets/list_builder.dart';

import '../constans/ui_constants.dart';
import '../models/user.dart';
import 'user_details.dart';

class UsersList extends StatelessWidget {
  UsersList({
    super.key,
  });

  static const routeName = '/';

  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return StreamBuilder<List<User>>(
        stream: _db.getAllUsers(),
        builder: (context, snapshot) {
          final List<User>? users = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Registered users'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(16.0),
                child: Container(
                  color: theme.colorScheme.surface,
                  child: Text("${users?.length} users"),
                ),
              ),
            ),

            // To work with lists that may contain a large number of items, it’s best
            // to use the ListView.builder constructor.
            //
            // In contrast to the default ListView constructor, which requires
            // building all Widgets up front, the ListView.builder constructor lazily
            // builds Widgets as they’re scrolled into view.
            body: Container(
              margin: EdgeInsets.symmetric(
                    horizontal: ScreenSize.width >= 600 ? 80 : 0,
                  ),
              child: ListBuilder(
                snapshot: snapshot,
                itemBuilder: (ctx, user) {
                  final userColor = int.parse(user.color!);
            
                  return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        backgroundColor: Color(userColor),
                        child: Center(
                          child: Text(
                            '${user.firstName![0]} ${user.lastName![0]}',
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        '${user.firstName} ${user.lastName}',
                        style: theme.textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        '${user.shopName}',
                        style: theme.textTheme.bodyMedium,
                      ),
                      onTap: () {
                        // Navigate to the details page. If the user leaves and returns to
                        // the app after it has been killed while running in the
                        // background, the navigation stack is restored.
                        Navigator.restorablePushNamed(
                          context,
                          UserDetails.routeName,
                          arguments: user.uid,
                        );
                      });
                },
                separatorWidget: const Divider(indent: 70.0),
              ),
            ),

            floatingActionButton: FloatingActionButton(
              child: const Icon(LucideIcons.userPlus2),
              onPressed: () {
                Navigator.pushNamed(context, AddUser.routeName);
              },
            ),
          );
        });
  }
}
