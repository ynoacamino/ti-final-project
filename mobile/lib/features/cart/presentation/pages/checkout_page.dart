import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final _formKeyAddress = GlobalKey<FormState>();
  final _formKeyPayment = GlobalKey<FormState>();
  final _secureStorage = const FlutterSecureStorage();

  int _currentStep = 1; // 1 = Dirección, 2 = Resumen, 3 = Pago
  bool _isProcessing = false;
  String _paymentMethod = 'card'; // 'card' o 'manual'

  // Shipping Address controllers
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController(); // Mapped to state
  final _zipController = TextEditingController();
  final _countryController = TextEditingController(text: 'PE');
  final _referencesController = TextEditingController();
  final _notesController = TextEditingController();

  // Card Payment controllers
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _cardExpiryController = TextEditingController();
  final _cardCvvController = TextEditingController();

  // Guest details controllers (visible only if user is logged out)
  final _guestEmailController = TextEditingController();
  final _guestNameController = TextEditingController();
  final _guestPhoneController = TextEditingController();

  static const List<Map<String, String>> _countries = [
    {'code': 'PE', 'name': 'Perú', 'flag': '🇵🇪'},
    {'code': 'US', 'name': 'Estados Unidos', 'flag': '🇺🇸'},
    {'code': 'MX', 'name': 'México', 'flag': '🇲🇽'},
    {'code': 'CO', 'name': 'Colombia', 'flag': '🇨🇴'},
    {'code': 'CL', 'name': 'Chile', 'flag': '🇨🇱'},
    {'code': 'AR', 'name': 'Argentina', 'flag': '🇦🇷'},
    {'code': 'BR', 'name': 'Brasil', 'flag': '🇧🇷'},
    {'code': 'ES', 'name': 'España', 'flag': '🇪🇸'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedShippingDetails();
    _cardNumberController.addListener(() => setState(() {}));
    _cardHolderController.addListener(() => setState(() {}));
    _cardExpiryController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    _referencesController.dispose();
    _notesController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    _guestEmailController.dispose();
    _guestNameController.dispose();
    _guestPhoneController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedShippingDetails() async {
    try {
      final street = await _secureStorage.read(key: 'shipping_street');
      final city = await _secureStorage.read(key: 'shipping_city');
      final district = await _secureStorage.read(key: 'shipping_district');
      final zip = await _secureStorage.read(key: 'shipping_zip');
      final country = await _secureStorage.read(key: 'shipping_country');
      final references = await _secureStorage.read(key: 'shipping_references');

      if (street != null) _streetController.text = street;
      if (city != null) _cityController.text = city;
      if (district != null) _districtController.text = district;
      if (zip != null) _zipController.text = zip;
      if (country != null) _countryController.text = country;
      if (references != null) _referencesController.text = references;
    } catch (_) {}
  }

  Future<void> _saveShippingDetails() async {
    try {
      await _secureStorage.write(key: 'shipping_street', value: _streetController.text.trim());
      await _secureStorage.write(key: 'shipping_city', value: _cityController.text.trim());
      await _secureStorage.write(key: 'shipping_district', value: _districtController.text.trim());
      await _secureStorage.write(key: 'shipping_zip', value: _zipController.text.trim());
      await _secureStorage.write(key: 'shipping_country', value: _countryController.text.trim());
      await _secureStorage.write(key: 'shipping_references', value: _referencesController.text.trim());
    } catch (_) {}
  }

  String _formatCurrency(int cents) {
    return 'S/. ${(cents / 100).toStringAsFixed(2)}';
  }

  bool _validateExpiryDate(String value) {
    if (value.length != 5) return false;
    final parts = value.split('/');
    if (parts.length != 2) return false;
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    final now = DateTime.now();
    final currentYearTwoDigits = now.year % 100;
    final currentMonth = now.month;

    if (year < currentYearTwoDigits) return false;
    if (year == currentYearTwoDigits && month < currentMonth) return false;
    return true;
  }

  Future<void> _submitOrder() async {
    if (_paymentMethod == 'card') {
      if (!_formKeyPayment.currentState!.validate()) return;
    }

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
        'state': _districtController.text.trim(),
        'zip': _zipController.text.trim(),
        'country': _countryController.text.trim(),
        'references': _referencesController.text.trim(),
      };

      // 1. Create Checkout / Order in Backend
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

      final orderMap = checkoutData['order'] as Map<String, dynamic>;
      final orderId = orderMap['id'] as String;
      final paymentIntentId = orderMap['stripePaymentIntentId'] as String;

      // 2. Process payment based on selected method
      if (_paymentMethod == 'card') {
        // Confirm payment in backend directly (Stripe simulated)
        final (confirmResult, confirmFailure) = await ref
            .read(cartRepositoryProvider)
            .confirmPayment(paymentIntentId);

        if (confirmFailure != null || confirmResult == null) {
          throw Exception(confirmFailure?.message ?? 'La confirmación del pago falló.');
        }
      } else {
        // Manual/Yape payment requires no immediate backend payment confirmation (it's marked paid by Admin)
      }

      // 3. Clear cart
      await ref.read(cartProvider.notifier).clearCart();

      // 4. Redirect to order confirmation page
      if (mounted) {
        context.go('/cart/order-confirmation/$orderId');
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
    final total = (cart?.subtotal ?? 0) + 1500; // Standard shipping is 1500 cents (S/. 15.00)

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 28),
          onPressed: () {
            if (_currentStep > 1) {
              setState(() => _currentStep--);
            } else {
              context.pop();
            }
          },
        ),
        title: Column(
          children: [
            const Text(
              'Pagar',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1C1B1F)),
            ),
            Text(
              'Paso $_currentStep de 3',
              style: const TextStyle(fontSize: 12, color: Color(0xFF79747E)),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: cart == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Step Progress Tracker
                _buildStepIndicator(),
                const Divider(height: 1, color: Color(0xFFCAC4D0)),

                // Step content
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      child: _buildCurrentStepView(isGuest, total, cart),
                    ),
                  ),
                ),

                // Bottom Panel
                _buildBottomPanel(total, cart),
              ],
            ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepNode(1, 'Dirección', _currentStep >= 1, _currentStep == 1),
          _buildStepDivider(_currentStep >= 2),
          _buildStepNode(2, 'Resumen', _currentStep >= 2, _currentStep == 2),
          _buildStepDivider(_currentStep >= 3),
          _buildStepNode(3, 'Pago', _currentStep >= 3, _currentStep == 3),
        ],
      ),
    );
  }

  Widget _buildStepNode(int stepNum, String title, bool isDoneOrActive, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF6750A4)
                : (isDoneOrActive ? const Color(0xFFEADDFF) : Colors.transparent),
            border: Border.all(
              color: isActive || isDoneOrActive ? const Color(0xFF6750A4) : const Color(0xFFCAC4D0),
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: _currentStep > stepNum
              ? const Icon(Icons.check, size: 16, color: Color(0xFF6750A4))
              : Text(
                  stepNum.toString(),
                  style: TextStyle(
                    color: isActive
                        ? Colors.white
                        : (isDoneOrActive ? const Color(0xFF6750A4) : const Color(0xFF49454F)),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? const Color(0xFF1C1B1F) : const Color(0xFF79747E),
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
        color: isActive ? const Color(0xFF6750A4) : const Color(0xFFCAC4D0),
      ),
    );
  }

  Widget _buildCurrentStepView(bool isGuest, int total, dynamic cart) {
    switch (_currentStep) {
      case 1:
        return _buildAddressStep(isGuest);
      case 2:
        return _buildSummaryStep(cart);
      case 3:
        return _buildPaymentStep(total);
      default:
        return Container();
    }
  }

  Widget _buildAddressStep(bool isGuest) {
    return Form(
      key: _formKeyAddress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEADDFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.location_on_outlined, color: Color(0xFF6750A4)),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dirección de Entrega',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1C1B1F)),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '¿Dónde enviamos tu pedido?',
                    style: TextStyle(fontSize: 12, color: Color(0xFF79747E)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Guest details
          if (isGuest) ...[
            _buildLabel('NOMBRE COMPLETO'),
            TextFormField(
              controller: _guestNameController,
              decoration: _buildInputDecoration('Ej. Carlos Ríos Mendoza', Icons.person_outline),
              validator: (v) => v == null || v.isEmpty ? 'El nombre es obligatorio' : null,
            ),
            const SizedBox(height: 20),
            _buildLabel('CORREO ELECTRÓNICO'),
            TextFormField(
              controller: _guestEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _buildInputDecoration('ejemplo@correo.com', Icons.email_outlined),
              validator: (v) {
                if (v == null || v.isEmpty) return 'El correo es obligatorio';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                  return 'Ingresa un correo válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildLabel('TELÉFONO'),
            TextFormField(
              controller: _guestPhoneController,
              keyboardType: TextInputType.phone,
              decoration: _buildInputDecoration('999999999', Icons.phone_outlined),
              validator: (v) => v == null || v.isEmpty ? 'El teléfono es obligatorio' : null,
            ),
            const SizedBox(height: 28),
          ],

          _buildLabel('DIRECCIÓN'),
          TextFormField(
            controller: _streetController,
            decoration: _buildInputDecoration('Av. Larco 1301, Apt. 4B', Icons.home_outlined),
            validator: (v) => v == null || v.isEmpty ? 'La dirección es obligatoria' : null,
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLabel('CIUDAD'),
                    TextFormField(
                      controller: _cityController,
                      decoration: _buildInputDecoration('Lima', null),
                      validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLabel('DISTRITO'),
                    TextFormField(
                      controller: _districtController,
                      decoration: _buildInputDecoration('Miraflores', null),
                      validator: (v) => v == null || v.isEmpty ? 'Obligatorio' : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLabel('CÓDIGO POSTAL'),
                    TextFormField(
                      controller: _zipController,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration('15074', null),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Obligatorio';
                        if (v.length != 5 || !RegExp(r'^\d{5}$').hasMatch(v)) {
                          return 'Código de 5 dígitos';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLabel('PAÍS'),
                    Autocomplete<Map<String, String>>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return _countries;
                        }
                        return _countries.where((country) {
                          return country['name']!.toLowerCase().contains(textEditingValue.text.toLowerCase()) ||
                              country['code']!.toLowerCase().contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      displayStringForOption: (option) => option['name']!,
                      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                        if (controller.text.isEmpty && _countryController.text.isNotEmpty) {
                          final match = _countries.firstWhere((c) => c['code'] == _countryController.text, orElse: () => _countries.first);
                          controller.text = match['name']!;
                        }
                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            hintText: 'Buscar país...',
                            prefixIcon: controller.text.isNotEmpty
                                ? Center(
                                    widthFactor: 1.0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 12.0, right: 8),
                                      child: Text(
                                        _countries.firstWhere((c) => c['name'] == controller.text, orElse: () => {'flag': '🏳️'})['flag']!,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.public),
                            filled: true,
                            fillColor: const Color(0xFFF4EFF4),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Obligatorio';
                            final exists = _countries.any((c) => c['name']!.toLowerCase() == val.trim().toLowerCase());
                            if (!exists) return 'País inválido';
                            return null;
                          },
                          onChanged: (val) {
                            final match = _countries.firstWhere((c) => c['name']!.toLowerCase() == val.trim().toLowerCase(), orElse: () => {});
                            if (match.isNotEmpty) {
                              _countryController.text = match['code']!;
                            }
                          },
                        );
                      },
                      onSelected: (option) {
                        _countryController.text = option['code']!;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _buildLabel('REFERENCIAS'),
          TextFormField(
            controller: _referencesController,
            decoration: _buildInputDecoration('Piso 4, Puerta de color negro', Icons.info_outline),
          ),
          const SizedBox(height: 20),

          _buildLabel('NOTAS ADICIONALES'),
          TextFormField(
            controller: _notesController,
            decoration: _buildInputDecoration('Dejar en portería...', Icons.notes),
            maxLines: 2,
          ),
          const SizedBox(height: 24),

          // Security note card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4EFF4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: Color(0xFF49454F), size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tu dirección se usa únicamente para el envío y se mantiene protegida.',
                    style: TextStyle(color: Color(0xFF49454F), fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStep(dynamic cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Artículos en tu pedido',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1C1B1F)),
        ),
        const SizedBox(height: 16),

        // Items list card
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cart.items.length,
          separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFCAC4D0)),
          itemBuilder: (context, index) {
            final item = cart.items[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1C1B1F)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.size} • ${item.color} • x${item.quantity}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF79747E)),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _formatCurrency(item.unitPriceSnapshot * item.quantity),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1C1B1F)),
                  ),
                ],
              ),
            );
          },
        ),
        const Divider(height: 24, color: Color(0xFFCAC4D0)),

        // Bill detailed breakdown
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Subtotal', style: TextStyle(color: Color(0xFF79747E), fontSize: 14)),
            Text(_formatCurrency(cart.subtotal), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Envío', style: TextStyle(color: Color(0xFF79747E), fontSize: 14)),
            Text(_formatCurrency(1500), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('IGV (18%)', style: TextStyle(color: Color(0xFF79747E), fontSize: 14)),
            Text(_formatCurrency((cart.subtotal * 0.18).round()), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
        const Divider(height: 24, color: Color(0xFFCAC4D0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF6750A4))),
            Text(_formatCurrency(cart.subtotal + 1500), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF6750A4))),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentStep(int total) {
    return Form(
      key: _formKeyPayment,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEADDFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.payment_outlined, color: Color(0xFF6750A4)),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Datos de Pago',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1C1B1F)),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Información cifrada con TLS 256-bit',
                    style: TextStyle(fontSize: 11, color: Color(0xFF79747E)),
                  ),
                ],
              ),
              const Spacer(),
              const Row(
                children: [
                  Icon(Icons.lock_outline, size: 14, color: Color(0xFF6750A4)),
                  SizedBox(width: 4),
                  Text('Seguro', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6750A4))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Payment Toggle: Card or Yape
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF4EFF4),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _paymentMethod = 'card'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _paymentMethod == 'card' ? const Color(0xFF6750A4) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Tarjeta',
                        style: TextStyle(
                          color: _paymentMethod == 'card' ? Colors.white : const Color(0xFF49454F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _paymentMethod = 'manual'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _paymentMethod == 'manual' ? const Color(0xFF6750A4) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Yape / Pago Manual',
                        style: TextStyle(
                          color: _paymentMethod == 'manual' ? Colors.white : const Color(0xFF49454F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (_paymentMethod == 'card') ...[
            // Purple Card Mockup Preview
            Container(
              height: 176,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6750A4), Color(0xFF3D2C8D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6750A4).withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'NÚMERO DE TARJETA',
                        style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                      ),
                      Stack(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                          ),
                          Positioned(
                            left: 12,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    _cardNumberController.text.isEmpty ? '•••• •••• •••• ••••' : _cardNumberController.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('NOMBRE EN LA TARJETA', style: TextStyle(color: Colors.white70, fontSize: 8, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                            _cardHolderController.text.isEmpty ? 'CARLOS RIOS MENDOZA' : _cardHolderController.text.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('VENCIMIENTO', style: TextStyle(color: Colors.white70, fontSize: 8, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(
                            _cardExpiryController.text.isEmpty ? 'MM/AA' : _cardExpiryController.text,
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            _buildLabel('NÚMERO DE TARJETA'),
            TextFormField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
                CardNumberFormatter(),
              ],
              decoration: _buildInputDecoration('1234 5678 9012 3456', Icons.credit_card),
              validator: (v) {
                if (v == null || v.isEmpty) return 'El número es obligatorio';
                final clean = v.replaceAll(' ', '');
                if (clean.length < 16) return 'Número incompleto (debe tener 16 dígitos)';
                return null;
              },
            ),
            const SizedBox(height: 20),

            _buildLabel('NOMBRE EN LA TARJETA'),
            TextFormField(
              controller: _cardHolderController,
              decoration: _buildInputDecoration('CARLOS RIOS MENDOZA', Icons.person_outline),
              validator: (v) => v == null || v.isEmpty ? 'El titular es obligatorio' : null,
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildLabel('VENCIMIENTO'),
                      TextFormField(
                        controller: _cardExpiryController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                          ExpiryDateFormatter(),
                        ],
                        decoration: _buildInputDecoration('MM/AA', null),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Obligatorio';
                          if (!_validateExpiryDate(v)) return 'Inválido';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildLabel('CVV / CVC'),
                      TextFormField(
                        controller: _cardCvvController,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        decoration: _buildInputDecoration('•••', null),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Obligatorio';
                          if (v.length < 3) return 'Inválido';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ] else ...[
            // Manual Payment / Yape instructions card natively (No Overflows!)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF6750A4).withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF6750A4).withOpacity(0.15)),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/qr.png',
                      height: 160,
                      width: 160,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.qr_code_scanner, color: Color(0xFF6750A4), size: 40);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'YAPE / PLIN',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6750A4), fontSize: 13, letterSpacing: 1),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '925550310',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 32, color: Color(0xFF1C1B1F), letterSpacing: 2),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Titular: SmartPyME S.A.C.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF49454F), fontWeight: FontWeight.bold),
                  ),
                  const Divider(height: 24, color: Color(0xFFCAC4D0)),
                  const Text(
                    'Realiza la transferencia al número de arriba. Una vez realizada la compra, el administrador validará tu pedido y procederá con el despacho.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF49454F), height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFF79747E),
          letterSpacing: 1,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData? icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF49454F)) : null,
      filled: true,
      fillColor: const Color(0xFFF4EFF4),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

  Widget _buildBottomPanel(int total, dynamic cart) {
    String buttonText = '';
    VoidCallback onPressedAction = () {};

    if (_currentStep == 1) {
      buttonText = 'Continuar';
      onPressedAction = () async {
        if (_formKeyAddress.currentState!.validate()) {
          await _saveShippingDetails();
          setState(() => _currentStep = 2);
        }
      };
    } else if (_currentStep == 2) {
      buttonText = 'Ir al Pago';
      onPressedAction = () {
        setState(() => _currentStep = 3);
      };
    } else {
      buttonText = _paymentMethod == 'card' ? 'Pagar ${_formatCurrency(total)}' : 'Confirmar Compra';
      onPressedAction = _submitOrder;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${cart.items.fold<int>(0, (int prev, element) => prev + (element.quantity as int))} artículos • incl. envío e IGV',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                Text(
                  _formatCurrency(total),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C1B1F),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isProcessing ? null : onPressedAction,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF6750A4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 4,
                shadowColor: const Color(0xFF6750A4).withOpacity(0.3),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_currentStep == 3) ...[
                          const Icon(Icons.lock_outline, size: 18),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          buttonText,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        if (_currentStep < 3) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, size: 18),
                        ],
                      ],
                    ),
            ),
            const SizedBox(height: 12),
            // Credit card security / logos strip
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _MiniCardBadge(label: 'VISA'),
                SizedBox(width: 8),
                _MiniCardBadge(label: 'MASTERCARD'),
                SizedBox(width: 8),
                _MiniCardBadge(label: 'AMEX'),
                SizedBox(width: 8),
                Row(
                  children: [
                    Icon(Icons.lock_outline, size: 10, color: Color(0xFF79747E)),
                    SizedBox(width: 2),
                    Text(
                      'SSL',
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF79747E)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniCardBadge extends StatelessWidget {
  final String label;
  const _MiniCardBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF4EFF4),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFCAC4D0), width: 0.5),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: Color(0xFF49454F),
        ),
      ),
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (RegExp(r'\d').hasMatch(text[i])) {
        buffer.write(text[i]);
      }
    }

    var string = buffer.toString();
    var formattedBuffer = StringBuffer();
    for (int i = 0; i < string.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formattedBuffer.write(' ');
      }
      formattedBuffer.write(string[i]);
    }

    var formatted = formattedBuffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (RegExp(r'\d').hasMatch(text[i])) {
        buffer.write(text[i]);
      }
    }

    var string = buffer.toString();
    var formattedBuffer = StringBuffer();
    for (int i = 0; i < string.length; i++) {
      if (i == 2) {
        formattedBuffer.write('/');
      }
      formattedBuffer.write(string[i]);
    }

    var formatted = formattedBuffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
