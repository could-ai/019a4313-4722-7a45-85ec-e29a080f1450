import 'package:flutter/material.dart';
import '../models/entry_model.dart';
import '../services/entry_service.dart';
import 'entry_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EntryService _entryService = EntryService();
  late Future<List<Entry>> _entriesFuture;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    setState(() {
      _entriesFuture = _entryService.getEntries();
    });
  }

  void _navigateAndRefresh(Widget screen) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => screen),
    );

    if (result == true) {
      _loadEntries();
    }
  }

  void _deleteEntry(int id) async {
    await _entryService.deleteEntry(id);
    _loadEntries();
    if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Entry deleted'), duration: Duration(seconds: 2),)
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Journal'),
      ),
      body: FutureBuilder<List<Entry>>(
        future: _entriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No entries yet. Add one!'));
          }

          final entries = snapshot.data!;
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Dismissible(
                key: ValueKey(entry.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _deleteEntry(entry.id!);
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(entry.description, maxLines: 2, overflow: TextOverflow.ellipsis,),
                    subtitle: Text(entry.solution, maxLines: 1, overflow: TextOverflow.ellipsis),
                    leading: CircleAvatar(
                      child: Text(entry.rating.toStringAsFixed(0)),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      _navigateAndRefresh(EntryFormScreen(entry: entry));
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateAndRefresh(const EntryFormScreen());
        },
        tooltip: 'Add Entry',
        child: const Icon(Icons.add),
      ),
    );
  }
}
