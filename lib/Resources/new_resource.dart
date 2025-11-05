import 'package:flutter/material.dart';
import 'package:coding_prog/Resources/resource.dart';

class NewResource extends StatefulWidget {
  const NewResource({required this.addResource, super.key});
  final void Function(Resource resource) addResource;

  @override
  State<NewResource> createState() {
    return _NewAnnouncementState();
  }
}

List<String> items = ['Washington', 'Oregon', 'North Creek'];

class _NewAnnouncementState extends State<NewResource> {
  final _titleController = TextEditingController();
  final _informationController = TextEditingController();
  final _linkController = TextEditingController();

  String _selectedValue = items[0];
  String? _linkError;

  @override
  void initState() {
    super.initState();
    _linkController.addListener(_validateLink);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _informationController.dispose();
    _linkController.removeListener(_validateLink);
    _linkController.dispose();
    super.dispose();
  }

  void submitResource() {
    // Trim all inputs
    final title = _titleController.text.trim();
    final information = _informationController.text.trim();
    final link = _linkController.text.trim();

    // Check if any field is empty
    if (title.isEmpty || information.isEmpty || link.isEmpty) {
      _showErrorDialog('Missing Information', 'Please fill in all fields.');
      return;
    }

    // Validate URL
    if (!_isValidUrl(link)) {
      _showErrorDialog(
        'Invalid Link',
        'Please enter a valid URL (e.g., https://example.com).',
      );
      return;
    }

    // If everything is valid, add the resource
    widget.addResource(
      Resource(
        body: information,
        title: title,
        link: link,
      ),
    );
  }

  void _validateLink() {
    final link = _linkController.text.trim();

    if (link.isEmpty) {
      if (mounted) {
        setState(() {
          _linkError = null;
        });
      }
      return;
    }

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

  bool _isValidUrl(String url) {
    try {
      // Remove whitespace
      url = url.trim();

      // Check for spaces (URLs shouldn't have spaces)
      if (url.isEmpty || url.contains(' ')) return false;

      // Add https:// if no scheme is present
      String urlToValidate = url;
      if (!url.startsWith('http://') &&
          !url.startsWith('https://') &&
          !url.contains('://')) {
        urlToValidate = 'https://$url';
      }

      final uri = Uri.tryParse(urlToValidate);
      if (uri == null) return false;

      // Must have scheme and authority
      if (!uri.hasScheme || !uri.hasAuthority) return false;

      // Must be http or https
      if (uri.scheme != 'http' && uri.scheme != 'https') return false;

      // Host must contain at least one dot
      if (!uri.host.contains('.')) return false;

      // Check that there's content before and after the dot
      List<String> parts = uri.host.split('.');
      if (parts.length < 2) return false;

      // Each part must not be empty
      for (String part in parts) {
        if (part.isEmpty) return false;
      }

      // The last part (TLD) must be at least 2 characters
      if (parts.last.length < 2) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: ((ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFE8B44C),
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
          content: Text(
            message,
            style: TextStyle(fontSize: 16),
          ),
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
              // Target Audience Section
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.group,
                      color: Color(0xFF003B7E),
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Target Audience:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF003B7E),
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFE8B44C).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedValue,
                        underline: SizedBox(),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF003B7E),
                        ),
                        style: TextStyle(
                          color: Color(0xFF003B7E),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        items: items.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedValue = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Title Field
              Text(
                "Resource Title",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF003B7E),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _titleController,
                maxLength: 75,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: "e.g., Competitive Events Guide",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.title, color: Color(0xFF003B7E)),
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
                  counter: Offstage(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Description Field
              Text(
                "Description",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF003B7E),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _informationController,
                maxLength: 200,
                maxLines: 3,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: "Brief description of the resource...",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.description, color: Color(0xFF003B7E)),
                  ),
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
                  counter: Offstage(),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),

              SizedBox(height: 20),

              // Link Field
              Text(
                "Resource Link",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF003B7E),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _linkController,
                maxLength: 500,
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },

                // In your TextField decoration for the link field:
                decoration: InputDecoration(
                  hintText: "https://example.com or example.com",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,

                  // ✅ PREFIX ICON - Changes color based on error
                  prefixIcon: Icon(
                    Icons.link,
                    color: _linkError != null ? Colors.red : Color(0xFF003B7E),
                  ),

                  // ✅ SUFFIX ICON - Shows check or error icon
                  suffixIcon: _linkController.text.isNotEmpty
                      ? Icon(
                          _linkError == null ? Icons.check_circle : Icons.error,
                          color: _linkError == null ? Colors.green : Colors.red,
                        )
                      : null,

                  // ✅ ERROR TEXT - Shows below field
                  errorText: _linkError,
                  errorStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),

                  // ✅ BORDER COLOR - Changes based on error
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

                  counter: Offstage(),
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
                            Icon(
                              Icons.save,
                              color: Color(0xFFE8B44C),
                              size: 22,
                            ),
                            SizedBox(width: 12),
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
