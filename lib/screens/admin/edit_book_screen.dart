import 'package:flutter/material.dart';

class EditBookScreen extends StatefulWidget {
  final Map<String, String> book;

  const EditBookScreen({super.key, required this.book});

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book['title']);
    _authorController = TextEditingController(text: widget.book['author']);
    _imageController = TextEditingController(text: widget.book['image']);
  }

  void _saveChanges() {
    setState(() {
      widget.book['title'] = _titleController.text;
      widget.book['author'] = _authorController.text;
      widget.book['image'] = _imageController.text;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Book"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: "Author"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: "Image Path"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text(
                "Save Changes",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
