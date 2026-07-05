import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  // Shipping Address controllers
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _countryController = TextEditingController(text: 'PE');
  final _referencesController = TextEditingController();

  // Guest details controllers (visible only if user is logged out)
  final _guestEmailController = TextEditingController();
  final _guestNameController = TextEditingController();
  final _guestPhoneController = TextEditingController();

  final _notesController = TextEditingController();

  bool _isProcessing = false;

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    _referencesController.dispose();
    _guestEmailController.dispose();
    _guestNameController.dispose();
    _guestPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatCurrency(int cents) {
    return 'S/. ${(cents / 100).toStringAsFixed(2)}';
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) return;

    final cartState = ref.read(cartProvider);
    final cart = cartState.value;
    if (cart == null || cart.items.isEmpty) return;

    setState(() => _isProcessing = true);

    try {
      final authState = ref.read(authProvider);
      final isGuest = authState.user == null;

      final shippingAddress = {
        'street': _streetController.text.trim(),
        'city': _cityController.text.trim(),
        'state': _stateController.text.trim(),
        'zip': _zipController.text.trim(),
        'country': _countryController.text.trim(),
        'references': _referencesController.text.trim(),
      };

      // 1. Create checkout and get payment credentials
      final (checkoutData, failure) = await ref
          .read(cartRepositoryProvider)
          .checkout(
            cartId: cart.id,
            shippingAddress: shippingAddress,
            guestEmail: isGuest ? _guestEmailController.text.trim() : null,
            guestName: isGuest ? _guestNameController.text.trim() : null,
            guestPhone: isGuest ? _guestPhoneController.text.trim() : null,
            notes: _notesController.text.trim(),
          );

      if (failure != null || checkoutData == null) {
        throw Exception(failure?.message ?? 'Error al iniciar checkout');
      }

      final clientSecret = checkoutData['clientSecret'] as String;
      final orderMap = checkoutData['order'] as Map<String, dynamic>;
      final orderId = orderMap['id'] as String;
      final paymentIntentId = orderMap['stripePaymentIntentId'] as String;

      // 2. Initialize the Stripe Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'SmartPyME SAC',
          style: ThemeMode.dark,
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: AppTheme.primaryColor,
              background: AppTheme.backgroundColor,
              componentBackground: AppTheme.surfaceColor,
              placeholderText: AppTheme.textSecondaryColor,
            ),
          ),
        ),
      );

      // 3. Display the Stripe checkout form sheet
      await Stripe.instance.presentPaymentSheet();

      // 4. Confirm payment outcome on backend
      final (confirmResult, confirmFailure) = await ref
          .read(cartRepositoryProvider)
          .confirmPayment(paymentIntentId);

      if (confirmFailure != null || confirmResult == null) {
        throw Exception(
          confirmFailure?.message ??
              'El pago fue aprobado por Stripe, pero falló la confirmación en el servidor',
        );
      }

      // 5. Success: Empty cart and route to confirmation page
      await ref.read(cartProvider.notifier).clearCart();

      if (mounted) {
        context.go('/cart/order-confirmation/$orderId');
      }
    } on StripeException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Pago cancelado: ${e.error.localizedMessage ?? 'El usuario canceló la transacción'}',
            ),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception:', '')),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final authState = ref.watch(authProvider);
    final isGuest = authState.user == null;

    final cart = cartState.value;
    final total = cart?.subtotal ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Datos de Envío')),
      body: cart == null
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Guest details section
                          if (isGuest) ...[
                            Text(
                              'Datos de Contacto (Invitado)',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _guestNameController,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Nombre Completo',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'El nombre es obligatorio'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _guestEmailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Correo Electrónico',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'El correo es obligatorio';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return 'Ingresa un correo válido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _guestPhoneController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                labelText: 'Teléfono',
                                prefixIcon: Icon(Icons.phone_outlined),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'El teléfono es obligatorio'
                                  : null,
                            ),
                            const SizedBox(height: 32),
                          ],

                          // Shipping Address Section
                          Text(
                            'Dirección de Envío',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),

                          // Street Address
                          TextFormField(
                            controller: _streetController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Dirección (Calle, Av., Número)',
                              prefixIcon: Icon(Icons.location_on_outlined),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'La dirección es obligatoria'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // City and State in Row
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _cityController,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    labelText: 'Ciudad',
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'Campo obligatorio'
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _stateController,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    labelText: 'Departamento',
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'Campo obligatorio'
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Zip and Country Code in Row
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _zipController,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    labelText: 'Código Postal',
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'Campo obligatorio'
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _countryController,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    labelText: 'País (Código)',
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'Campo obligatorio'
                                      : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // References
                          TextFormField(
                            controller: _referencesController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText:
                                  'Referencias (Piso, Color de puerta, etc.)',
                              prefixIcon: Icon(Icons.info_outline),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Additional notes
                          TextFormField(
                            controller: _notesController,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: 'Notas para la entrega',
                              prefixIcon: Icon(Icons.notes),
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom totals and pay button scaffold
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    decoration: const BoxDecoration(
                      color: AppTheme.surfaceColor,
                      border: Border(
                        top: BorderSide(color: Color(0xFF334155), width: 1),
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total a pagar:',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.textSecondaryColor,
                                ),
                              ),
                              Text(
                                _formatCurrency(total),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.secondaryColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _isProcessing ? null : _processPayment,
                            child: _isProcessing
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.payment, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text('Proceder al Pago'),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
