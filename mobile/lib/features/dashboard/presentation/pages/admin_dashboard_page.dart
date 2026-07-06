import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/app_theme.dart';
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

            // Navigation shortcuts
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

            const SizedBox(height: 32),

            // 2. Sales Timeline Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Línea de Ventas',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
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
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 24, 16),
                child: SizedBox(
                  height: 200,
                  child: timelineAsync.when(
                    data: (timeline) {
                      if (timeline.isEmpty) {
                        return const Center(
                          child: Text('Sin datos de ventas en este rango'),
                        );
                      }
                      return LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: List.generate(timeline.length, (index) {
                                final point = timeline[index];
                                final revenue =
                                    (point['revenue'] as num).toDouble() /
                                    100.0;
                                return FlSpot(index.toDouble(), revenue);
                              }),
                              isCurved: true,
                              color: AppTheme.primaryColor,
                              barWidth: 4,
                              dotData: const FlDotData(show: true),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Text('Error al cargar gráfico: $err'),
                  ),
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
                          const Text(
                            'Excelente. Todos los productos tienen stock óptimo.',
                            style: TextStyle(fontSize: 13),
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
