import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/entry_model.dart';

class EntryService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Entry>> getEntries() async {
    final response = await _supabase
        .from('entries')
        .select()
        .order('created_at', ascending: false);
    
    final entries = (response as List)
        .map((entry) => Entry.fromMap(entry))
        .toList();
    return entries;
  }

  Future<void> addEntry(Entry entry) async {
    await _supabase.from('entries').insert(entry.toJsonMap());
  }

  Future<void> updateEntry(Entry entry) async {
    await _supabase
        .from('entries')
        .update(entry.toJsonMap())
        .eq('id', entry.id!);
  }

  Future<void> deleteEntry(int id) async {
    await _supabase.from('entries').delete().eq('id', id);
  }
}
