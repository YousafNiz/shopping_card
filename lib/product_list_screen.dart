import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badge;
import 'package:shopping_app/cart_model.dart';
import 'package:shopping_app/cart_provider.dart';
import 'package:shopping_app/cart_screen.dart';
import 'package:shopping_app/db_helper.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  DBHelper? dbHelper = DBHelper();
  List<String> productsName = [
    'Mango',
    'Orange',
    'Banana',
    'Peach',
    'Cherry',
    'Grapes',
    'Mixed Fruit',
  ];
  List<String> productsUnits = ['Kg', 'Dozen', 'Dezen','Kg','Kg','Kg','Kg'];
  List<int> productsPrice = [10, 20, 30, 40,50,60,70];
  List<String> productsImage = [
    'https://media.istockphoto.com/id/467328250/photo/mango.jpg?s=1024x1024&w=is&k=20&c=JdUESXRd-kXskA_dYo34UPJVYVK73QGIrcr3fKDPZo4=',
    'https://media.istockphoto.com/id/185284489/photo/orange.jpg?s=1024x1024&w=is&k=20&c=q5eBnLHG9tiKv0Hl2lPVF6nnEYCXQtFYfh0u9mvHwaI=',
    'https://media.istockphoto.com/id/173242750/photo/banana-bunch.jpg?s=1024x1024&w=is&k=20&c=mzktjTrLz_ZdKClKR5btvo5cBY-BJ4h4QOT8LVflB2M=',
    'https://media.istockphoto.com/id/1137630158/photo/single-peach-fruit-with-leaf-isolated-on-white.jpg?s=1024x1024&w=is&k=20&c=2h2ITUKvHTyT5xZZZGjTZPR4vNgPYshd_q3lt3maIG8=',
    'https://media.istockphoto.com/id/533381303/photo/cherry-with-leaves-isolated-on-white-background.jpg?s=1024x1024&w=is&k=20&c=91Fl8anu-m-dHoUfmbzay0PWbPEw1A4C-FMfu6WzrvM=',
    'https://media.istockphoto.com/id/803721418/photo/grape-dark-grape-grapes-with-leaves-isolated-with-clipping-path-full-depth-of-field.jpg?s=1024x1024&w=is&k=20&c=VIdk7rmc7uNl2zyoR6NaV30NPBp4c1JZcxqFQpCLzJ0=',
    'https://media.istockphoto.com/id/182187173/photo/isolated-berries.jpg?s=1024x1024&w=is&k=20&c=Gh2jXfwchErv0KuTElrDNbEvCdNhXNcawT8qTepTF9E='
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
            },
            child: Center(
              child: badge.Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: ((context, value, child) {
                    return Text(value.getCounter().toString(),style: const TextStyle(color: Colors.white),
                  );
                  }), 
                ),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: productsName.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Image(
                                      height: 100,
                                      width: 100,
                                      image: NetworkImage(productsImage[index]),
                                    ),
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(productsName[index],
                                       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(productsUnits[index] +" "+r"$"+ productsPrice[index].toString(),
                                       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 5),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: (){
                                            dbHelper!.insert(
                                              Cart(
                                                id: index,
                                                productId: index.toString(), 
                                                productName: productsName[index].toString(), 
                                                initialPrice: productsPrice[index], 
                                                productPrice: productsPrice[index], 
                                                quantity: 1, 
                                                unitTag: productsUnits[index].toString(),
                                                image: productsImage[index].toString(),
                                              ),                                    
                                            ).then((value){
                                              print('Product is add to cart');
                                              cart.addTotalPrice(double.parse(productsPrice[index].toString()));
                                              cart.addCounter();
                                            }).onError((error, stackTrace){
                                              print(error.toString());
                                            });
                                          },
                                          child: Container(
                                            height: 35,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: const Center(
                                              child: Text('Add to Cart', style: TextStyle(color: Colors.white),)
                                            ),
                                          ),
                                        ),
                                      )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                          ],
                        ),
                      ),
                    );
                  }
                ),
          ),
        ],
      ),
    );
  }
}


