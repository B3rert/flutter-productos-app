import 'package:flutter/material.dart';
import 'package:productos_app/widgets/widgets.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save_outlined),
        onPressed: () {},
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImage(),
                Positioned(
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                  top: 60,
                  left: 20,
                ),
                Positioned(
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                    ),
                  ),
                  top: 60,
                  right: 20,
                ),
              ],
            ),
            _ProductForm(),
            SizedBox(height: 100),
          ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: _builBoxDecoration(),
        width: double.infinity,
        child: Form(
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre',
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '\$0.00',
                  labelText: 'Precio',
                ),
              ),
              SizedBox(height: 30),
              SwitchListTile.adaptive(
                title: Text('Disponible'),
                value: true,
                onChanged: (value) {},
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _builBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 5),
            blurRadius: 5,
          ),
        ],
      );
}
