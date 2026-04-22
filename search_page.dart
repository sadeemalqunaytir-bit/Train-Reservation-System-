import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  String selectedFilter = "All";

  List<Map<String, String>> data = [
    {"type": "Train", "title": "Riyadh Train"},
    {"type": "Ticket", "title": "VIP Ticket"},
    {"type": "Schedule", "title": "Morning Schedule"},
    {"type": "Train", "title": "Metro Line 1"},
  ];

  List filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = data;
  }

  void performSearch() {
    String input = searchController.text.trim();

    bool hasText = input.isNotEmpty;

    List result = data.where((item) {
      bool matchesText = hasText
          ? item["title"]!.toLowerCase().contains(input.toLowerCase())
          : true;

      bool matchesFilter =
          selectedFilter == "All" ? true : item["type"] == selectedFilter;

      return matchesText && matchesFilter;
    }).toList();

    setState(() {
      filteredData = result;
    });

    if (result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No results found")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

             
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Search",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              TextField(
                controller: searchController,
                onChanged: (_) => performSearch(),
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  filterButton("Train", Icons.train),
                  filterButton("Ticket", Icons.confirmation_number),
                  filterButton("Schedule", Icons.calendar_today),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Result",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: filteredData.isEmpty
                    ? const Center(child: Text("No results"))
                    : ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(filteredData[index]["title"]!),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget filterButton(String title, IconData icon) {
    bool isSelected = selectedFilter == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = title;
        });
        performSearch();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isSelected ? Colors.deepPurple : Colors.deepPurple[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 5),
          Text(title),
        ],
      ),
    );
  }
}
