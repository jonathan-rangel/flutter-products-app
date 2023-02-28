import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_products/providers/product_form_provider.dart';
import 'package:flutter_products/services/products_service.dart';
import 'package:flutter_products/ui/input_decorations.dart';
import 'package:flutter_products/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductsService>(context);

    return ChangeNotifierProvider(
      create: (_) => ProductFormProvider(productService.selectedProduct),
      child: _ProductScreenBody(productService: productService),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productService,
  }) : super(key: key);

  final ProductsService productService;

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit product'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ProductImage(
                    url: productService.selectedProduct.picture,
                  ),
                  Positioned(
                      top: 20,
                      right: 20,
                      child: IconButton(
                        iconSize: 35,
                        onPressed: () {
                          final picker = ImagePicker();
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Wrap(
                                children: [
                                  ListTile(
                                    leading:
                                        const Icon(Icons.camera_alt_outlined),
                                    title: const Text('Open camera'),
                                    onTap: () async {
                                      Navigator.of(context).pop();
                                      final XFile? pickedFile =
                                          await picker.pickImage(
                                              source: ImageSource.camera,
                                              imageQuality: 100);
                                      if (pickedFile == null) {
                                        return;
                                      } else {
                                        productService
                                            .updateSelectedProductImage(
                                                pickedFile.path);
                                      }
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.browse_gallery),
                                    title: const Text('Select from gallery'),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      final XFile? pickedFile =
                                          await picker.pickImage(
                                              source: ImageSource.gallery,
                                              imageQuality: 100);
                                      if (pickedFile == null) {
                                        return;
                                      } else {
                                        productService
                                            .updateSelectedProductImage(
                                                pickedFile.path);
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.black87,
                        ),
                      ))
                ],
              ),
              const _ProductForm(),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: productService.isSaving
              ? null
              : () async {
                  if (!productForm.isValidForm()) {
                    return;
                  } else {
                    final String? imageURL = await productService.uploadImage();
                    if (imageURL != null) {
                      productForm.product.picture = imageURL;
                    }
                    await productService
                        .saveOrCreateProduct(productForm.product);
                  }
                },
          child: productService.isSaving
              ? const CircularProgressIndicator(
                  color: Colors.black87,
                )
              : const Icon(Icons.save_rounded),
        ),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProductFormProvider>(context);
    final product = productForm.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
            key: productForm.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: product.name,
                  onChanged: (value) => product.name = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Must be enter a name';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecorations.authInputDecoration(
                    hintText: 'Name',
                    labelText: 'Product name',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: product.price.toString(),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  onChanged: (value) {
                    if (double.tryParse(value) == null) {
                      product.price = 0;
                    } else {
                      product.price = double.parse(value);
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecorations.authInputDecoration(
                    hintText: '\$150',
                    labelText: 'Product price',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SwitchListTile.adaptive(
                  title: const Text('Available'),
                  activeColor: Colors.black87,
                  value: product.available,
                  onChanged: productForm.updateAvailability,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            )),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 0),
              blurRadius: 5,
            )
          ]);
}
