import 'package:flutter/material.dart';

void main() {
  runApp(const CosmicGuildApp());
}

class CosmicGuildApp extends StatelessWidget {
  const CosmicGuildApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cosmic Guild Signup',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C4CCF)),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        useMaterial3: true,
      ),
      home: const SignupPage(),
    );
  }
}

enum TipStatus { idle, loading, success, error }

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  static const String _tipCategory = 'password_help';
  static const Map<String, List<String>> _presetTips = {
    'password_help': [
      'Use a long, unique passphrase that you do not reuse on another account.',
      'A password manager can create and store a different password for every account.',
      'Length helps: combine several unrelated words into a memorable passphrase.',
    ],
  };

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  TipStatus _tipStatus = TipStatus.idle;
  String? _tip;
  int _nextTipIndex = 0;
  bool _useMissingTipData = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadPresetTip() async {
    setState(() {
      _tipStatus = TipStatus.loading;
      _tip = null;
    });

    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted) return;

    final tips = _useMissingTipData ? null : _presetTips[_tipCategory];
    if (tips == null || tips.isEmpty) {
      setState(() => _tipStatus = TipStatus.error);
      return;
    }

    setState(() {
      _tip = tips[_nextTipIndex % tips.length];
      _nextTipIndex++;
      _tipStatus = TipStatus.success;
      _useMissingTipData = false;
    });
  }

  void _showMissingDataCase() {
    _useMissingTipData = true;
    _loadPresetTip();
  }

  void _retryTip() {
    _useMissingTipData = false;
    _loadPresetTip();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Please enter your email';
    if (!email.contains('@')) return 'Please enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter a password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  ({String label, String guidance, Color color, double progress})
  get _passwordFeedback {
    final length = _passwordController.text.length;
    if (length == 0) {
      return (
        label: 'Not entered',
        guidance: 'Enter a password to see local guidance.',
        color: Colors.grey,
        progress: 0,
      );
    }
    if (length < 8) {
      return (
        label: 'Needs more length',
        guidance: 'Use at least 8 characters for this demo rule.',
        color: Colors.orange,
        progress: 0.5,
      );
    }
    return (
      label: 'Meets demo length rule',
      guidance: 'Consider a longer unique passphrase for real accounts.',
      color: Colors.green,
      progress: 1,
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo signup complete — your form passed validation!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final passwordFeedback = _passwordFeedback;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cosmic Guild'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.rocket_launch,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your explorer profile',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  key: const Key('nameField'),
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: _validateName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('emailField'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('passwordField'),
                  controller: _passwordController,
                  obscureText: true,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 10),
                Card(
                  key: const Key('passwordCoach'),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Local password coach: ${passwordFeedback.label}',
                          style: TextStyle(
                            color: passwordFeedback.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: passwordFeedback.progress,
                          color: passwordFeedback.color,
                        ),
                        const SizedBox(height: 8),
                        Text(passwordFeedback.guidance),
                        const SizedBox(height: 4),
                        const Text(
                          'Transparent rule: empty, under 8, or at least 8 characters. Guidance only—not a security guarantee.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  key: const Key('signupButton'),
                  onPressed: _submit,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Sign Up'),
                ),
                const SizedBox(height: 24),
                const Divider(),
                Text(
                  'Local signup coach',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Fixed category: password_help. This feature never reads your name, email, or password.',
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  key: const Key('tipButton'),
                  onPressed: _tipStatus == TipStatus.loading
                      ? null
                      : _loadPresetTip,
                  icon: const Icon(Icons.lightbulb_outline),
                  label: const Text('Get a signup tip'),
                ),
                const SizedBox(height: 8),
                if (_tipStatus == TipStatus.loading)
                  const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 8),
                        Text('Loading a preset tip…'),
                      ],
                    ),
                  ),
                if (_tipStatus == TipStatus.success && _tip != null)
                  Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Preset demo tip—not live AI.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(_tip!),
                        ],
                      ),
                    ),
                  ),
                if (_tipStatus == TipStatus.error)
                  Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Preset tip data is empty or missing.',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text('No form data was sent or used.'),
                          TextButton.icon(
                            key: const Key('retryButton'),
                            onPressed: _retryTip,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry with local data'),
                          ),
                        ],
                      ),
                    ),
                  ),
                TextButton(
                  key: const Key('missingDataButton'),
                  onPressed: _tipStatus == TipStatus.loading
                      ? null
                      : _showMissingDataCase,
                  child: const Text('Test missing local tip data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
