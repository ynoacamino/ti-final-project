import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/catalog/presentation/providers/catalog_providers.dart';
import 'package:mobile/features/dashboard/presentation/providers/dashboard_providers.dart';

class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _CheckoutQtyController {
  final controller = TextEditingController();
  void dispose() => controller.dispose();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage> {
  String _selectedInterval = 'daily';
  String _selectedChartType = 'sales'; // 'sales' or 'orders'
  bool _isRestocking = false;

  String _formatCurrency(int cents) {
    return 'S/. ${(cents / 100).toStringAsFixed(2)}';
  }

  Future<void> _showRestockDialog(
    BuildContext context,
    String variantId,
    String sku,
    int currentStock,
  ) async {
    final qtyWrapper = _CheckoutQtyController();
    qtyWrapper.controller.text = '10'; // default restock quantity

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reabastecer variante $sku'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Stock actual: $currentStock unidades.'),
              const SizedBox(height: 16),
              TextField(
                controller: qtyWrapper.controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Cantidad a añadir',
                  suffixText: 'unidades',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                qtyWrapper.dispose();
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: _isRestocking
                  ? null
                  : () async {
                      final val = int.tryParse(qtyWrapper.controller.text) ?? 0;
                      if (val <= 0) return;

                      setState(() => _isRestocking = true);
                      Navigator.of(context).pop(); // close dialog early

                      final repo = ref.read(catalogRepositoryProvider);
                      final (done, failure) = await repo.updateVariantStock(
                        variantId,
                        val,
                      );

                      if (mounted) {
                        setState(() => _isRestocking = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              done
                                  ? '¡Stock actualizado correctamente!'
                                  : 'Error: ${failure?.message ?? "no se pudo actualizar"}',
                            ),
                            backgroundColor: done
                                ? AppTheme.secondaryColor
                                : AppTheme.errorColor,
                          ),
                        );
                        // Refresh dashboard and alerts
                        ref.invalidate(dashboardMetricsProvider);
                        ref.invalidate(dashboardOrderStatusProvider);
                        ref.invalidate(inventoryAlertsProvider);
                        ref.invalidate(
                          dashboardSalesTimelineProvider(_selectedInterval),
                        );
                      }
                      qtyWrapper.dispose();
                    },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final metricsAsync = ref.watch(dashboardMetricsProvider);
    final timelineAsync = ref.watch(
      dashboardSalesTimelineProvider(_selectedInterval),
    );
    final alertsAsync = ref.watch(inventoryAlertsProvider);
    final orderStatusAsync = ref.watch(dashboardOrderStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Administrativo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(dashboardMetricsProvider);
              ref.invalidate(dashboardOrderStatusProvider);
              ref.invalidate(inventoryAlertsProvider);
              ref.invalidate(dashboardSalesTimelineProvider(_selectedInterval));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: AppTheme.errorColor),
            tooltip: 'Cerrar Sesión',
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Metrics summary cards grid
            metricsAsync.when(
              data: (metrics) {
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildMetricCard(
                      context,
                      title: 'INGRESOS TOTALES',
                      value: _formatCurrency(metrics['totalSales'] as int),
                      icon: Icons.monetization_on_outlined,
                      color: AppTheme.secondaryColor,
                    ),
                    _buildMetricCard(
                      context,
                      title: 'PEDIDOS PAGADOS',
                      value: '${metrics['orderCount']}',
                      icon: Icons.local_mall_outlined,
                      color: AppTheme.primaryColor,
                    ),
                    _buildMetricCard(
                      context,
                      title: 'TICKET PROMEDIO',
                      value: _formatCurrency(metrics['averageTicket'] as int),
                      icon: Icons.receipt_long_outlined,
                      color: Colors.amber,
                    ),
                    _buildMetricCard(
                      context,
                      title: 'ALERTAS DE STOCK',
                      value: '${metrics['lowStockCount']}',
                      icon: Icons.warning_amber_outlined,
                      color: AppTheme.errorColor,
                    ),
                  ],
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, _) => Text('Error al cargar métricas: $err'),
            ),

            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: () => context.push('/admin/orders'),
              icon: const Icon(
                Icons.delivery_dining_outlined,
                color: Colors.white,
              ),
              label: const Text('Gestionar Envíos y Pedidos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: () => context.push('/admin/products'),
              icon: const Icon(
                Icons.storefront_outlined,
                color: Colors.black,
              ),
              label: const Text('Gestionar Catálogo de Productos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEAB308),
                foregroundColor: Colors.black,
              ),
            ),

            const SizedBox(height: 32),

             // 2. Sales Timeline / Orders Distribution Section
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(
                   _selectedChartType == 'sales' ? 'Línea de Ventas' : 'Distribución de Pedidos',
                   style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                 ),
                 if (_selectedChartType == 'sales')
                   DropdownButton<String>(
                     value: _selectedInterval,
                     items: const [
                       DropdownMenuItem(value: 'daily', child: Text('Diario')),
                       DropdownMenuItem(value: 'weekly', child: Text('Semanal')),
                       DropdownMenuItem(value: 'monthly', child: Text('Mensual')),
                     ],
                     onChanged: (val) {
                       if (val != null) {
                         setState(() => _selectedInterval = val);
                       }
                     },
                   ),
               ],
             ),
             const SizedBox(height: 12),
             
             // Choice toggles
             Row(
               children: [
                 ChoiceChip(
                   label: const Text('Ventas'),
                   selected: _selectedChartType == 'sales',
                   onSelected: (val) {
                     if (val) setState(() => _selectedChartType = 'sales');
                   },
                 ),
                 const SizedBox(width: 8),
                 ChoiceChip(
                   label: const Text('Pedidos'),
                   selected: _selectedChartType == 'orders',
                   onSelected: (val) {
                     if (val) setState(() => _selectedChartType = 'orders');
                   },
                 ),
               ],
             ),
             const SizedBox(height: 16),
             Card(
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                 child: _selectedChartType == 'sales'
                     ? SizedBox(
                         height: 200,
                         child: timelineAsync.when(
                           data: (timeline) {
                             if (timeline.isEmpty) {
                               return const Center(
                                 child: Text('Sin datos de ventas en este rango'),
                               );
                             }
                             
                             // Calculate dynamic max for left axis intervals
                             double maxVal = 100.0;
                             for (var pt in timeline) {
                               final val = (pt['revenue'] as num).toDouble() / 100.0;
                               if (val > maxVal) maxVal = val;
                             }
                             
                             return LineChart(
                               LineChartData(
                                 gridData: const FlGridData(
                                   show: true,
                                   drawVerticalLine: false,
                                   horizontalInterval: 100,
                                 ),
                                 titlesData: FlTitlesData(
                                   leftTitles: AxisTitles(
                                     sideTitles: SideTitles(
                                       showTitles: true,
                                       reservedSize: 55,
                                       getTitlesWidget: (value, meta) {
                                         return Padding(
                                           padding: const EdgeInsets.only(right: 6),
                                           child: Text(
                                             'S/. ${value.toInt()}',
                                             style: const TextStyle(color: AppTheme.darkTextSecondary, fontSize: 8),
                                             textAlign: TextAlign.right,
                                           ),
                                         );
                                       },
                                     ),
                                   ),
                                   bottomTitles: AxisTitles(
                                     sideTitles: SideTitles(
                                       showTitles: true,
                                       reservedSize: 22,
                                       getTitlesWidget: (value, meta) {
                                         final idx = value.toInt();
                                         if (idx >= 0 && idx < timeline.length) {
                                           final period = timeline[idx]['period'] as String;
                                           final label = period.length > 5 ? period.substring(period.length - 5) : period;
                                           return Padding(
                                             padding: const EdgeInsets.only(top: 4),
                                             child: Text(
                                               label,
                                               style: const TextStyle(color: AppTheme.darkTextSecondary, fontSize: 8),
                                             ),
                                           );
                                         }
                                         return const SizedBox();
                                       },
                                     ),
                                   ),
                                   rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                   topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                 ),
                                 borderData: FlBorderData(show: false),
                                 lineBarsData: [
                                   LineChartBarData(
                                     spots: List.generate(timeline.length, (index) {
                                       final point = timeline[index];
                                       final revenue = (point['revenue'] as num).toDouble() / 100.0;
                                       return FlSpot(index.toDouble(), revenue);
                                     }),
                                     isCurved: true,
                                     color: AppTheme.primaryColor,
                                     barWidth: 3,
                                     dotData: const FlDotData(show: true),
                                   ),
                                 ],
                               ),
                             );
                           },
                           loading: () => const Center(child: CircularProgressIndicator()),
                           error: (err, _) => Text('Error al cargar gráfico: $err'),
                         ),
                       )
                     : orderStatusAsync.when(
                         data: (dist) {
                           final totalOrders = dist.values.fold<int>(0, (sum, v) => sum + (v as int));
                           if (totalOrders == 0) {
                             return const Center(child: Text('Sin pedidos registrados'));
                           }
                           
                           return Column(
                             crossAxisAlignment: CrossAxisAlignment.stretch,
                             children: dist.entries.map<Widget>((entry) {
                               final status = entry.key;
                               final count = entry.value as int;
                               final percent = count / totalOrders;
                               
                               Color color = const Color(0xFF94A3B8);
                               if (status == 'pendiente') color = Colors.orange;
                               if (status == 'pagado') color = const Color(0xFF38BDF8);
                               if (status == 'enviado') color = const Color(0xFF818CF8);
                               if (status == 'entregado') color = const Color(0xFF34D399);
                               if (status == 'cancelado') color = const Color(0xFFF87171);
                               
                               return Padding(
                                 padding: const EdgeInsets.only(bottom: 12.0),
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.stretch,
                                   children: [
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                       children: [
                                         Text(
                                           status.toUpperCase(),
                                           style: TextStyle(
                                             color: color,
                                             fontWeight: FontWeight.bold,
                                             fontSize: 10,
                                             letterSpacing: 1.1,
                                           ),
                                         ),
                                         Text(
                                           '$count (${(percent * 100).toStringAsFixed(0)}%)',
                                           style: const TextStyle(
                                             color: Colors.white,
                                             fontSize: 11,
                                             fontWeight: FontWeight.bold,
                                           ),
                                         ),
                                       ],
                                     ),
                                     const SizedBox(height: 6),
                                     ClipRRect(
                                       borderRadius: BorderRadius.circular(4),
                                       child: LinearProgressIndicator(
                                         value: percent,
                                         backgroundColor: Colors.white10,
                                         valueColor: AlwaysStoppedAnimation<Color>(color),
                                         minHeight: 8,
                                       ),
                                     ),
                                   ],
                                 ),
                               );
                             }).toList(),
                           );
                         },
                         loading: () => const Center(child: CircularProgressIndicator()),
                         error: (err, _) => Text('Error al cargar distribución: $err'),
                       ),
               ),
             ),

            const SizedBox(height: 32),

            // 3. Active Low Stock Alerts Section
            Text(
              'Alertas de Inventario Crítico',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            alertsAsync.when(
              data: (alerts) {
                if (alerts.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppTheme.secondaryColor.withOpacity(0.8),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Excelente. Todos los productos tienen stock óptimo.',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: alerts.length,
                  itemBuilder: (context, index) {
                    final alert = alerts[index];
                    final variantId = alert['productVariantId'] as String;
                    final stock = alert['currentStock'] as int;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.errorColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.warning,
                            color: AppTheme.errorColor,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          'Variante ID: ${variantId.substring(0, 8)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        subtitle: Text(
                          'Stock actual: $stock unidades (Umbral: 5)',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => _showRestockDialog(
                            context,
                            variantId,
                            variantId.substring(0, 8),
                            stock,
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(80, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            backgroundColor: AppTheme.primaryColor,
                          ),
                          child: const Text(
                            'Reabastecer',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, _) => Text('Error al cargar alertas: $err'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 10,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textSecondaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(icon, color: color, size: 20),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
