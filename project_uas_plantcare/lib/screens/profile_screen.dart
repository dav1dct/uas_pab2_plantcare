import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart'; // Import the LoginScreen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSignedIn = false;
  String fullName = '';
  String userName = '';
  int favoritePlantCount = 0;
  String _loggedInUser = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoritePlants = prefs.getStringList('favoritePlants') ?? [];
    setState(() {
      _loggedInUser = prefs.getString('loggedInUser') ?? 'Guest';
      userName = prefs.getString('userName') ?? _loggedInUser;
      fullName = prefs.getString('fullName') ?? _loggedInUser;
      favoritePlantCount = favoritePlants.length;
    });
  }

  void signIn() {
    setState(() {
      isSignedIn = true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void signOut() {
    setState(() {
      isSignedIn = false;
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.deepPurple,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.deepPurple,
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage('images/placeholder_image.png'),
                            ),
                          ),
                          if (isSignedIn)
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.deepPurple[50],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.deepPurple[100]),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Row(
                          children: const [
                            Icon(Icons.lock, color: Colors.amber),
                            SizedBox(width: 8),
                            Text(
                              'Pengguna',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ': $userName',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.deepPurple[100]),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Row(
                          children: const [
                            Icon(Icons.person, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              'Nama',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ': $fullName',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      if (isSignedIn) const Icon(Icons.edit),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Divider(color: Colors.deepPurple[100]),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Row(
                          children: const [
                            Icon(Icons.favorite, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Favorit',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ': $favoritePlantCount',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.deepPurple[100]),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Row(
                          children: const [
                            Icon(Icons.email, color: Colors.green),
                            SizedBox(width: 8),
                            Text(
                              'Email',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ': $_loggedInUser',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(color: Colors.deepPurple[100]),
                  const SizedBox(height: 20),
                  // Bagian tombol
                  TextButton(
                    onPressed: signOut,
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}