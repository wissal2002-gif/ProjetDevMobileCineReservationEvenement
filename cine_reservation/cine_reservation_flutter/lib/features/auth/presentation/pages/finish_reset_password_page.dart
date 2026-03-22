import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

class FinishResetPasswordPage extends ConsumerStatefulWidget {
  const FinishResetPasswordPage({super.key});

  @override
  ConsumerState<FinishResetPasswordPage> createState() => _FinishResetPasswordPageState();
}

class _FinishResetPasswordPageState extends ConsumerState<FinishResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: AppColors.error),
        );
      }
      if (next.isAuthenticated == true && previous?.isAuthenticated != true) {
        context.go(AppConstants.routeHome);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Nouveau mot de passe')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                const Text('Nouveau mot de passe',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.white)),
                const SizedBox(height: 8),
                const Text('Choisissez un nouveau mot de passe sécurisé.',
                    style: TextStyle(color: AppColors.textLight, height: 1.5)),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscure1,
                  style: const TextStyle(color: AppColors.white),
                  decoration: InputDecoration(
                    labelText: 'Nouveau mot de passe',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure1 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: AppColors.textLight),
                      onPressed: () => setState(() => _obscure1 = !_obscure1),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Requis';
                    if (v.length < 8) return 'Minimum 8 caractères';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmController,
                  obscureText: _obscure2,
                  style: const TextStyle(color: AppColors.white),
                  decoration: InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure2 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: AppColors.textLight),
                      onPressed: () => setState(() => _obscure2 = !_obscure2),
                    ),
                  ),
                  validator: (v) {
                    if (v != _passwordController.text) return 'Ne correspond pas';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: authState.isLoading ? null : () {
                    if (_formKey.currentState!.validate()) {
                      ref.read(authProvider.notifier).finishPasswordReset(
                        newPassword: _passwordController.text,
                      );
                    }
                  },
                  child: authState.isLoading
                      ? const SizedBox(height: 20, width: 20,
                      child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                      : const Text('Réinitialiser'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}