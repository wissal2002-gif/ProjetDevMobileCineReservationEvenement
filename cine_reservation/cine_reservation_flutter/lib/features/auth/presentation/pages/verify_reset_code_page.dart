import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import 'finish_reset_password_page.dart';

class VerifyResetCodePage extends ConsumerStatefulWidget {
  final String email;
  const VerifyResetCodePage({super.key, required this.email});

  @override
  ConsumerState<VerifyResetCodePage> createState() => _VerifyResetCodePageState();
}

class _VerifyResetCodePageState extends ConsumerState<VerifyResetCodePage> {
  final List<TextEditingController> _controllers =
  List.generate(8, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(8, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _verify() {
    ref.read(authProvider.notifier).verifyResetCode(code: _code);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
        );
        for (var c in _controllers) c.clear();
        _focusNodes[0].requestFocus();
      }
      if (next.resetNeedsPassword == true && previous?.resetNeedsPassword != true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const FinishResetPasswordPage(),
              ),
            );
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Code de vérification'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accent, width: 2),
                  ),
                  child: const Icon(Icons.lock_reset_outlined, color: AppColors.accent, size: 40),
                ),
              ),
              const SizedBox(height: 32),
              const Text('Code de vérification',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.white)),
              const SizedBox(height: 12),
              Text('Code envoyé à\n${widget.email}',
                  style: const TextStyle(color: AppColors.textLight, fontSize: 14, height: 1.5)),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(8, (index) {
                  return SizedBox(
                    width: 36, height: 52,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: AppColors.inputBg,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.accent, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length > 1) {
                          _controllers[index].text = value[value.length - 1];
                          _controllers[index].selection =
                          const TextSelection.collapsed(offset: 1);
                        }
                        if (value.isNotEmpty && index < 7) _focusNodes[index + 1].requestFocus();
                        if (value.isEmpty && index > 0) _focusNodes[index - 1].requestFocus();
                        if (_code.length == 8) _verify();
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: authState.isLoading || _code.length < 8 ? null : _verify,
                child: authState.isLoading
                    ? const SizedBox(height: 20, width: 20,
                    child: CircularProgressIndicator(color: AppColors.white, strokeWidth: 2))
                    : const Text('Vérifier'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}