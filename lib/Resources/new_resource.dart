import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_prog/globals.dart' as globals;
import 'package:flutter/material.dart';

/// StatefulWidget for creating a new resource
/// Allows users to add educational resources with title, description, and link to a selected group
class NewResource extends StatefulWidget {
  const NewResource(void setState, {super.key});

  @override
  State<NewResource> createState() {
    return _NewAnnouncementState();
  }
}

class _NewAnnouncementState extends State<NewResource> {
  // Text controllers for form inputs
  final _titleController = TextEditingController();
  final _informationController = TextEditingController();
  final _linkController = TextEditingController();

  // Error message for link validation
  String? _linkError;

  // Currently selected group from dropdown
  String? _selectedValue;

  /// Generates a list of group names with codes for the dropdown
  /// Format: "Group Name (CODE)"
  List<String> get groupItems {
    if (globals.groups == null || globals.groups!.isEmpty) {
      return [];
    }
    return globals.groups!.map((group) {
      final name = group['name']?.toString() ?? '';
      final code = group['code']?.toString() ?? '';
      return '$name ($code)';
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    // Add listener to validate link as user types
    _linkController.addListener(_validateLink);
  }

  @override
  void dispose() {
    // Clean up controllers and listeners
    _titleController.dispose();
    _informationController.dispose();
    _linkController.removeListener(_validateLink);
    _linkController.dispose();
    super.dispose();
  }

  /// Submits the resource to Firebase Firestore
  /// Validates all fields before submission and shows error dialogs if validation fails
  Future<void> submitResource() async {
    // Trim all inputs to remove leading/trailing whitespace
    final title = _titleController.text.trim();
    final information = _informationController.text.trim();
    final link = _linkController.text.trim();

    // Check if any field is empty
    if (title.isEmpty || information.isEmpty || link.isEmpty) {
      _showErrorDialog('Missing Information', 'Please fill in all fields.');
      return;
    }

    // Validate URL format
    if (!_isValidUrl(link)) {
      _showErrorDialog(
        'Invalid Link',
        'Please enter a valid URL (e.g., https://example.com).',
      );
      return;
    }

    try {
      // Extract group code from selected value (e.g., "Group Name (CODE)" -> "CODE")
      print(
        _selectedValue!.substring(
          _selectedValue!.indexOf("(") + 1,
          _selectedValue!.indexOf(")"),
        ),
      );

      // Add resource to Firestore under the selected group's resources collection
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(
            _selectedValue!.substring(
              _selectedValue!.indexOf("(") + 1,
              _selectedValue!.indexOf(")"),
            ),
          )
          .collection('resources')
          .add({
            'body': information,
            'title': title,
            'link': link,
          });

      // Close the form if widget is still mounted
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (_) {
      // Silently catch errors (could be improved with error handling)
    }
  }

  /// Validates the link input in real-time as user types
  /// Updates _linkError state to show/hide error message
  void _validateLink() {
    final link = _linkController.text.trim();

    // Clear error if field is empty
    if (link.isEmpty) {
      if (mounted) {
        setState(() {
          _linkError = null;
        });
      }
      return;
    }

    // Check if URL is valid and update error state
    if (!_isValidUrl(link)) {
      if (mounted) {
        setState(() {
          _linkError = 'Invalid URL format';
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _linkError = null;
        });
      }
    }
  }

  /// Validates if a string is a valid URL
  /// Checks for:
  /// - No spaces in URL
  /// - Valid URI format
  /// - HTTP/HTTPS scheme
  /// - Valid domain structure with TLD
  /// Returns true if URL is valid, false otherwise
  bool _isValidUrl(String url) {
    try {
      // Remove whitespace
      url = url.trim();

      // URLs shouldn't contain spaces
      if (url.isEmpty || url.contains(' ')) return false;

      // Add https:// if no scheme is present
      String urlToValidate = url;
      if (!url.startsWith('http://') &&
          !url.startsWith('https://') &&
          !url.contains('://')) {
        urlToValidate = 'https://$url';
      }

      // Try to parse the URL
      final uri = Uri.tryParse(urlToValidate);
      if (uri == null) return false;

      // URL must have both scheme (http/https) and authority (domain)
      if (!uri.hasScheme || !uri.hasAuthority) return false;

      // Only allow http and https protocols
      if (uri.scheme != 'http' && uri.scheme != 'https') return false;

      // Host must contain at least one dot (for TLD)
      if (!uri.host.contains('.')) return false;

      // Split host into parts (e.g., "example.com" -> ["example", "com"])
      List<String> parts = uri.host.split('.');
      if (parts.length < 2) return false;

      // Each part must not be empty (e.g., "example..com" is invalid)
      for (String part in parts) {
        if (part.isEmpty) return false;
      }

      // The last part (TLD like .com, .org) must be at least 2 characters
      if (parts.last.length < 2) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Shows an error dialog with a custom title and message
  /// Used for validation errors and missing information
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: ((ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // Title with warning icon
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFFFD700),
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Color(0xFF003B7E),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // Error message content
          content: Text(
            message,
            style: TextStyle(fontSize: 16),
          ),
          // Dismiss button
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF003B7E),
              ),
              child: Text(
                "Got it!",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // App bar with title
      appBar: AppBar(
        title: Text(
          "New Resource",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF003B7E),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),

              // Group Selection Section
              Text(
                "Group",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF003B7E),
                ),
              ),
              SizedBox(height: 8),
              // Dropdown to select which group the resource belongs to
              DropdownButtonFormField<String>(
                value: _selectedValue,
                hint: Text(
                  'Select a group',
                  style: TextStyle(color: Colors.grey[400]),
                ),
                items: groupItems.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedValue = newValue;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Select a group',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF003B7E), width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Resource Title Section
              Text(
                "Resource Title",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF003B7E),
                ),
              ),
              SizedBox(height: 8),
              // Input field for resource title (max 75 characters)
              TextField(
                controller: _titleController,
                maxLength: 75,
                onTapOutside: (event) {
                  // Dismiss keyboard when tapping outside
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: "Enter resource title...",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF003B7E), width: 2),
                  ),
                  counter: Offstage(), // Hide character counter
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Description Section
              Text(
                "Description",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF003B7E),
                ),
              ),
              SizedBox(height: 8),
              // Multi-line input field for resource description (max 200 characters)
              TextField(
                controller: _informationController,
                maxLength: 200,
                maxLines: 4,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: "Brief description of the resource...",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF003B7E), width: 2),
                  ),
                  counter: Offstage(), // Hide character counter
                  contentPadding: EdgeInsets.all(16),
                  alignLabelWithHint: true,
                ),
              ),

              SizedBox(height: 24),

              // Resource Link Section
              Text(
                "Resource Link",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF003B7E),
                ),
              ),
              SizedBox(height: 8),
              // Input field for resource URL with real-time validation
              TextField(
                controller: _linkController,
                maxLength: 500,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: "https://example.com or example.com",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  // Show check or error icon based on validation
                  suffixIcon: _linkController.text.isNotEmpty
                      ? Icon(
                          _linkError == null ? Icons.check_circle : Icons.error,
                          color: _linkError == null ? Colors.green : Colors.red,
                        )
                      : null,
                  errorText: _linkError,
                  errorStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                  // Dynamic border colors based on validation state
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _linkError != null
                          ? Colors.red
                          : Colors.grey[300]!,
                      width: _linkError != null ? 2 : 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _linkError != null
                          ? Colors.red
                          : Color(0xFF003B7E),
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  counter: Offstage(), // Hide character counter
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),

              SizedBox(height: 40),

              // Submit Button
              Center(
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    // Gradient background for visual appeal
                    gradient: LinearGradient(
                      colors: [Color(0xFF003B7E), Color(0xFF002856)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF003B7E).withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: submitResource,
                      borderRadius: BorderRadius.circular(16),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Upload icon
                            Icon(
                              Icons.cloud_upload,
                              color: Color(0xFFFFD700),
                              size: 22,
                            ),
                            SizedBox(width: 12),
                            // Button text
                            Text(
                              "Save Resource",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
