import 'package:flutter/material.dart';
import 'package:coding_prog/Resources/resource_format.dart';
import 'package:coding_prog/Resources/resource.dart';

class ResourcePage extends StatelessWidget {
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

  const ResourcePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: resources.length,
        itemBuilder: (context, index) =>
            ResourceFormat(resource: resources[index]),
      ),
    );
  }
}
