import 'package:flutter/material.dart';
import '../models/entry_model.dart';
import '../services/entry_service.dart';

class EntryFormScreen extends StatefulWidget {
  final Entry? entry;

  const EntryFormScreen({super.key, this.entry});

  @override
  _EntryFormScreenState createState() => _EntryFormScreenState();
}

class _EntryFormScreenState extends State<EntryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _entryService = EntryService();

  late TextEditingController _descriptionController;
  late TextEditingController _solutionController;
  late double _rating;
  bool _isNewEntry = true;

  @override
  void initState() {
    super.initState();
    _isNewEntry = widget.entry == null;

    _descriptionController = TextEditingController(text: widget.entry?.description ?? '');
    _solutionController = TextEditingController(text: widget.entry?.solution ?? '');
    _rating = widget.entry?.rating ?? 3.0;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _solutionController.dispose();
    super.dispose();
  }

  void _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      final entry = Entry(
        id: _isNewEntry ? null : widget.entry!.id,
        description: _descriptionController.text,
        rating: _rating,
        solution: _solutionController.text,
        createdAt: _isNewEntry ? DateTime.now() : widget.entry!.createdAt,
      );

      if (_isNewEntry) {
        await _entryService.addEntry(entry);
      } else {
        await _entryService.updateEntry(entry);
      }

      if (mounted) {
        Navigator.of(context).pop(true); // Pop and signal that data has changed
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNewEntry ? 'New Entry' : 'Edit Entry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveEntry,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Problem or Success',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text('Level of Suffering or Joy: ${_rating.toStringAsFixed(1)}', style: Theme.of(context).textTheme.titleMedium),
              Slider(
                value: _rating,
                min: 1.0,
                max: 5.0,
                divisions: 4,
                label: _rating.toStringAsFixed(1),
                onChanged: (double value) {
                  setState(() {
                    _rating = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _solutionController,
                decoration: const InputDecoration(
                  labelText: 'How to fix or Compliment',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a solution or compliment.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveEntry,
                child: const Text('Save Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
