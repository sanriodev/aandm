import 'dart:async';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    this.onLogin,
  });

  static const routeName = '/login';

  /// Optional callback to handle login. If null, a TODO is left for integration.
  final void Function(String username, String password)? onLogin;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscure = true;
  bool _submitting = false;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);

    try {
      if (widget.onLogin != null) {
        widget.onLogin!(
          _usernameCtrl.text.trim(),
          _passwordCtrl.text,
        );
      } else {
        // TODO: Integrate with your auth flow.
        await Future<void>.delayed(const Duration(milliseconds: 600));
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged in')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Welcome back',
                        style: theme.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _usernameCtrl,
                        focusNode: _usernameFocus,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [
                          AutofillHints.username,
                          AutofillHints.email
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Username or email',
                          hintText: 'you@example.com',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter your username or email'
                            : null,
                        onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordCtrl,
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.password],
                        obscureText: _obscure,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            tooltip:
                                _obscure ? 'Show password' : 'Hide password',
                            icon: Icon(_obscure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Please enter your password'
                            : null,
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _submitting ? null : _submit,
                          icon: _submitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.login),
                          label: const Text('Sign in'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
