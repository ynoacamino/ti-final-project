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
        return Colors.orange;
      case 'pagado':
        return AppTheme.secondaryColor;
      case 'enviado':
        return Colors.blue;
      case 'entregado':
        return Colors.teal;
      case 'cancelado':
      case 'fallido':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondaryColor;
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
    final (updatedOrder, failure) = await repo.updateOrderStatus(
      orderId,
      newStatus,
    );

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
              ? AppTheme.secondaryColor
              : AppTheme.errorColor,
        ),
      );
      // Refresh admin order lists
      ref.invalidate(adminOrdersProvider(_selectedStatusFilter));
      // Refresh dashboard stats
      ref.invalidate(dashboardMetricsProvider);
      ref.invalidate(dashboardOrderStatusProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(adminOrdersProvider(_selectedStatusFilter));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Pedidos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.invalidate(adminOrdersProvider(_selectedStatusFilter)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.filter_list,
                  color: AppTheme.textSecondaryColor,
                ),
                const SizedBox(width: 8),
                const Text('Filtrar por:'),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String?>(
                    value: _selectedStatusFilter,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('Todos')),
                      DropdownMenuItem(
                        value: 'pendiente',
                        child: Text('Pendiente'),
                      ),
                      DropdownMenuItem(value: 'pagado', child: Text('Pagado')),
                      DropdownMenuItem(
                        value: 'enviado',
                        child: Text('Enviado'),
                      ),
                      DropdownMenuItem(
                        value: 'entregado',
                        child: Text('Entregado'),
                      ),
                      DropdownMenuItem(
                        value: 'cancelado',
                        child: Text('Cancelado'),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() => _selectedStatusFilter = val);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Orders List
          Expanded(
            child: _isUpdating
                ? const Center(child: CircularProgressIndicator())
                : ordersAsync.when(
                    data: (list) {
                      if (list.isEmpty) {
                        return const Center(
                          child: Text(
                            'No hay pedidos registrados con este estado.',
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final order = list[index];
                          final nextStates = _getNextStates(order.status);

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ExpansionTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Pedido #${order.id.substring(0, 8)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(
                                        order.status,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _getStatusColor(order.status),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      order.status.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: _getStatusColor(order.status),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  'Cliente: ${order.guestName ?? order.customerId ?? "Invitado"}\nFecha: ${_formatDate(order.createdAt)}\nTotal: ${_formatCurrency(order.total)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Divider(color: Color(0xFF334155)),
                                      const SizedBox(height: 8),

                                      // Contact details
                                      Text(
                                        'Contacto: ${order.guestEmail ?? "Registrado"} | Teléfono: ${order.guestPhone ?? "N/A"}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textSecondaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      // Item listings
                                      const Text(
                                        'Prendas:',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      ...order.items.map((item) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 2.0,
                                          ),
                                          child: Text(
                                            '- ${item.productNameSnapshot} x${item.quantity} [Talla ${item.variantDetailsSnapshot.contains("size") ? "S/M/L" : ""}]',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        );
                                      }),

                                      // Status flow actions
                                      if (nextStates.isNotEmpty) ...[
                                        const SizedBox(height: 16),
                                        const Text(
                                          'Cambiar estado (Flujo Secuencial):',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Wrap(
                                          spacing: 12,
                                          children: nextStates.map((state) {
                                            return ActionChip(
                                              label: Text(
                                                state.toUpperCase(),
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              backgroundColor: _getStatusColor(
                                                state,
                                              ).withOpacity(0.1),
                                              side: BorderSide(
                                                color: _getStatusColor(state),
                                                width: 1,
                                              ),
                                              onPressed: () => _updateStatus(
                                                order.id,
                                                state,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, _) =>
                        Center(child: Text('Error al cargar pedidos: $err')),
                  ),
          ),
        ],
      ),
    );
  }
}
