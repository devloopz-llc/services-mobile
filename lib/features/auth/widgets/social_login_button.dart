import 'package:flutter/material.dart';

enum SocialProvider { apple, google }

/// Apple/Google sign-in buttons. Neither provider is wired to the backend
/// yet — Sanctum only issues tokens from email/password today — so these
/// currently just surface an informational toast on tap.
class SocialLoginButton extends StatelessWidget {
  const SocialLoginButton({super.key, required this.provider, this.onPressed});

  final SocialProvider provider;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isApple = provider == SocialProvider.apple;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: isApple
            ? Icon(Icons.apple, size: 20, color: scheme.onSurface)
            : Text(
                'G',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
              ),
        label: Text(isApple ? 'Continue with Apple' : 'Continue with Google'),
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
