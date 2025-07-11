import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify/Screens/Loginpage.dart';
import '../Themes/mode button.dart';
import '../Themes/theme button.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = '';
  String email = '';
  String number = '';
  int id = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final sharedPref = await SharedPreferences.getInstance();
    setState(() {
      name = sharedPref.getString('name') ?? '';
      email = sharedPref.getString('email') ?? '';
      number = sharedPref.getString('number') ?? '';
      id = sharedPref.getInt('id') ?? 0;
    });
  }

  Future<void> _logout() async {
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout Successful')),
      );
      await Future.delayed(const Duration(milliseconds: 300));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
      );
    }
  }

  Widget _infoTile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.grey.shade600),
        ),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _optionTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? null
              : LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                      child: const Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text("ID: $id", style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              _infoTile("Email", email, Icons.email),
              _infoTile("Phone", number, Icons.phone),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const ThemeButton(),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),

              _optionTile("Privacy Policies", Icons.shield_outlined, () {}),
              _optionTile("Terms & Conditions", Icons.book_outlined, () {}),
              _optionTile("About App", Icons.info_outline, () {}),
              _optionTile("Help & Support", Icons.help_outline, () {}),

              const SizedBox(height: 30),
              Center(
                child: Text("App version 1.0.0",
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
              ),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
