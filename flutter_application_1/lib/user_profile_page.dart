import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart'; 
import 'user_home_page.dart';
import 'donation_history_page.dart';
import 'edit_profile_page.dart';
import 'main.dart';

class UserProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String imagePath;

  const UserProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.imagePath,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFFF07167)),
                title: const Text('Escolher da Galeria'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _pickedImage = File(pickedFile.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFF07167)),
                title: const Text('Tirar Foto'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _pickedImage = File(pickedFile.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCDC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              Center(
                child: Image.asset(
                  'assets/images/logo preto.png',
                  width: 220,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: _pickedImage != null
                        ? FileImage(_pickedImage!)
                        : AssetImage(widget.imagePath) as ImageProvider,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.camera_alt, color: Color(0xFFF07167), size: 22),
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                widget.name,
                style: const TextStyle(
                  fontFamily: 'WildlySans',
                  fontSize: 24,
                  color: Colors.black,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _ProfileInfoRow(label: 'Email', value: widget.email),
                    _ProfileInfoRow(label: 'Password', value: widget.password),
                    _ProfileInfoRow(label: 'Telefone', value: widget.phone),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF07167),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text('Editar Perfil', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EditProfilePage(
                            name: widget.name,
                            email: widget.email,
                            password: widget.password,
                            phone: widget.phone,
                            imagePath: widget.imagePath,
                          ),
                        ),
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    ),
                    icon: const Icon(Icons.delete, color: Colors.white),
                    label: const Text('Apagar Perfil', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xFFFDFCDC),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          title: const Text('Apagar Perfil', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                          content: const Text('Tem a certeza que pretende apagar o perfil? Esta ação não pode ser revertida.', style: TextStyle(color: Color(0xFF222222))),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancelar', style: TextStyle(color: Color(0xFFF07167))),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Perfil apagado.')),
                                );
                                // Redireciona para página inicial, removendo todas as rotas anteriores
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (_) => const UserTypeSelectionPage()),
                                  (route) => false,
                                );
                              },
                              child: const Text('Apagar', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _UserBottomNav(),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
        const Divider(),
      ],
    );
  }
}

// Reutilize o _UserBottomNav do user_home_page.dart
class _UserBottomNav extends StatelessWidget {
  const _UserBottomNav();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: double.infinity,
      child: BottomAppBar(
        color: const Color(0xFFFDE0C3),
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const UserHomePage()),
                  (route) => false,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home, color: Color(0xFFF07167)),
                  Text('Feed', style: TextStyle(color: Color(0xFFF07167), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => DonationHistoryPage(donations: const [])),
                  (route) => false,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today, color: Color(0xFFF07167)),
                  Text('Agenda', style: TextStyle(color: Color(0xFFF07167))),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                // Já está nesta página
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, color: Color(0xFFF07167)),
                  Text('Perfil', style: TextStyle(color: Color(0xFFF07167))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


