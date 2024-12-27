class User {
  final String imagePath;
  final String name;
  final String designation;
  final String followers;
  final String following;
  final String orders;
  final String products;
  final String totalRevenue;
  bool isSelected;

  User({
    required this.imagePath,
    required this.name,
    required this.designation,
    required this.followers,
    required this.following,
    required this.orders,
    required this.products,
    required this.totalRevenue,
    required this.isSelected,
  });
}

final List<User> demoUsers = [
  User(
    imagePath: _userProfile.$1,
    name: 'Courtney Henry',
    designation: 'Developer',
    followers: '485',
    following: '187',
    orders: '75',
    products: '25',
    totalRevenue: '\$27,000',
    isSelected: false,
  ),
  User(
    imagePath: _userProfile.$2,
    name: 'Courtney Henry',
    designation: 'UI/UX Designer',
    followers: '980',
    following: '640',
    orders: '32',
    products: '8',
    totalRevenue: '\$8,200',
    isSelected: false,
  ),
  User(
    imagePath: _userProfile.$3,
    name: 'Charlie Brown',
    designation: 'Product Manager',
    followers: '2200',
    following: '1100',
    orders: '78',
    products: '20',
    totalRevenue: '\$24,300',
    isSelected: false,
  ),
  User(
    imagePath: _userProfile.$4,
    name: 'Diana Prince',
    designation: 'UI/UX Designer',
    followers: '1500',
    following: '850',
    orders: '45',
    products: '15',
    totalRevenue: '\$12,750',
    isSelected: false,
  ),
  User(
    imagePath: _userProfile.$5,
    name: 'Evan Williams',
    designation: 'Data Scientist',
    followers: '1350',
    following: '900',
    orders: '67',
    products: '18',
    totalRevenue: '\$18,600',
    isSelected: false,
  ),
  User(
    imagePath: _userProfile.$6,
    name: 'Fiona Green',
    designation: 'Marketing Specialist',
    followers: '1100',
    following: '700',
    orders: '37',
    products: '10',
    totalRevenue: '\$9,400',
    isSelected: false,
  ),
  User(
    imagePath: _userProfile.$7,
    name: 'George Hill',
    designation: 'Sales Manager',
    followers: '1600',
    following: '950',
    orders: '54',
    products: '22',
    totalRevenue: '\$20,500',
    isSelected: false,
  ),
  User(
    imagePath: _userProfile.$8,
    name: 'Hannah Davis',
    designation: 'Content Writer',
    followers: '850',
    following: '600',
    orders: '29',
    products: '9',
    totalRevenue: '\$6,750',
    isSelected: false,
  ),
  User(
    imagePath: _userProfile.$9,
    name: 'Isaac Newton',
    designation: 'Web Developer',
    followers: '2000',
    following: '1050',
    orders: '76',
    products: '25',
    totalRevenue: '\$22,000',
    isSelected: false,
  ),
  User(
    imagePath: _userProfile.$10,
    name: 'Jane Austen',
    designation: 'HR Manager',
    followers: '1250',
    following: '700',
    orders: '42',
    products: '14',
    totalRevenue: '\$11,300',
    isSelected: false,
  ),
];

const (
  String,
  String,
  String,
  String,
  String,
  String,
  String,
  String,
  String,
  String
) _userProfile = (
  'assets/images/static_images/avatars/person_images/person_image_01.jpeg',
  'assets/images/static_images/avatars/person_images/person_image_02.jpeg',
  'assets/images/static_images/avatars/person_images/person_image_03.jpeg',
  'assets/images/static_images/avatars/person_images/person_image_04.jpeg',
  'assets/images/static_images/avatars/person_images/person_image_05.jpeg',
  'assets/images/static_images/avatars/person_images/person_image_06.jpeg',
  'assets/images/static_images/avatars/person_images/person_image_07.jpeg',
  'assets/images/static_images/avatars/person_images/person_image_08.jpeg',
  'assets/images/static_images/avatars/person_images/person_image_09.jpeg',
  'assets/images/static_images/avatars/person_images/person_image_10.jpeg',
);
