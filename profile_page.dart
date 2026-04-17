import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), 
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDE7F6),
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          child: Text("Go to Profile"),
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstName = "Admin";
  String lastName = "Name";
  String phone = "0500000000";
  String email = "admin@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDE7F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              // 🔹 Header
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Profile",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),

              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.deepPurple[100],
                      child: Icon(Icons.person, color: Colors.deepPurple),
                    ),
                    SizedBox(width: 15),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$firstName $lastName",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(email),
                        ],
                      ),
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPage(
                              firstName: firstName,
                              lastName: lastName,
                              phone: phone,
                              email: email,
                            ),
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            firstName = result["firstName"];
                            lastName = result["lastName"];
                            phone = result["phone"];
                            email = result["email"];
                          });
                        }
                      },
                      child: Text("Edit"),
                    )
                  ],
                ),
              ),

              SizedBox(height: 20),

              Divider(),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Personal Information",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 10),

              // 🔹 Floating Labels
              buildInfo("First Name", firstName),
              buildInfo("Last Name", lastName),
              buildInfo("Phone Number", phone),
              buildInfo("Email Address", email),

              Spacer(),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                onPressed: () {},
                child: Text("Log Out"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfo(String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          floatingLabelStyle: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class EditPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;

  EditPage({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
  });

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController firstName;
  late TextEditingController lastName;
  late TextEditingController phone;
  late TextEditingController email;

  @override
  void initState() {
    super.initState();
    firstName = TextEditingController(text: widget.firstName);
    lastName = TextEditingController(text: widget.lastName);
    phone = TextEditingController(text: widget.phone);
    email = TextEditingController(text: widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDE7F6),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              buildField(firstName, "First Name"),
              buildField(lastName, "Last Name"),
              buildField(phone, "Phone Number"),
              buildField(email, "Email Address"),

              Spacer(),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, {
                      "firstName": firstName.text,
                      "lastName": lastName.text,
                      "phone": phone.text,
                      "email": email.text,
                    });
                  }
                },
                child: Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(TextEditingController controller, String label) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This field is required";
          }

          if (label == "Email Address" &&
              !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
            return "Enter valid email";
          }

          if (label == "Phone Number" &&
              !RegExp(r'^05\d{8}$').hasMatch(value)) {
            return "Phone must start with 05 and be 10 digits";
          }

          return null;
        },
      ),
    );
  }
}
