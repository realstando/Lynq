import 'package:coding_prog/Competive_Events/event_filterchip.dart';
import 'package:flutter/material.dart';
import 'package:coding_prog/Competive_Events/events.dart';
import 'package:coding_prog/Competive_Events/events_format.dart';
import 'package:coding_prog/NavigationBar/drawer_page.dart';
import 'package:coding_prog/NavigationBar/custom_appbar.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key, required this.onNavigate});
  final void Function(int) onNavigate;

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  EventCategory? _selectedCategory;

  final List<CompetitiveEvent> allEvents = [
    CompetitiveEvent(
      title: "Accounting",
      category: EventCategory.objective,
      description:
          "Demonstrate knowledge of accounting principles, procedures, and applications.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Advanced Accounting",
      category: EventCategory.objective,
      description:
          "Apply advanced accounting concepts including cost, managerial, and financial accounting.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Advertising",
      category: EventCategory.objective,
      description:
          "Show understanding of advertising principles, media, and campaign development.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Agribusiness",
      category: EventCategory.objective,
      description:
          "Explore business concepts in agriculture including marketing, finance, and operations.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Banking & Financial Systems",
      category: EventCategory.roleplay,
      description:
          "Analyze banking services, financial institutions, and regulatory systems through a role-play scenario.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Broadcast Journalism",
      category: EventCategory.presentation,
      description:
          "Create and present a news broadcast segment using journalistic and technical skills.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Business Communication",
      category: EventCategory.objective,
      description:
          "Demonstrate effective communication in business settings including writing and presentation.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Business Ethics",
      category: EventCategory.presentation,
      description:
          "Analyze ethical dilemmas in business and present solutions using ethical frameworks.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Business Law",
      category: EventCategory.objective,
      description:
          "Understand legal principles affecting business operations and transactions.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Business Management",
      category: EventCategory.roleplay,
      description:
          "Demonstrate management skills and decision-making in a simulated business environment.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Business Plan",
      category: EventCategory.presentation,
      description:
          "Develop and present a comprehensive business plan for a new venture.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Career Portfolio",
      category: EventCategory.presentation,
      description:
          "Create and present a professional portfolio showcasing career readiness.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Coding & Programming",
      category: EventCategory.presentation,
      description:
          "Develop a software solution to a business or community problem.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Computer Game & Simulation Programming",
      category: EventCategory.presentation,
      description:
          "Design and present an original computer game or simulation.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Computer Problem Solving",
      category: EventCategory.objective,
      description:
          "Solve technical problems using logic, algorithms, and computer knowledge.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Customer Service",
      category: EventCategory.roleplay,
      description:
          "Showcase customer service techniques and professionalism in a role-play setting.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Cybersecurity",
      category: EventCategory.objective,
      description:
          "Demonstrate understanding of cybersecurity threats, tools, and prevention strategies.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Data Analysis",
      category: EventCategory.presentation,
      description:
          "Analyze and present data to solve a business problem or support decision-making.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Data Science & AI",
      category: EventCategory.objective,
      description:
          "Explore concepts in artificial intelligence, machine learning, and data analysis.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Digital Animation",
      category: EventCategory.presentation,
      description:
          "Create and present an original digital animation for a business or community purpose.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Digital Video Production",
      category: EventCategory.presentation,
      description:
          "Produce and present a video addressing a business or community topic.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Economics",
      category: EventCategory.objective,
      description:
          "Understand micro and macroeconomic principles and their applications.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Entrepreneurship",
      category: EventCategory.roleplay,
      description:
          "Develop and present a business plan to address a real-world entrepreneurial challenge.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Event Planning",
      category: EventCategory.presentation,
      description:
          "Create and present a plan for organizing a business or community event.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Financial Planning",
      category: EventCategory.presentation,
      description:
          "Develop and present a financial plan for a client scenario.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Financial Statement Analysis",
      category: EventCategory.presentation,
      description:
          "Analyze financial statements and present findings and recommendations.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Future Business Educator",
      category: EventCategory.presentation,
      description:
          "Explore careers in business education and present a teaching plan.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Future Business Leader",
      category: EventCategory.presentation,
      description:
          "Demonstrate leadership potential through interviews and presentations.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Graphic Design",
      category: EventCategory.presentation,
      description:
          "Create and present original graphic design materials for a business or organization.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Healthcare Administration",
      category: EventCategory.objective,
      description:
          "Explore administrative functions and regulations in healthcare systems.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Hospitality & Event Management",
      category: EventCategory.roleplay,
      description:
          "Solve hospitality-related business problems through team-based role-play scenarios.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Human Resource Management",
      category: EventCategory.objective,
      description:
          "Understand HR functions including recruitment, training, and labor laws.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Impromptu Speaking",
      category: EventCategory.presentation,
      description:
          "Deliver a well-organized speech on a randomly assigned business topic.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Insurance & Risk Management",
      category: EventCategory.objective,
      description:
          "Analyze insurance principles, risk management strategies, and industry practices.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "International Business",
      category: EventCategory.roleplay,
      description:
          "Demonstrate knowledge of global business practices and cross-cultural communication.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Introduction to Business Communication",
      category: EventCategory.objective,
      description:
          "Learn foundational business communication skills including writing, speaking, and listening.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Introduction to Business Concepts",
      category: EventCategory.objective,
      description:
          "Explore basic business principles including management, marketing, and finance.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Introduction to Business Presentation",
      category: EventCategory.presentation,
      description:
          "Create and deliver a presentation on a basic business topic.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Introduction to Business Procedures",
      category: EventCategory.objective,
      description: "Understand basic business operations and procedures.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Introduction to FBLA",
      category: EventCategory.objective,
      description:
          "Learn about FBLA's mission, structure, and opportunities for involvement.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Introduction to Information Technology",
      category: EventCategory.objective,
      description:
          "Explore basic IT concepts including hardware, software, and networks.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Introduction to Marketing Concepts",
      category: EventCategory.objective,
      description: "Understand basic marketing principles and strategies.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Introduction to Parliamentary Procedure",
      category: EventCategory.objective,
      description:
          "Learn the basics of parliamentary law and meeting procedures.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Introduction to Programming",
      category: EventCategory.presentation,
      description: "Develop and present a basic programming project.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Introduction to Public Speaking",
      category: EventCategory.presentation,
      description: "Deliver a speech on a basic business topic.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Introduction to Retail & Merchandising",
      category: EventCategory.objective,
      description:
          "Explore basic retail operations and merchandising strategies.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Introduction to Social Media Strategy",
      category: EventCategory.presentation,
      description: "Create and present a basic social media campaign.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Introduction to Supply Chain Management",
      category: EventCategory.objective,
      description: "Understand basic supply chain concepts and logistics.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Job Interview",
      category: EventCategory.presentation,
      description:
          "Demonstrate job interview skills including resume writing and professional communication.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Journalism",
      category: EventCategory.objective,
      description:
          "Demonstrate knowledge of journalistic writing, ethics, and media law.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Management Information Systems",
      category: EventCategory.roleplay,
      description:
          "Analyze and solve business problems using information systems and technology.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Marketing",
      category: EventCategory.roleplay,
      description:
          "Develop marketing strategies and solve business challenges in a role-play format.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Mobile Application Development",
      category: EventCategory.presentation,
      description:
          "Design and present a mobile app to solve a business or community problem.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Network Design",
      category: EventCategory.roleplay,
      description:
          "Design and present a network solution to meet business needs in a role-play scenario.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Networking Infrastructures",
      category: EventCategory.objective,
      description:
          "Understand network architecture, protocols, and troubleshooting techniques.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Organizational Leadership",
      category: EventCategory.objective,
      description:
          "Explore leadership theories, team dynamics, and organizational behavior.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Parliamentary Procedure",
      category: EventCategory.roleplay,
      description:
          "Demonstrate knowledge of parliamentary law through a team performance event.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Personal Finance",
      category: EventCategory.objective,
      description:
          "Demonstrate financial literacy including budgeting, saving, and investing.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Project Management",
      category: EventCategory.objective,
      description:
          "Apply project planning, execution, and evaluation techniques.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Public Administration & Management",
      category: EventCategory.objective,
      description:
          "Understand government operations, public policy, and administrative functions.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Public Service Announcement",
      category: EventCategory.presentation,
      description:
          "Create and present a PSA addressing a business or community issue.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Public Speaking",
      category: EventCategory.presentation,
      description:
          "Deliver a speech on a business-related topic with clarity and confidence.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Real Estate",
      category: EventCategory.objective,
      description:
          "Explore real estate principles, property law, and market analysis.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Retail Management",
      category: EventCategory.objective,
      description:
          "Understand retail operations, merchandising, and customer service strategies.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Sales Presentation",
      category: EventCategory.presentation,
      description: "Deliver a persuasive sales pitch for a product or service.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Securities & Investments",
      category: EventCategory.objective,
      description:
          "Analyze investment vehicles, financial markets, and portfolio strategies.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Social Media Strategies",
      category: EventCategory.presentation,
      description: "Develop and present a strategic social media campaign.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Sports & Entertainment Management",
      category: EventCategory.roleplay,
      description:
          "Solve problems related to sports and entertainment business operations in a team setting.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Supply Chain Management",
      category: EventCategory.presentation,
      description:
          "Analyze and present solutions for supply chain and logistics challenges.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Technology Support & Services",
      category: EventCategory.roleplay,
      description:
          "Provide technical support and customer service in a simulated help desk environment.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Visual Design",
      category: EventCategory.presentation,
      description:
          "Create and present visual design materials for a business or organization.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Website Coding & Development",
      category: EventCategory.presentation,
      description:
          "Design and present a coded website to meet business or community needs.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
    CompetitiveEvent(
      title: "Website Design",
      category: EventCategory.presentation,
      description:
          "Create and present a website using design principles and user experience best practices.",
      link: "https://www.fbla.org/high-school/competitive-events/",
    ),
  ];

  Color _getThemeColor(int shade) {
    if (_selectedCategory == EventCategory.objective) {
      return Colors.blue[shade]!;
    } else if (_selectedCategory == EventCategory.roleplay) {
      return Colors.pink[shade]!;
    } else if (_selectedCategory == EventCategory.presentation) {
      return Colors.purple[shade]!;
    }
    // Default when no category selected
    return Colors.grey[shade]!;
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = allEvents.where((event) {
      final matchesSearch = event.title.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesCategory =
          _selectedCategory == null || event.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: _selectedCategory == null
          ? const Color(0xFFF5F5F5)
          : _selectedCategory == EventCategory.objective
          ? Colors.blue[50]
          : _selectedCategory == EventCategory.roleplay
          ? const Color(0xFFFFF0F5)
          : Colors.purple[50],
      key: _scaffoldKey,
      drawer: DrawerPage(
        icon: Icons.menu_book_rounded,
        name: 'Competitive Events',
        color: Color(0xFF5C0A7F),
        onNavigate: widget.onNavigate,
      ),
      appBar: CustomAppBar(
        name: 'Competitive Events',
        color: _getThemeColor(300),
        scaffoldKey: _scaffoldKey,
      ),
      body: Column(
        children: [
          // Header with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _getThemeColor(300),
                  _getThemeColor(200),
                ],
              ),
            ),
            child: Column(
              children: [
                // Title and subtitle
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search for Events',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Explore 73 FBLA events to showcase your skills',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _getThemeColor(300).withOpacity(0.2),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Search events...",
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: _getThemeColor(300),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  size: 20,
                                  color: _getThemeColor(300),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ),

                // Category Filter Chips with counts
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      CustomFilterChip(
                        label: 'All Events',
                        count: 73,
                        isSelected: _selectedCategory == null,
                        color: Colors.grey[600]!,
                        icon: Icons.apps,
                        onTap: () {
                          setState(() {
                            _selectedCategory = null;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      CustomFilterChip(
                        label: 'OBJECTIVE',
                        count: 31,
                        isSelected:
                            _selectedCategory == EventCategory.objective,
                        color: Colors.blue[400]!,
                        icon: Icons.quiz_outlined,
                        onTap: () {
                          setState(() {
                            _selectedCategory =
                                _selectedCategory == EventCategory.objective
                                ? null
                                : EventCategory.objective;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      CustomFilterChip(
                        label: 'ROLEPLAY',
                        count: 12,
                        isSelected: _selectedCategory == EventCategory.roleplay,
                        color: Colors.pink[400]!,
                        icon: Icons.groups_outlined,
                        onTap: () {
                          setState(() {
                            _selectedCategory =
                                _selectedCategory == EventCategory.roleplay
                                ? null
                                : EventCategory.roleplay;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      CustomFilterChip(
                        label: 'PRESENTATION',
                        count: 31,
                        isSelected:
                            _selectedCategory == EventCategory.presentation,
                        color: Colors.purple[400]!,
                        icon: Icons.present_to_all_outlined,
                        onTap: () {
                          setState(() {
                            _selectedCategory =
                                _selectedCategory == EventCategory.presentation
                                ? null
                                : EventCategory.presentation;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Results count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${filteredEvents.length} event${filteredEvents.length != 1 ? 's' : ''} found',
                  style: TextStyle(
                    color: _getThemeColor(400),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Events List
          Expanded(
            child: filteredEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: _getThemeColor(200),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No events found',
                          style: TextStyle(
                            fontSize: 18,
                            color: _getThemeColor(400),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: TextStyle(
                            fontSize: 14,
                            color: _getThemeColor(300),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      return EventsFormat(event: filteredEvents[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
