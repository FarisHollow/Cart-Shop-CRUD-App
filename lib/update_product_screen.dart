import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:cart_shop/product.dart';

class UpdateProductScreen extends StatefulWidget {
  final Product product;

  const UpdateProductScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _productCodeTEController =
  TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();

  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  bool inProgress = false;

  @override
  void initState() {
    _nameTEController.text = widget.product.productName;
    _productCodeTEController.text = widget.product.productCode;
    _priceTEController.text = widget.product.unitPrice;
    _totalPriceTEController.text = widget.product.totalPrice;
    _imageTEController.text = widget.product.image;
    _quantityTEController.text = widget.product.quantity;
    super.initState();
  }

  void updateProduct() async {
    inProgress = true;
    if (mounted) {
      setState(() {});
    }
    Response response = await post(
        Uri.parse(
            'https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}'),
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({
          "Img": _imageTEController.text.trim(),
          "ProductCode": _productCodeTEController.text.trim(),
          "ProductName": _nameTEController.text.trim(),
          "Qty": _quantityTEController.text.trim(),
          "TotalPrice": _totalPriceTEController.text.trim(),
          "UnitPrice": _priceTEController.text.trim()
        }));
    inProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.statusCode == 200) {
      final decodedBody = jsonDecode(response.body);
      if (decodedBody['status'] == 'success') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product update success!')));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('New product add failed. Try again')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formState,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameTEController,
                  decoration: const InputDecoration(hintText: 'Name'),
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return 'Enter your product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _productCodeTEController,
                  decoration: const InputDecoration(hintText: 'Product code'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _priceTEController,
                  decoration: const InputDecoration(hintText: 'Price'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _quantityTEController,
                  decoration: const InputDecoration(hintText: 'Quantity'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _totalPriceTEController,
                  decoration: const InputDecoration(hintText: 'Total Price'),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _imageTEController,
                  decoration: const InputDecoration(
                    hintText: 'Image',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: inProgress
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      if (_formState.currentState!.validate()) {
                        updateProduct();
                      }
                    },
                    child: const Text('Update'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}