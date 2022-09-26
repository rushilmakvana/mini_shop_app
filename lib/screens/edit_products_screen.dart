import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/products.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static final routeName = 'edit-products';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _price = FocusNode();
  final _desc = FocusNode();
  final isImageUrl = TextEditingController();
  final _imageNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    imageUrl: '',
    price: 0.0,
  );
  var _isinit = true;
  var isLoading = false;
  var initialvalues = {
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': ''
  };
  @override
  void dispose() {
    _price.dispose();
    isImageUrl.dispose();
    _desc.dispose();
    _imageNode.dispose();
    super.dispose();
    _imageNode.removeListener(changeImageFocus);
  }

  @override
  void initState() {
    _imageNode.addListener(changeImageFocus);
    // TODO: implement initState
    super.initState();
  }

  void changeImageFocus() {
    if (!_imageNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (!_isinit) {
      return;
    }
    // TODO: implement didChangeDependencies
    final prodId = ModalRoute.of(context)!.settings.arguments;
    // print(prodId);

    if (prodId != null) {
      _editedProduct = Provider.of<Products>(context, listen: false)
          .findById(prodId as String);
      initialvalues = {
        'title': _editedProduct.title,
        'description': _editedProduct.description,
        'price': _editedProduct.price.toString(),
        'imageUrl': '',
      };
      isImageUrl.text = _editedProduct.imageUrl;
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  Future<void> saveForm() async {
    final authData = Provider.of<Auth>(context, listen: false);
    if (!_form.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    _form.currentState!.save();
    if (_editedProduct.id != '') {
      await Provider.of<Products>(context, listen: false).updateProduct(
          _editedProduct.id,
          _editedProduct,
          Provider.of<Auth>(context, listen: false).Token as String);
    } else {
      try {
        await Provider.of<Products>(context, listen: false).addProduct(
          _editedProduct,
          authData.Token as String,
          authData.uId,
        );
      } catch (err) {
        print(err);
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error ocuured!'),
            content: const Text('Something went wrong'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('close'),
              )
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     isLoading = false;
      //   });
      //   // print('done');
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // final isedited = ModalRoute.of(context)!.settings.arguments;
    // print(isedited);

    // print(product);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit products'),
        actions: [
          IconButton(
            onPressed: saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Title',

                        // errorMaxLines: 3,
                      ),
                      initialValue: initialvalues['title'],
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_price),
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: value as String,
                          id: _editedProduct.id,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          isfavorite: _editedProduct.isfavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Title';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _price,
                      initialValue: initialvalues['price'],
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_desc),
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          id: _editedProduct.id,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          price: double.parse(value as String),
                          isfavorite: _editedProduct.isfavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'enter description';
                        }
                        if (double.tryParse(value) == null) {
                          return 'not valid  price';
                        }
                        if (double.parse(value) < 0) {
                          return 'value must be greater than 1';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      focusNode: _desc,
                      maxLines: 3,
                      initialValue: initialvalues['description'],
                      keyboardType: TextInputType.multiline,
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          id: _editedProduct.id,
                          description: value as String,
                          imageUrl: _editedProduct.imageUrl,
                          price: _editedProduct.price,
                          isfavorite: _editedProduct.isfavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'enter description';
                        }
                        if (value.length < 10) {
                          return 'description must be greater than  10 characters';
                        }
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 10, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: isImageUrl.text.isEmpty
                              ? const Text(
                                  'Enter URL',
                                  style: TextStyle(color: Colors.grey),
                                )
                              : FittedBox(
                                  child: Image.network(
                                    isImageUrl.text,
                                    fit: BoxFit.cover,
                                  ),
                                  // fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Enter url'),
                            textInputAction: TextInputAction.done,
                            controller: isImageUrl,
                            focusNode: _imageNode,
                            onFieldSubmitted: (_) => saveForm(),
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                id: _editedProduct.id,
                                description: _editedProduct.description,
                                imageUrl: value as String,
                                price: _editedProduct.price,
                                isfavorite: _editedProduct.isfavorite,
                              );
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'enter URL';
                              }
                              if ((!value.startsWith('http') &&
                                      !value.startsWith('https'))
                                  //  ||
                                  // (!value.endsWith('.jpeg') ||
                                  //     !value.endsWith('.png') ||
                                  //     !value.endsWith('.jpg'))

                                  ) {
                                return 'enter valid url';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
