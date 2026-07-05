import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/app_theme.dart';

class OrderConfirmationPage extends StatelessWidget {
  final String orderId;
  const OrderConfirmationPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Large Animated checkmark icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.secondaryColor, width: 2),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 72,
                  color: AppTheme.secondaryColor,
                ),
              ),
              const SizedBox(height: 32),

              Text(
                '¡Pago Procesado!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tu pedido ha sido creado y pagado con éxito. Hemos enviado un correo con los detalles del envío.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 32),

              // Order ID Panel
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF334155), width: 1),
                ),
                child: Column(
                  children: [
                    const Text(
                      'CÓDIGO DE PEDIDO',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    SelectableText(
                      orderId,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Return button
              ElevatedButton(
                onPressed: () => context.go('/home'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 52),
                ),
                child: const Text('Volver al Inicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
