import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/catalog/presentation/providers/catalog_providers.dart';

class CreateProductPage extends ConsumerStatefulWidget {
  const CreateProductPage({super.key});

  @override
  ConsumerState<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends ConsumerState<CreateProductPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _basePriceController = TextEditingController();
  final _comparePriceController = TextEditingController();
  
  String? _selectedCategoryId;
  bool _chargeTax = true;
  bool _isPublishing = false;

  // Selected Images from our mock gallery
  final List<String> _selectedImages = [];
  
  // List of product variants
  final List<Map<String, dynamic>> _variants = [];

  // Popular premium clothing images for easy creation in demo
  final List<String> _demoImages = [
    'https://images.unsplash.com/photo-1548883354-7622d03aca27?w=500', // Casaca Cortaviento
    'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500', // Camisa Azul
    'https://images.unsplash.com/photo-1542272604-787c3835535d?w=500', // Jean Negro
    'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=500', // Vestido Verano
    'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500', // Bolso Cuero
    'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=500', // Gorra
    'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=500', // Polera Premium
    'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=500', // Zapatillas
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _basePriceController.dispose();
    _comparePriceController.dispose();
    super.dispose();
  }

  // Pre-generate SKU based on product name, size, and color
  String _generateSKU(String name, String size, String color) {
    final cleanName = name.trim().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();
    final namePrefix = cleanName.length > 5 ? cleanName.substring(0, 5) : cleanName;
    final cleanColor = color.trim().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();
    final colorSuffix = cleanColor.length > 3 ? cleanColor.substring(0, 3) : cleanColor;
    return '$namePrefix-$size-$colorSuffix'.replaceAll('--', '-');
  }

  void _showAddVariantDialog() {
    final sizeController = TextEditingController(text: 'M');
    final colorController = TextEditingController(text: 'Negro');
    final stockController = TextEditingController(text: '15');
    final priceController = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0x22818CF8)),
          ),
          title: const Text(
            'Añadir Variante',
            style: TextStyle(color: AppTheme.darkTextPrimary, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: sizeController,
                  style: const TextStyle(color: AppTheme.darkTextPrimary),
                  decoration: const InputDecoration(labelText: 'Talla / Tamaño (ej. S, M, L, 32)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: colorController,
                  style: const TextStyle(color: AppTheme.darkTextPrimary),
                  decoration: const InputDecoration(labelText: 'Color (ej. Negro, Azul, Rojo)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: stockController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppTheme.darkTextPrimary),
                  decoration: const InputDecoration(labelText: 'Stock Inicial'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppTheme.darkTextPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Precio Adicional (opcional)',
                    prefixText: 'S/. ',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar', style: TextStyle(color: AppTheme.darkTextSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                final size = sizeController.text.trim();
                final color = colorController.text.trim();
                final stock = int.tryParse(stockController.text.trim()) ?? 0;
                final additionalPriceVal = double.tryParse(priceController.text.trim()) ?? 0.0;
                final additionalPriceCents = (additionalPriceVal * 100).round();

                if (size.isEmpty || color.isEmpty) return;

                final sku = _generateSKU(_nameController.text.isNotEmpty ? _nameController.text : 'PROD', size, color);

                setState(() {
                  _variants.add({
                    'size': size,
                    'color': color,
                    'sku': sku,
                    'stock': stock,
                    'additionalPrice': additionalPriceCents,
                  });
                });
                Navigator.of(context).pop();
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }

  void _showMediaPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.darkSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Seleccionar Imagen para el Producto',
                    style: TextStyle(
                      color: AppTheme.darkTextPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: _demoImages.length,
                      itemBuilder: (context, index) {
                        final imgUrl = _demoImages[index];
                        final isSelected = _selectedImages.contains(imgUrl);
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              if (isSelected) {
                                _selectedImages.remove(imgUrl);
                              } else {
                                _selectedImages.add(imgUrl);
                              }
                            });
                            setState(() {}); // Update main screen
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(imgUrl, fit: BoxFit.cover),
                              ),
                              if (isSelected)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.check, color: Colors.amber, size: 28),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEAB308),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Listo'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _publishProduct() async {
    if (!_formKey.currentState!.validate()) {
      _tabController.animateTo(0); // Regresar a info general si hay campos vacíos
      return;
    }

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecciona una categoría.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      _tabController.animateTo(0);
      return;
    }

    if (_variants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes añadir al menos una variante de talla y color en la sección de Variantes.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      _tabController.animateTo(1);
      return;
    }

    setState(() => _isPublishing = true);

    final basePriceDouble = double.tryParse(_basePriceController.text.trim()) ?? 0.0;
    final basePriceCents = (basePriceDouble * 100).round();

    final repo = ref.read(catalogRepositoryProvider);

    // 1. Create product
    final (createdProduct, failure) = await repo.createProduct(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      basePrice: basePriceCents,
      categoryId: _selectedCategoryId!,
      variants: _variants,
    );

    if (createdProduct == null) {
      if (mounted) {
        setState(() => _isPublishing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al crear producto: ${failure?.message ?? "Desconocido"}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
      return;
    }

    // 2. Upload images
    try {
      final dioClient = ref.read(dioClientProvider);
      for (final imageUrl in _selectedImages) {
        final response = await dioClient.dio.get<List<int>>(
          imageUrl,
          options: Options(responseType: ResponseType.bytes),
        );
        final bytes = response.data;
        if (bytes != null) {
          final formData = FormData.fromMap({
            'file': MultipartFile.fromBytes(
              bytes,
              filename: 'product_image.jpg',
              contentType: DioMediaType.parse('image/jpeg'),
            ),
          });
          await dioClient.dio.post(
            '/products/${createdProduct.id}/images',
            data: formData,
          );
        }
      }
    } catch (e) {
      debugPrint('Error subiendo imágenes al backend: $e');
    }

    if (mounted) {
      setState(() => _isPublishing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Producto publicado correctamente!'),
          backgroundColor: AppTheme.secondaryColor,
        ),
      );
      ref.invalidate(productsProvider);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.darkSurface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.darkTextPrimary),
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: const [
            Text(
              'NUEVO PRODUCTO',
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.darkTextSecondary,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Crear Publicación',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppTheme.darkTextPrimary,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                _buildTabButton(0, 'Datos Generales', Icons.inventory_2_outlined),
                const SizedBox(width: 8),
                _buildTabButton(1, 'Variantes', Icons.layers_outlined),
                const SizedBox(width: 8),
                _buildTabButton(2, 'Imágenes', Icons.image_outlined),
              ],
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Tab 1: General Info
            _buildGeneralInfoTab(categoriesAsync),
            // Tab 2: Variants
            _buildVariantsTab(),
            // Tab 3: Images Gallery
            _buildImagesGalleryTab(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          decoration: const BoxDecoration(
            color: AppTheme.darkSurface,
            border: Border(top: BorderSide(color: Color(0x17818CF8), width: 1)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    side: const BorderSide(color: AppTheme.darkTextSecondary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Guardar Borrador',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: _isPublishing ? null : _publishProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEAB308),
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isPublishing
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                        )
                      : const Text(
                          'Publicar Producto',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String label, IconData icon) {
    final isSelected = _tabController.index == index;
    final isVariantsTab = index == 1;
    final isVariantsEmpty = isVariantsTab && _variants.isEmpty;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _tabController.animateTo(index);
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? (isVariantsEmpty ? AppTheme.errorColor.withOpacity(0.8) : const Color(0xFFEAB308))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (isVariantsEmpty ? AppTheme.errorColor.withOpacity(0.5) : Colors.white10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Colors.black
                    : (isVariantsEmpty ? AppTheme.errorColor : AppTheme.darkTextSecondary),
                size: 16,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  isVariantsTab ? '$label (${_variants.length})' : label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.black
                        : (isVariantsEmpty ? AppTheme.errorColor : AppTheme.darkTextSecondary),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeneralInfoTab(AsyncValue<List<dynamic>> categoriesAsync) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name Field
          _buildFieldHeader('NOMBRE DEL PRODUCTO', '0/120'),
          TextFormField(
            controller: _nameController,
            maxLength: 120,
            style: const TextStyle(color: AppTheme.darkTextPrimary),
            validator: (value) {
              if (value == null || value.trim().length < 2) {
                return 'El nombre debe tener al menos 2 caracteres';
              }
              return null;
            },
            buildCounter: (context, {required currentLength, required isFocused, maxLength}) => const SizedBox.shrink(),
            decoration: const InputDecoration(
              hintText: 'ej. Bolso de Cuero premium',
            ),
          ),
          const SizedBox(height: 24),

          // Category Select
          _buildFieldHeader('CATEGORÍA', ''),
          categoriesAsync.when(
            data: (categories) {
              return DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                dropdownColor: AppTheme.darkSurface,
                style: const TextStyle(color: AppTheme.darkTextPrimary),
                decoration: const InputDecoration(
                  hintText: 'Seleccionar categoría',
                ),
                items: categories.map((cat) {
                  return DropdownMenuItem<String>(
                    value: cat.id,
                    child: Text(cat.name),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCategoryId = val;
                  });
                },
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, _) => Text(
              'Error al cargar categorías: $err',
              style: const TextStyle(color: AppTheme.errorColor),
            ),
          ),
          const SizedBox(height: 24),

          // Description Field
          _buildFieldHeader('DESCRIPCIÓN', '0/2000'),
          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            maxLength: 2000,
            style: const TextStyle(color: AppTheme.darkTextPrimary),
            buildCounter: (context, {required currentLength, required isFocused, maxLength}) => const SizedBox.shrink(),
            decoration: const InputDecoration(
              hintText: 'Describe el producto en detalle — materiales, dimensiones, instrucciones de cuidado y puntos clave de venta...',
            ),
          ),
          const SizedBox(height: 24),

          // Prices Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldHeader('PRECIO BASE', ''),
                    TextFormField(
                      controller: _basePriceController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppTheme.darkTextPrimary),
                      validator: (value) {
                        final val = double.tryParse(value ?? '') ?? 0;
                        if (val <= 0) {
                          return 'Debe ser mayor a 0';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'S/. 0.00',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldHeader('COMPARAR CON', ''),
                    TextFormField(
                      controller: _comparePriceController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppTheme.darkTextPrimary),
                      decoration: const InputDecoration(
                        hintText: 'S/. 0.00',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Tax Switch
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.darkSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x17818CF8)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Cobrar impuestos en este producto',
                        style: TextStyle(
                          color: AppTheme.darkTextPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Aplica tasas de impuestos regionales en el pago',
                        style: TextStyle(
                          color: AppTheme.darkTextSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _chargeTax,
                  activeColor: const Color(0xFFEAB308),
                  onChanged: (val) {
                    setState(() {
                      _chargeTax = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildVariantsTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'VARIANTES DEL PRODUCTO',
                  style: TextStyle(
                    color: AppTheme.darkTextSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _showAddVariantDialog,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 36),
                  backgroundColor: AppTheme.darkSurface,
                  foregroundColor: const Color(0xFFEAB308),
                  side: const BorderSide(color: Color(0x22EAB308)),
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Añadir Variante', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _variants.isEmpty
                ? const Center(
                    child: Text(
                      'Aún no se han añadido variantes.\nCada producto necesita al menos una variante.',
                      style: TextStyle(color: AppTheme.darkTextSecondary),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: _variants.length,
                    itemBuilder: (context, index) {
                      final item = _variants[index];
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: AppTheme.errorColor,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            _variants.removeAt(index);
                          });
                        },
                        child: Card(
                          color: AppTheme.darkSurface,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item['size'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(
                              'Color: ${item['color']}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  'SKU: ${item['sku']}',
                                  style: const TextStyle(fontSize: 12, color: AppTheme.darkTextSecondary),
                                ),
                                Text(
                                  'Stock: ${item['stock']} unidades',
                                  style: const TextStyle(fontSize: 12, color: AppTheme.darkTextSecondary),
                                ),
                              ],
                            ),
                            trailing: item['additionalPrice'] > 0
                                ? Text(
                                    '+ S/. ${(item['additionalPrice'] / 100).toStringAsFixed(2)}',
                                    style: const TextStyle(color: Colors.greenAccent, fontSize: 13),
                                  )
                                : const Text('Precio Base', style: TextStyle(fontSize: 12)),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagesGalleryTab() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'GALERÍA DE IMÁGENES',
                style: TextStyle(
                  color: AppTheme.darkTextSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showMediaPicker,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 36),
                  backgroundColor: AppTheme.darkSurface,
                  foregroundColor: const Color(0xFFEAB308),
                  side: const BorderSide(color: Color(0x22EAB308)),
                ),
                icon: const Icon(Icons.add_photo_alternate_outlined, size: 16),
                label: const Text('Seleccionar Fotos', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _selectedImages.isEmpty
                ? const Center(
                    child: Text(
                      'Aún no se han seleccionado imágenes.\nToca "Seleccionar Fotos" para añadir imágenes de prendas a la galería.',
                      style: TextStyle(color: AppTheme.darkTextSecondary),
                      textAlign: TextAlign.center,
                    ),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      final url = _selectedImages[index];
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(url, fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImages.removeAt(index);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldHeader(String label, String rightLabel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.darkTextSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          if (rightLabel.isNotEmpty)
            Text(
              rightLabel,
              style: const TextStyle(
                color: AppTheme.darkTextSecondary,
                fontSize: 11,
              ),
            ),
        ],
      ),
    );
  }
}
