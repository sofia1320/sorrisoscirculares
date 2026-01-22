import 'package:flutter/material.dart';
import 'schedule_donation_page.dart';
import 'donation_history_page.dart';
import 'user_profile_page.dart';

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
                  _CategoryLabel('Bebé (0-2 anos)'),
                  _UserCard(
                    image: 'assets/images/2.jpg',
                    name: 'ANA CAROLINA',
                    details: 'Roupa e Brinquedos',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => UserDetailPage(
                            name: 'ANA CAROLINA',
                            image: 'assets/images/2.jpg',
                            details: 'Roupa e Brinquedos',
                          ),
                        ),
                      );
                    },
                  ),
                  _UserCard(
                    image: 'assets/images/1.jpg',
                    name: 'LUCAS ANDRADE',
                    details: 'Alimentação e Roupa',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => UserDetailPage(
                            name: 'LUCAS ANDRADE',
                            image: 'assets/images/1.jpg',
                            details: 'Alimentação e Roupa',
                          ),
                        ),
                      );
                    },
                  ),
                  _CategoryLabel('Criança (3-9 anos)'),
                  _UserCard(
                    image: 'assets/images/3.jpg',
                    name: 'MARIANA COSTA',
                    details: 'Calçado e Brinquedos',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => UserDetailPage(
                            name: 'MARIANA COSTA',
                            image: 'assets/images/3.jpg',
                            details: 'Calçado e Brinquedos',
                          ),
                        ),
                      );
                    },
                  ),
                  _UserCard(
                    image: 'assets/images/4.jpg',
                    name: 'ISABELA RIBEIRO',
                    details: 'Livros e Roupa',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => UserDetailPage(
                            name: 'ISABELA RIBEIRO',
                            image: 'assets/images/4.jpg',
                            details: 'Livros e Roupa',
                          ),
                        ),
                      );
                    },
                  ),
                  _CategoryLabel('Pré-Adolescente (10-12 anos)'),
                  _UserCard(
                    image: 'assets/images/2.jpg',
                    name: 'SOFIA MARTINS',
                    details: 'Material Escolar e Brinquedos',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => UserDetailPage(
                            name: 'SOFIA MARTINS',
                            image: 'assets/images/2.jpg',
                            details: 'Material Escolar e Brinquedos',
                          ),
                        ),
                      );
                    },
                  ),
                  _CategoryLabel('Adolescente (13-17 anos)'),
                  _UserCard(
                    image: 'assets/images/3.jpg',
                    name: 'JOÃO SILVA',
                    details: 'Tecnologia e Desporto',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => UserDetailPage(
                            name: 'JOÃO SILVA',
                            image: 'assets/images/3.jpg',
                            details: 'Tecnologia e Desporto',
                          ),
                        ),
                      );
                    },
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
  final VoidCallback? onTap;
  const _UserCard({required this.image, required this.name, required this.details, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.asset(
                  image,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
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
            ),
          ],
        ),
      ),
    );
  }
}

// Página de detalhes do utilizador
class UserDetailPage extends StatelessWidget {
  final String name;
  final String image;
  final String details;
    const UserDetailPage({required this.name, required this.image, required this.details, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCDC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF07167)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Center(
              child: Image.asset(
                'assets/images/logo preto.png',
                fit: BoxFit.contain,
                width: 220,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF07167), Color(0xFFF3B9A9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(48),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                  child: Column(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontFamily: 'WildlySans',
                          fontSize: 28,
                          color: Colors.white,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      CircleAvatar(
                        radius: 48,
                        backgroundImage: AssetImage(image),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'A Ana Carolina é uma bebé de 1 ano cheia de curiosidade, que se encanta com músicas e livros de imagens. Está a dar os seus primeiros passos e adora descobrir o mundo à sua volta.',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Text(
                              'Neste momento, precisa de:',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'roupa de bebé (12–18 meses)\nbrinquedos sensoriais\nlivros',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'que a ajudem a estimular o seu desenvolvimento',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF07167),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            elevation: 4,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return Dialog(
                                  backgroundColor: const Color(0xFFFDFCDC),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(48),
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.85,
                                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 0,
                                          left: 0,
                                          child: GestureDetector(
                                            onTap: () => Navigator.of(context).pop(),
                                            child: const Text('X', style: TextStyle(fontSize: 24, color: Colors.black)),
                                          ),
                                        ),
                                        Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 8),
                                              const Text(
                                                'Instituição',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 8),
                                              const Text(
                                                'MUNDOS DE VIDA',
                                                style: TextStyle(
                                                  fontFamily: 'WildlySans',
                                                  fontSize: 28,
                                                  color: Colors.black,
                                                  letterSpacing: 2,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 24),
                                              const Text(
                                                'ENDEREÇO',
                                                style: TextStyle(
                                                  fontFamily: 'WildlySans',
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  letterSpacing: 2,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 4),
                                              const Text(
                                                'Rua da Quinta da Serra, 101 Lousado (Matosinhos)',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 16),
                                              const Text(
                                                'EMAIL',
                                                style: TextStyle(
                                                  fontFamily: 'WildlySans',
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  letterSpacing: 2,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 4),
                                              const Text(
                                                'mundosdevida@mundosdevida.pt',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 16),
                                              const Text(
                                                'TELEFONE',
                                                style: TextStyle(
                                                  fontFamily: 'WildlySans',
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  letterSpacing: 2,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 4),
                                              const Text(
                                                '252499010',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: const Text(
                            'SOBRE A INSTITUIÇÃO',
                            style: TextStyle(
                              fontFamily: 'WildlySans',
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFDE0C3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            elevation: 4,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ScheduleDonationPage(childName: 'ANA CAROLINA'),
                              ),
                            );
                          },
                          child: const Text(
                            'DOAR',
                            style: TextStyle(
                              fontFamily: 'WildlySans',
                              color: Color(0xFFF07167),
                              fontSize: 18,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  }


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
                // Aqui pode adicionar navegação para o perfil futuramente
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const UserProfilePage(
                      name: 'NOME SOBRENOME',
                      email: 'email utilizador',
                      password: 'password utilizador',
                      phone: '999999999',
                      imagePath: 'assets/images/2.jpg',
                    ),
                  ),
                );
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
