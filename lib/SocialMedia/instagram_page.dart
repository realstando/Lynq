import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:coding_prog/SocialMedia/post_page.dart';
import 'package:coding_prog/NavigationBar/custom_appbar.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';

class InstagramHomePage extends StatefulWidget {
  InstagramHomePage({super.key, required this.onNavigate});
  final void Function(int) onNavigate;
  @override
  _InstagramHomePageState createState() => _InstagramHomePageState();
}

class _InstagramHomePageState extends State<InstagramHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const fblaNavy = Color(0xFF0A2E7F);
  static const fblaGold = Color(0xFFF4AB19);
  static const fblaLightGold = Color(0xFFFFF4E0);

  List<String> savedPages = [];
  TextEditingController _controller = TextEditingController();
  bool _isValidUsername = true;
  bool _hasStartedTyping = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_validateUsername);
  }

  @override
  void dispose() {
    _controller.removeListener(_validateUsername);
    _controller.dispose();
    super.dispose();
  }

  void _validateUsername() {
    final text = _controller.text;

    if (text.isEmpty) {
      setState(() {
        _hasStartedTyping = false;
        _isValidUsername = true;
      });
      return;
    }

    setState(() {
      _hasStartedTyping = true;
      // Instagram username rules:
      // - Only letters, numbers, periods, and underscores
      // - Max 30 characters
      // - Cannot start or end with a period
      // - Cannot have consecutive periods
      final validPattern = RegExp(r'^(?!.*\.\.)(?!.*\.$)[a-zA-Z0-9._]{1,30}$');
      _isValidUsername = validPattern.hasMatch(text) && !text.startsWith('.');
    });
  }

  void _addPage() {
    if (_controller.text.isNotEmpty && _isValidUsername) {
      setState(() {
        savedPages.add(_controller.text.trim());
        _controller.clear();
      });
    }
  }

  void _removePage(int index) {
    setState(() {
      savedPages.removeAt(index);
    });
  }

  Color _getBorderColor() {
    if (!_hasStartedTyping) {
      return Colors.grey.shade300;
    }
    return _isValidUsername ? Colors.green : Colors.red;
  }

  Color _getIconColor() {
    if (!_hasStartedTyping) {
      return fblaNavy;
    }
    return _isValidUsername ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerPage(
        icon: Icons.campaign_rounded,
        name: 'Instagram',
        color: const Color(0xFFDD2A7B),
        onNavigate: widget.onNavigate,
      ),
      appBar: CustomAppBar(
        onNavigate: widget.onNavigate,
        name: 'Instagram Page',
        color: const Color(0xFFDD2A7B),
        scaffoldKey: _scaffoldKey,
      ),
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          // Add Instagram Page Section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Instagram Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: fblaNavy,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Enter Instagram username',
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              prefixIcon: Icon(
                                Icons.alternate_email,
                                color: _getIconColor(),
                              ),
                              suffixIcon: _hasStartedTyping
                                  ? Icon(
                                      _isValidUsername
                                          ? Icons.check_circle
                                          : Icons.error,
                                      color: _isValidUsername
                                          ? Colors.green
                                          : Colors.red,
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _getBorderColor(),
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _getBorderColor(),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _getBorderColor(),
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            onSubmitted: (_) => _addPage(),
                          ),
                          if (_hasStartedTyping && !_isValidUsername)
                            Padding(
                              padding: const EdgeInsets.only(top: 6, left: 12),
                              child: Text(
                                'Invalid username. Use only letters, numbers, periods, and underscores (max 30 characters)',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              _isValidUsername && _controller.text.isNotEmpty
                              ? [fblaGold, const Color(0xFFFFD666)]
                              : [Colors.grey.shade400, Colors.grey.shade500],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (_isValidUsername && _controller.text.isNotEmpty
                                        ? fblaGold
                                        : Colors.grey.shade400)
                                    .withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor:
                              _isValidUsername && _controller.text.isNotEmpty
                              ? fblaNavy
                              : Colors.white,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        onPressed:
                            _isValidUsername && _controller.text.isNotEmpty
                            ? _addPage
                            : null,
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Saved Pages List
          Expanded(
            child: savedPages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: fblaLightGold,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFFFE7B3),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.photo_library_outlined,
                            size: 40,
                            color: fblaNavy,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No pages added yet',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add an Instagram username above!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: savedPages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [fblaLightGold, Color(0xFFFFF9EF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFFFE7B3),
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: fblaNavy,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            '@${savedPages[index]}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: fblaNavy,
                              letterSpacing: -0.3,
                            ),
                          ),
                          subtitle: const Text(
                            'Tap to view posts',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 24,
                            ),
                            onPressed: () => _removePage(index),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostsPage(
                                  username: savedPages[index],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
