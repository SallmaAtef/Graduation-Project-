import 'package:flutter/material.dart';
 
class RoundedAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
 
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
 
class AddressData {
  final String address;
  final String city;
  final String postalCode;
 
  AddressData(
      {required this.address, required this.city, required this.postalCode});
}
 
class AddAddressPage extends StatefulWidget {
  static const String id = 'AddAddressPage';
  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}
 
class _AddAddressPageState extends State<AddAddressPage> {
  List<AddressData> addresses = [];
  TextEditingController _addressController = TextEditingController();
  TextEditingController cityControlle = TextEditingController();
  TextEditingController postalCodeControlle = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0),
        child: ClipPath(
          clipper: RoundedAppBarClipper(),
          child: Container(
            height: 200,
            color: Colors.blue,
            child: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                'Addresses',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: addresses.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(addresses[index].address),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editAddress(addresses[index]);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteAddress(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddaddressPage(),
            ),
          ).then((addressData) {
            if (addressData != null) {
              setState(() {
                addresses.add(addressData);
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
 
  void _editAddress(AddressData addressData) {
    _addressController.text = addressData.address;
    cityControlle.text = addressData.city;
    postalCodeControlle.text = addressData.postalCode;
 
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Enter new Address',
                ),
              ),
              TextField(
                controller: cityControlle,
                decoration: InputDecoration(
                  labelText: 'Enter City',
                ),
              ),
              TextField(
                controller: postalCodeControlle,
                decoration: InputDecoration(
                  labelText: 'Enter Postal Code',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  // Create a new AddressData object with the updated values
                  addressData = AddressData(
                    address: _addressController.text,
                    city: cityControlle.text,
                    postalCode: postalCodeControlle.text,
                  );
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
 
  void _deleteAddress(int index) {
    setState(() {
      addresses.removeAt(index);
    });
  }
}
 
class AddaddressPage extends StatelessWidget {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController cityControlle = TextEditingController();
  final TextEditingController postalCodeControlle = TextEditingController();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: ClipPath(
          clipper: RoundedAppBarClipper(),
          child: Container(
            height: 100,
            color: Colors.blue,
            child: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                'Add Address',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Enter New Address',
              ),
            ),
            TextField(
              controller: cityControlle,
              decoration: InputDecoration(
                labelText: 'Enter City',
              ),
            ),
            TextField(
              controller: postalCodeControlle,
              decoration: InputDecoration(
                labelText: 'Enter Postal Code',
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_addressController.text.isNotEmpty &&
                    cityControlle.text.isNotEmpty &&
                    postalCodeControlle.text.isNotEmpty) {
                  AddressData addressData = AddressData(
                    address: _addressController.text,
                    city: cityControlle.text,
                    postalCode: postalCodeControlle.text,
                  );
                  Navigator.of(context).pop(addressData);
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}