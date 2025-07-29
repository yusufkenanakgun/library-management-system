import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/book_model.dart';
import '../../providers/book_provider.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String author = '';
  String description = '';
  String image = '';

  void _saveBook() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newBook = Book(
        id: "0", // ✅ int ise: id: 0
        title: title,
        author: author,
        description: description,
        isAvailable: true,
        image: image,
      );

      try {
        await Provider.of<BookProvider>(
          context,
          listen: false,
        ).addBook(newBook);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('📚 Book added successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to add book: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Book'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(label: 'Title', onSaved: (val) => title = val!),
              _buildTextField(label: 'Author', onSaved: (val) => author = val!),
              _buildTextField(
                label: 'Description',
                maxLines: 3,
                onSaved: (val) => description = val!,
              ),
              _buildTextField(
                label: 'Image URL (or assets/... path)',
                onSaved: (val) => image = val!,
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

  Widget _buildTextField({
    required String label,
    required FormFieldSetter<String> onSaved,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        maxLines: maxLines,
        validator:
            (value) =>
                value == null || value.trim().isEmpty
                    ? '$label is required'
                    : null,
        onSaved: onSaved,
      ),
    );
  }
}
