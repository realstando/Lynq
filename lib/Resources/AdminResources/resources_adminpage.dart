// import 'package:coding_prog/Resources/new_resource.dart';
// import 'package:flutter/material.dart';
// import 'package:coding_prog/Resources/AdminResources/resource_adminformat.dart';
// import 'package:coding_prog/Resources/resource.dart';

// class AdminResourcePage extends StatefulWidget {
//   const AdminResourcePage({super.key});

//   @override
//   State<AdminResourcePage> createState() {
//     return _AdminResourcePageState();
//   }
// }

// class _AdminResourcePageState extends State<AdminResourcePage> {
//   final List<Resource> resources = [
//     Resource(
//       title: "Competitive Events",
//       link: "https://flutter.dev/docs",
//       body: "Take a look at the list of competitive events!",
//     ),
//     Resource(
//       title: "Dart Language Tour",
//       link: "https://dart.dev/guides/language/language-tour",
//       body: "In-depth overview of the Dart programming language.",
//     ),
//   ];

//   void _openAddResourceOverlay() {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => NewResource(addResource: _onAddResource),
//       ),
//     );
//   }

//   void _onAddResource(Resource resource) {
//     setState(() {
//       resources.insert(0, resource);
//     });
//     Navigator.pop(context);
//   }

//   void _onRemoveResource(Resource resource) {
//     showDialog(
//       context: context,
//       builder: (ctx) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: Row(
//             children: [
//               Icon(
//                 Icons.delete_outline,
//                 color: Colors.red,
//                 size: 28,
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   "Delete Resource",
//                   style: TextStyle(
//                     color: Color(0xFF003B7E),
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           content: Text(
//             "Are you sure you want to delete '${resource.title}'? This action cannot be undone.",
//             style: TextStyle(fontSize: 16),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(ctx);
//               },
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.grey[600],
//               ),
//               child: Text(
//                 "Cancel",
//                 style: TextStyle(fontWeight: FontWeight.w600),
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: TextButton(
//                 onPressed: () {
//                   setState(() {
//                     resources.remove(resource);
//                   });
//                   Navigator.pop(ctx);

//                   // Show confirmation snackbar
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Resource deleted successfully'),
//                       backgroundColor: Colors.red,
//                       duration: Duration(seconds: 2),
//                     ),
//                   );
//                 },
//                 style: TextButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 ),
//                 child: Text(
//                   "Delete",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       floatingActionButton: Padding(
//         padding: EdgeInsets.only(bottom: 20, right: 8),
//         child: Container(
//           height: 56,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF003B7E), Color(0xFF002856)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Color(0xFF003B7E).withOpacity(0.4),
//                 blurRadius: 12,
//                 offset: Offset(0, 6),
//               ),
//             ],
//           ),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: _openAddResourceOverlay,
//               borderRadius: BorderRadius.circular(16),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.add, color: Color(0xFFE8B44C), size: 24),
//                     SizedBox(width: 12),
//                     Text(
//                       "New Resource",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           SizedBox(height: 60),
//           Text(
//             "FBLA Resources",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 32,
//               letterSpacing: 0.5,
//               color: Colors.grey[900],
//             ),
//           ),
//           SizedBox(height: 16),
//           Container(
//             width: 350,
//             height: 4,
//             decoration: BoxDecoration(
//               color: Color(0xFFE8B44C),
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           SizedBox(height: 12),
//           Expanded(
//             child: resources.isEmpty
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.folder_open,
//                           size: 64,
//                           color: Colors.grey[400],
//                         ),
//                         SizedBox(height: 16),
//                         Text(
//                           "No resources yet",
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: Colors.grey[600],
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           "Tap the + button to add a resource",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[500],
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//                 : ListView.builder(
//                     itemCount: resources.length,
//                     itemBuilder: (context, index) => AdminResourceFormat(
//                       resource: resources[index],
//                       onDelete: () => _onRemoveResource(resources[index]),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
