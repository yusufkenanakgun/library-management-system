import 'package:flutter/material.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String author = '';
  String image = '';

  void _saveBook() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newBook = {'title': title, 'author': author, 'image': image};

      Navigator.pop(context, newBook); // Kitabı geri döndür
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Title is required'
                            : null,
                onSaved: (value) => title = value ?? '',
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Author'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Author is required'
                            : null,
                onSaved: (value) => author = value ?? '',
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Image path (assets/... or URL)',
                ),
                onSaved: (value) => image = value ?? '',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 32,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
