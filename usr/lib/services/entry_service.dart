import '../models/entry_model.dart';

class EntryService {
  // Singleton pattern
  static final EntryService _instance = EntryService._internal();
  factory EntryService() => _instance;
  EntryService._internal() {
    // Add some initial mock data
    _entries = [
      Entry(
        id: '1',
        description: 'Feeling great about finishing a project!',
        rating: 5.0,
        solution: 'Celebrate with a nice dinner.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Entry(
        id: '2',
        description: 'Struggling with a bug in the code.',
        rating: 2.0,
        solution: 'Take a break and come back with fresh eyes.',
        createdAt: DateTime.now(),
      ),
    ];
  }

  late List<Entry> _entries;

  // TODO: Replace this with a real database implementation (e.g., Supabase or SQLite).
  Future<List<Entry>> getEntries() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
    _entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return _entries;
  }

  Future<void> addEntry(Entry entry) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _entries.add(entry);
  }

  Future<void> updateEntry(Entry entry) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
    }
  }

  Future<void> deleteEntry(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _entries.removeWhere((entry) => entry.id == id);
  }
}
