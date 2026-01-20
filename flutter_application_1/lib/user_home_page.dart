import 'package:flutter/material.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFFDFCDC),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: Image.asset(
                'assets/images/logo preto.png',
                fit: BoxFit.contain,
                width: 220,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDE0C3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 8),
                            Text('Pesquisar', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE0C3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.tune, color: Color(0xFFF07167)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  _CategoryLabel('Bebés (0-2 anos)'),
                  _UserCard(
                    image: 'assets/images/2.jpg',
                    name: 'ANA CAROLINA',
                    details: 'Roupa e Brinquedos',
                  ),
                  _UserCard(
                    image: 'assets/images/1.jpg',
                    name: 'LUCAS ANDRADE',
                    details: 'Alimentação e Roupa',
                  ),
                  _CategoryLabel('Criança (3-9 anos)'),
                  _UserCard(
                    image: 'assets/images/3.jpg',
                    name: 'MARIANA COSTA',
                    details: 'Calçado e Brinquedos',
                  ),
                  _UserCard(
                    image: 'assets/images/4.jpg',
                    name: 'ISABELA RIBEIRO',
                    details: 'Livros e Roupa',
                  ),
                  _CategoryLabel('Pré-Adolescente (10-12 anos)'),
                  _UserCard(
                    image: 'assets/images/2.jpg',
                    name: 'SOFIA MARTINS',
                    details: 'Material Escolar e Brinquedos',
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _UserBottomNav(),
    );
  }
}

class _CategoryLabel extends StatelessWidget {
  final String text;
  const _CategoryLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFF07167),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final String image;
  final String name;
  final String details;
  const _UserCard({required this.image, required this.name, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF07167), Color(0xFFF3B9A9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 6),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.network(
              image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'WildlySans',
                    fontSize: 20,
                    color: Colors.white,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  details,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserBottomNav extends StatelessWidget {
  const _UserBottomNav();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xFFFDE0C3),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home, color: Color(0xFFF07167)),
                Text('Feed', style: TextStyle(color: Color(0xFFF07167), fontWeight: FontWeight.bold)),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, color: Color(0xFFF07167)),
                Text('Agenda', style: TextStyle(color: Color(0xFFF07167))),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, color: Color(0xFFF07167)),
                Text('Perfil', style: TextStyle(color: Color(0xFFF07167))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
