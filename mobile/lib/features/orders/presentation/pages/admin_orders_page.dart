import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/orders/presentation/providers/orders_providers.dart';
import 'package:mobile/features/dashboard/presentation/providers/dashboard_providers.dart';

class AdminOrdersPage extends ConsumerStatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  ConsumerState<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends ConsumerState<AdminOrdersPage> {
  String? _selectedStatusFilter;
  bool _isUpdating = false;

  String _formatAddress(String? addressJson) {
    if (addressJson == null || addressJson.isEmpty) return 'Dirección no disponible';
    try {
      final parsed = jsonDecode(addressJson);
      if (parsed is Map) {
        final street = parsed['street'] ?? parsed['address'] ?? '';
        final city = parsed['city'] ?? '';
        final state = parsed['state'] ?? parsed['department'] ?? '';
        final ref = parsed['references'] ?? parsed['reference'] ?? '';

        final parts = <String>[];
        if (street.toString().isNotEmpty) parts.add(street.toString());
        if (city.toString().isNotEmpty) parts.add(city.toString());
        if (state.toString().isNotEmpty) parts.add(state.toString());
        if (ref.toString().isNotEmpty) parts.add('Ref: ${ref.toString()}');

        return parts.isEmpty ? addressJson : parts.join(', ');
      }
    } catch (_) {}
    return addressJson;
  }

  String _formatCurrency(int cents) {
    return 'S/. ${(cents / 100).toStringAsFixed(2)}';
  }

  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (_) {
      return isoString;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return const Color(0xFFFBBF24); // Yellow
      case 'pagado':
        return const Color(0xFF38BDF8); // Light Blue
      case 'enviado':
        return const Color(0xFFA78BFA); // Light Purple
      case 'entregado':
        return const Color(0xFF34D399); // Teal
      case 'cancelado':
      case 'fallido':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF64748B); // Slate Gray
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pendiente':
        return Icons.access_time;
      case 'pagado':
        return Icons.credit_card;
      case 'enviado':
        return Icons.local_shipping;
      case 'entregado':
        return Icons.check_circle_outline;
      default:
        return Icons.cancel_outlined;
    }
  }

  List<String> _getNextStates(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'pendiente':
        return ['pagado', 'cancelado', 'fallido'];
      case 'pagado':
        return ['enviado', 'cancelado'];
      case 'enviado':
        return ['entregado'];
      default:
        return [];
    }
  }

  Future<void> _updateStatus(String orderId, String newStatus) async {
    setState(() => _isUpdating = true);
    final repo = ref.read(ordersRepositoryProvider);
    final (updatedOrder, failure) = await repo.updateOrderStatus(orderId, newStatus);

    if (mounted) {
      setState(() => _isUpdating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            updatedOrder != null
                ? 'Estado actualizado a $newStatus'
                : 'Error: ${failure?.message ?? "no se pudo actualizar"}',
          ),
          backgroundColor: updatedOrder != null
              ? const Color(0xFF34D399)
              : const Color(0xFFEF4444),
        ),
      );
      // Refresh admin order lists
      ref.invalidate(adminOrdersProvider(_selectedStatusFilter));
      // Refresh dashboard stats
      ref.invalidate(dashboardMetricsProvider);
      ref.invalidate(dashboardOrderStatusProvider);
    }
  }

  Color _getAvatarBgColor(String name) {
    final code = name.codeUnits.fold(0, (prev, element) => prev + element);
    final hue = code % 360;
    return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.45, 0.28).toColor();
  }

  Color _getAvatarTextColor(String name) {
    final code = name.codeUnits.fold(0, (prev, element) => prev + element);
    final hue = code % 360;
    return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.70, 0.80).toColor();
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '??';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(adminOrdersProvider(_selectedStatusFilter));

    return Theme(
      data: AppTheme.darkTheme,
      child: Scaffold(
        backgroundColor: AppTheme.darkBackground,
        appBar: AppBar(
          title: const Text('Administrar Pedidos'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(adminOrdersProvider(_selectedStatusFilter)),
            ),
          ],
        ),
        body: Column(
          children: [
            // Statistics Summary Strip (Matching will layout stats)
            ordersAsync.maybeWhen(
              data: (list) {
                final activeCount = list.where((o) => o.status.toLowerCase() != 'entregado' && o.status.toLowerCase() != 'cancelado').length;
                final deliveredCount = list.where((o) => o.status.toLowerCase() == 'entregado').length;
                final totalSalesCents = list.where((o) => o.status.toLowerCase() == 'pagado' || o.status.toLowerCase() == 'enviado' || o.status.toLowerCase() == 'entregado').fold(0, (sum, o) => sum + o.total);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      _buildStatCard('Activos', '$activeCount', const Color(0xFF818CF8)),
                      const SizedBox(width: 10),
                      _buildStatCard('Entregados', '$deliveredCount', const Color(0xFF34D399)),
                      const SizedBox(width: 10),
                      _buildStatCard('Ventas', _formatCurrency(totalSalesCents), const Color(0xFF38BDF8)),
                    ],
                  ),
                );
              },
              orElse: () => const SizedBox(),
            ),

            // Dropdown Status Filter Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.filter_list, color: AppTheme.darkTextSecondary),
                  const SizedBox(width: 8),
                  const Text('Filtrar:', style: TextStyle(color: AppTheme.darkTextPrimary, fontSize: 13)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String?>(
                      value: _selectedStatusFilter,
                      dropdownColor: AppTheme.darkSurface,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      items: const [
                        DropdownMenuItem(value: null, child: Text('Todos')),
                        DropdownMenuItem(value: 'pendiente', child: Text('Pendiente')),
                        DropdownMenuItem(value: 'pagado', child: Text('Pagado')),
                        DropdownMenuItem(value: 'enviado', child: Text('Enviado')),
                        DropdownMenuItem(value: 'entregado', child: Text('Entregado')),
                        DropdownMenuItem(value: 'cancelado', child: Text('Cancelado')),
                      ],
                      onChanged: (val) {
                        setState(() => _selectedStatusFilter = val);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Orders list view
            Expanded(
              child: _isUpdating
                  ? const Center(child: CircularProgressIndicator())
                  : ordersAsync.when(
                      data: (list) {
                        if (list.isEmpty) {
                          return const Center(
                            child: Text(
                              'No hay pedidos registrados.',
                              style: TextStyle(color: AppTheme.darkTextSecondary),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final order = list[index];
                            final nextStates = _getNextStates(order.status);
                            final customerName = order.guestName ?? 'Cliente Registrado';
                            final initials = _getInitials(customerName);

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: AppTheme.darkSurface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0x17818CF8),
                                  width: 1.5,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    dividerColor: Colors.transparent,
                                  ),
                                  child: ExpansionTile(
                                    leading: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: _getAvatarBgColor(customerName),
                                      child: Text(
                                        initials,
                                        style: TextStyle(
                                          color: _getAvatarTextColor(customerName),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            customerName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: AppTheme.darkTextPrimary,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '#${order.id.substring(0, 8).toUpperCase()}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'monospace',
                                            color: AppTheme.darkTextSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _formatCurrency(order.total),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.darkPrimary,
                                            ),
                                          ),
                                          _buildStatusBadge(order.status),
                                        ],
                                      ),
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Divider(color: Color(0x17818CF8)),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const Icon(Icons.calendar_today_outlined, size: 14, color: AppTheme.darkTextSecondary),
                                                const SizedBox(width: 6),
                                                Text(
                                                  _formatDate(order.createdAt),
                                                  style: const TextStyle(fontSize: 12, color: AppTheme.darkTextSecondary),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.darkTextSecondary),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(
                                                    _formatAddress(order.shippingAddress),
                                                    style: const TextStyle(fontSize: 12, color: AppTheme.darkTextSecondary),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                const Icon(Icons.phone_outlined, size: 14, color: AppTheme.darkTextSecondary),
                                                const SizedBox(width: 6),
                                                Text(
                                                  order.guestPhone ?? 'N/A',
                                                  style: const TextStyle(fontSize: 12, color: AppTheme.darkTextSecondary),
                                                ),
                                                const SizedBox(width: 16),
                                                const Icon(Icons.email_outlined, size: 14, color: AppTheme.darkTextSecondary),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(
                                                    order.guestEmail ?? 'Registrado',
                                                    style: const TextStyle(fontSize: 12, color: AppTheme.darkTextSecondary),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),

                                            const Text(
                                              'Detalle de compra:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: AppTheme.darkTextPrimary,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            ...order.items.map((item) {
                                              return Container(
                                                margin: const EdgeInsets.symmetric(vertical: 4),
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF080D1A),
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: const Color(0x12818CF8)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.backpack_outlined, size: 14, color: AppTheme.darkPrimary),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Text(
                                                        item.productNameSnapshot,
                                                        style: const TextStyle(fontSize: 12, color: AppTheme.darkTextPrimary),
                                                      ),
                                                    ),
                                                    Text(
                                                      'x${item.quantity}',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                        color: AppTheme.darkTextSecondary,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Text(
                                                      _formatCurrency(item.unitPrice * item.quantity),
                                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),

                                            if (nextStates.isNotEmpty) ...[
                                              const SizedBox(height: 20),
                                              const Text(
                                                'Actualizar Estado (Flujo Secuencial):',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: AppTheme.darkTextPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Wrap(
                                                spacing: 8,
                                                children: nextStates.map((state) {
                                                  return ActionChip(
                                                    backgroundColor: _getStatusColor(state).withOpacity(0.08),
                                                    side: BorderSide(color: _getStatusColor(state).withOpacity(0.3)),
                                                    label: Text(
                                                      state.toUpperCase(),
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.bold,
                                                        color: _getStatusColor(state),
                                                      ),
                                                    ),
                                                    onPressed: () => _updateStatus(order.id, state),
                                                  );
                                                }).toList(),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, _) => Center(child: Text('Error al cargar pedidos: $err')),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.darkSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x17818CF8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: AppTheme.darkTextSecondary,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    final icon = _getStatusIcon(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
