import 'package:flutter/material.dart';
import 'package:hackatonparvlodar/firstpage/services/suggest_service.dart';
import 'package:hackatonparvlodar/roadmap/presentation/roadmap.dart';
import 'package:hackatonparvlodar/services/auth.dart'; // Ensure this provides necessary imports

class Suggestion extends StatefulWidget {
  const Suggestion({super.key});

  @override
  State<Suggestion> createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  late Future<List<EngineeringSpecialty>> futureSpecialties;

  @override
  void initState() {
    super.initState();
    futureSpecialties = ApiService().fetchSpecialties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Suggestions")),
      body: FutureBuilder<List<EngineeringSpecialty>>(
        future: futureSpecialties,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No specialties found.'));
          }
          final specialties =
              snapshot.data!.where((s) => s.roadmap.isNotEmpty).toList();
          return ListView.builder(
            itemCount: specialties.length,
            itemBuilder: (context, index) {
              final spec = specialties[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RoadMap(profession: spec),
                      ),
                    );
                  },
                  minTileHeight: 100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Colors.blue[400],
                  textColor: Colors.white,
                  title: Text(spec.name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
