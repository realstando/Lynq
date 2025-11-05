import 'package:flutter/material.dart';
import 'package:coding_prog/Competive_Events/events.dart';
import 'package:coding_prog/Competive_Events/events_format.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
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

  Color _getCategoryColor(EventCategory category) {
    switch (category) {
      case EventCategory.objective:
        return const Color(0xFF6366F1);
      case EventCategory.presentation:
        return const Color(0xFF8B5CF6);
      case EventCategory.roleplay:
        return const Color(0xFFEC4899);
    }
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
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          "FBLA Competitive Events",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF4F46E5),
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Header with gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF4F46E5),
                  Color(0xFFF9FAFB),
                ],
                stops: [0.0, 0.3],
              ),
            ),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search events...",
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF6B7280),
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
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
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),

                // Category Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All Events'),
                        selected: _selectedCategory == null,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = null;
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFF4F46E5).withOpacity(0.2),
                        checkmarkColor: const Color(0xFF4F46E5),
                        labelStyle: TextStyle(
                          color: _selectedCategory == null
                              ? const Color(0xFF4F46E5)
                              : const Color(0xFF6B7280),
                          fontWeight: _selectedCategory == null
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ...EventCategory.values.map((category) {
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category.name.toUpperCase()),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = selected ? category : null;
                              });
                            },
                            backgroundColor: Colors.white,
                            selectedColor: _getCategoryColor(
                              category,
                            ).withOpacity(0.2),
                            checkmarkColor: _getCategoryColor(category),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? _getCategoryColor(category)
                                  : const Color(0xFF6B7280),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
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
                    color: Colors.grey.shade600,
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
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No events found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filters',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
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
