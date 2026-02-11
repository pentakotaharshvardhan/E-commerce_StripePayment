class ProductItem {
  final String name;
  final String price;
  final String imagePath;

  ProductItem({required this.name, required this.price, required this.imagePath});
}

// Static List
final List<ProductItem> myProducts = [
  ProductItem(name: "Pro Headphones", price: "\Rs.250", imagePath: "assests/headphones.glb"),
  ProductItem(name: "Gaming Mouse", price: "\Rs.80", imagePath: "assests/mouse.glb"),
  ProductItem(name: "Mechanical Keyboard", price: "\Rs.150", imagePath: "assests/keyboard.glb"),
];