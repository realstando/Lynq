import 'package:flutter/material.dart';
import 'package:coding_prog/Resources/resource_format.dart';
import 'package:coding_prog/Resources/resource.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';
import 'package:coding_prog/NavigationBar/custom_appbar.dart';

class ResourcePage extends StatelessWidget {
  ResourcePage({super.key, required this.onNavigate});
  final void Function(int) onNavigate;

  final List<Resource> resources = [
    Resource(
      title: "Competitive Events",
      link: "https://flutter.dev/docs",
      body: "Take a look at the list of competitive events!",
    ),
    Resource(
      title: "Dart Language Tour",
      link: "https://dart.dev/guides/language/language-tour",
      body: "In-depth overview of the Dart programming language.",
    ),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerPage(
        icon: Icons.menu_book_rounded,
        name: 'FBLA Resources',
        color: Colors.green[700]!,
        onNavigate: onNavigate,
      ),
      appBar: CustomAppBar(
        onNavigate: onNavigate,
        name: 'FBLA Resources',
        color: Colors.green[700]!,
        scaffoldKey: _scaffoldKey,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: resources.length,
              itemBuilder: (context, index) =>
                  ResourceFormat(resource: resources[index]),
            ),
          ),
        ],
      ),
    );
  }
}
