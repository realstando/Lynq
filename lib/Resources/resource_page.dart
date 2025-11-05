import 'package:flutter/material.dart';
import 'package:coding_prog/Resources/resource_format.dart';
import 'package:coding_prog/Resources/resource.dart';

class ResourcePage extends StatelessWidget {
  ResourcePage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60),
          Text(
            "FBLA Resources",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              letterSpacing: 0.5,
              color: Colors.grey[900],
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: 350,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
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
