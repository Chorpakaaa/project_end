class Product{
   String product_name, product_image;

   Product({ 
       required this.product_image,
       required this.product_name,
   });
    @override
  String toString() {
    return 'Product { product_image: $product_image, product_name: $product_name }';
  }
}
class Productsell{
   String category, name , image, price;

   Productsell({ 
       required this.category,
       required this.name,
       required this.image,
       required this.price,
   });
}