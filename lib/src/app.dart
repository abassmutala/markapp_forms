import 'package:flutter/material.dart';
import 'package:markapp_forms/src/constans/ui_constants.dart';
import 'package:markapp_forms/src/views/add_user.dart';
import 'package:markapp_forms/src/views/edit_user.dart';

import 'views/user_details.dart';
import 'views/users_list.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // MaterialApp to restore the navigation stack when a user leaves and
      // returns to the app after it has been killed while running in the
      // background.
      restorationScopeId: 'app',

      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFCB2172),
          ),
          fontFamily: "ProductSans"),
      darkTheme: ThemeData.dark(),

      onGenerateRoute: (RouteSettings routeSettings) {
        final args = routeSettings.arguments;
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case UserDetails.routeName:
                if (args is String) {
                  return UserDetails(
                    uid: args,
                  );
                }
                return _errorPage();
              case AddUser.routeName:
                return const AddUser();
              case EditUser.routeName:
                if (args is String) {
                  return EditUser(
                    uid: args,
                  );
                }
                return _errorPage();
              case UsersList.routeName:
              default:
                return UsersList();
            }
          },
        );
      },
    );
  }

  Widget _errorPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: const Center(
        child: Text('ERROR'),
      ),
    );
  }
}
