
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentSearchApp());
}

class StudentSearchApp extends StatelessWidget {
  const StudentSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Search',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const StudentSearchPage(),
    );
  }
}

class StudentSearchPage extends StatefulWidget {
  const StudentSearchPage({super.key});

  @override
  State<StudentSearchPage> createState() =>
      _StudentSearchPageState();
}

class _StudentSearchPageState extends State<StudentSearchPage> {
  final TextEditingController searchController =
      TextEditingController();

  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> searchResults = [];

  bool isLoading = true;
  String message = 'Loading student records...';

  // Dummy student records
  final List<Map<String, dynamic>> dummyStudents = [
    {
      'name': 'Aishmitha',
      'registrationNumber': '25CSE001',
      'department': 'CSE',
      'marks': 95,
    },
    {
      'name': 'Priya',
      'registrationNumber': '25CSE002',
      'department': 'CSE',
      'marks': 88,
    },
    {
      'name': 'Manasa',
      'registrationNumber': '25AIML003',
      'department': 'AIML',
      'marks': 92,
    },
    {
      'name': 'Dhanya',
      'registrationNumber': '25ECE004',
      'department': 'ECE',
      'marks': 85,
    },
    {
      'name': 'Harini',
      'registrationNumber': '25IT005',
      'department': 'IT',
      'marks': 90,
    },
    {
      'name': 'Kavya',
      'registrationNumber': '25AIML006',
      'department': 'AIML',
      'marks': 78,
    },
  ];

  @override
  void initState() {
    super.initState();
    loadStudentRecords();
  }

  // Load dummy records automatically
  Future<void> loadStudentRecords() async {
    setState(() {
      isLoading = true;
      message = 'Loading student records...';
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      students = List.from(dummyStudents);
      searchResults = [];
      isLoading = false;
      message = 'Enter a student name or registration number.';
    });
  }

  // Search by student name or registration number
  Future<void> searchStudents() async {
    final searchText =
        searchController.text.trim().toLowerCase();

    if (searchText.isEmpty) {
      setState(() {
        searchResults = [];
        message = 'Please enter a search value.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      searchResults = [];
      message = 'Searching student records...';
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final results = students.where((student) {
      final name = student['name'].toString().toLowerCase();
      final regNo =
          student['registrationNumber'].toString().toLowerCase();

      return name.contains(searchText) ||
          regNo.contains(searchText);
    }).toList();

    setState(() {
      searchResults = results;
      isLoading = false;

      message = results.isEmpty
          ? 'No matching student found.'
          : '${results.length} student record(s) found.';
    });
  }

  // Clear search
  void clearSearch() {
    searchController.clear();

    setState(() {
      searchResults = [];
      message = 'Enter a student name or registration number.';
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),

      appBar: AppBar(
        title: const Text(
          'Student Information Search',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.search,
                  size: 70,
                  color: Colors.indigo,
                ),

                const SizedBox(height: 12),

                const Text(
                  'Search Student Information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Find student details using name or registration number.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 25),

                // Search field
                TextField(
                  controller: searchController,
                  onSubmitted: (_) => searchStudents(),

                  decoration: InputDecoration(
                    labelText: 'Name or Registration Number',
                    hintText: 'Example: Aishmitha or 25CSE001',
                    prefixIcon: const Icon(Icons.person_search),
                    suffixIcon: IconButton(
                      onPressed: clearSearch,
                      icon: const Icon(Icons.clear),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

                // Search button
                ElevatedButton.icon(
                  onPressed: isLoading ? null : searchStudents,
                  icon: const Icon(Icons.search),
                  label: const Text(
                    'Search Student',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Loading indicator and search results
                if (isLoading)
                  Column(
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.indigo,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  )
                else ...[
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: searchResults.isEmpty
                          ? Colors.blueGrey
                          : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 15),

                  ...searchResults.map((student) {
                    return Card(
                      elevation: 3,
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 12),

                      child: Padding(
                        padding: const EdgeInsets.all(16),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.indigo,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Text(
                                    student['name'].toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              ],
                            ),

                            const Divider(height: 25),

                            _buildDetail(
                              'Registration Number',
                              student['registrationNumber'],
                            ),

                            _buildDetail(
                              'Department',
                              student['department'],
                            ),

                            _buildDetail(
                              'Marks',
                              student['marks'],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],

                const SizedBox(height: 20),

                // Total records
                Card(
                  color: Colors.indigo.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(15),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.people,
                          color: Colors.indigo,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Total student records: ${students.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                TextButton.icon(
                  onPressed:
                      isLoading ? null : loadStudentRecords,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reload Records'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Student details display
  Widget _buildDetail(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(value?.toString() ?? 'N/A'),
          ),
        ],
      ),
    );
  }
}
