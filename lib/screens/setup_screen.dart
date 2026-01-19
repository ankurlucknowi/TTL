import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/ttl_text.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  DateTime? _selectedDob;
  bool _agreed = false;
  late final TextEditingController _lifespanController;

  @override
  void initState() {
    super.initState();
    _lifespanController = TextEditingController(text: '80');
  }

  @override
  void dispose() {
    _lifespanController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = DateTime(now.year - 25, now.month, now.day);
    final DateTime firstDate = DateTime(now.year - 120, 1, 1);
    final DateTime lastDate = now;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        _selectedDob = picked;
      });
    }
  }

  Future<void> _save() async {
    final int? lifespanYears = int.tryParse(_lifespanController.text.trim());
    if (_selectedDob == null || lifespanYears == null || !_agreed) {
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('dob', _selectedDob!.toIso8601String());
    await prefs.setInt('lifespan_years', lifespanYears);
    await prefs.setBool('disclaimer_acknowledged', true);
    await prefs.setBool('setup_complete', true);

    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color secondaryText = Theme.of(context).colorScheme.onSurfaceVariant;
    final bool isValid = _selectedDob != null &&
        int.tryParse(_lifespanController.text.trim()) != null &&
        _agreed;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TTLText(
                'Welcome to TTL',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TTLText(
                'A quiet space to reflect on time, gently.',
                style: textTheme.bodyLarge,
                color: secondaryText,
              ),
              const SizedBox(height: 32),
              TTLText(
                'Date of Birth',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _pickDate,
                child: Text(
                  _selectedDob == null
                      ? 'Choose date'
                      : '${_selectedDob!.year}-${_selectedDob!.month.toString().padLeft(2, '0')}-${_selectedDob!.day.toString().padLeft(2, '0')}',
                ),
              ),
              const SizedBox(height: 24),
              TTLText(
                'Preferred lifespan (years)',
                style: textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _lifespanController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agreed,
                    onChanged: (bool? value) {
                      setState(() {
                        _agreed = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TTLText(
                        'I understand this is a reflective tool, not a prediction.',
                        style: textTheme.bodySmall,
                        color: secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isValid ? _save : null,
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
