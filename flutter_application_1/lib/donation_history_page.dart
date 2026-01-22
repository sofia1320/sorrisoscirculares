import 'package:flutter/material.dart';
import 'user_home_page.dart';
import 'user_profile_page.dart';

class Donation {
  final String childName;
  final DateTime dateTime;
  final DonationStatus status;

  Donation({required this.childName, required this.dateTime, required this.status});
}

enum DonationStatus { doacao, pendente, confirmar, sucesso }

class DonationStatusUtils {
  static String label(DonationStatus status) {
    switch (status) {
      case DonationStatus.doacao:
        return 'Doação';
      case DonationStatus.pendente:
        return 'Pendente';
      case DonationStatus.confirmar:
        return 'Confirmar';
      case DonationStatus.sucesso:
        return 'Sucesso';
    }
  }
}

class DonationHistoryPage extends StatefulWidget {
  final List<Donation> donations;
  const DonationHistoryPage({super.key, required this.donations});

  @override
  State<DonationHistoryPage> createState() => _DonationHistoryPageState();
}

class _DonationHistoryPageState extends State<DonationHistoryPage> {
  late List<Donation> _donations;

  @override
  void initState() {
    super.initState();
    _donations = List<Donation>.from(widget.donations);
  }

  void _removeDonation(Donation donation) {
    setState(() {
      _donations.remove(donation);
    });
  }

  @override
  Widget build(BuildContext context) {
    final sorted = List<Donation>.from(_donations)
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCDC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: null,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFFF07167)),
        toolbarHeight: 80,
        flexibleSpace: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Image.asset(
                'assets/images/logo preto.png',
                fit: BoxFit.contain,
                width: 180,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            ...sorted.map((donation) => DonationCard(
              donation: donation,
              onCancel: () => _removeDonation(donation),
            )),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: const _UserBottomNav(),
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
                  MaterialPageRoute(builder: (_) => UserHomePage()),
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
                // Já está na página de consulta, não faz nada
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

class DonationCard extends StatelessWidget {
  final Donation donation;
  final VoidCallback? onCancel;
  const DonationCard({super.key, required this.donation, this.onCancel});

  Color _barColor(DonationStatus status) {
    switch (status) {
      case DonationStatus.doacao:
        return const Color(0xFFFDE0C3);
      case DonationStatus.pendente:
        return const Color(0xFFF07167);
      case DonationStatus.confirmar:
        return const Color(0xFFFDE0C3);
      case DonationStatus.sucesso:
        return const Color(0xFFFDE0C3);
    }
  }

  int _statusIndex(DonationStatus status) {
    switch (status) {
      case DonationStatus.doacao:
        return 0;
      case DonationStatus.pendente:
        return 1;
      case DonationStatus.confirmar:
        return 2;
      case DonationStatus.sucesso:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusIdx = _statusIndex(donation.status);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBE5),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                donation.childName,
                style: const TextStyle(
                  fontFamily: 'WildlySans',
                  fontSize: 20,
                  color: Color(0xFF222222),
                  fontWeight: FontWeight.bold,
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: Color(0xFF222222)),
                onSelected: (value) {
                  if (value == 'cancel') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFFFDFCDC),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        title: const Text('Cancelar Doação', style: TextStyle(color: Color(0xFFF07167), fontWeight: FontWeight.bold)),
                        content: const Text('Tem a certeza que pretende cancelar esta doação?', style: TextStyle(color: Color(0xFF222222))),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Não', style: TextStyle(color: Color(0xFFF07167))),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF07167),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                              if (onCancel != null) onCancel!();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Doação cancelada.')),
                              );
                            },
                            child: const Text('Sim', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                  } else if (value == 'institution') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFFFDFCDC),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        title: const Text('Informações da Instituição', style: TextStyle(color: Color(0xFFF07167), fontWeight: FontWeight.bold)),
                        content: const Text(
                          'MUNDOS DE VIDA\nRua da Quinta da Serra, 101 Lousado (Matosinhos)\nEmail: mundosdevida@mundosdevida.pt\nTelefone: 252499010',
                          style: TextStyle(color: Color(0xFF222222)),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Fechar', style: TextStyle(color: Color(0xFFF07167))),
                          ),
                        ],
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'cancel',
                    child: Text('Cancelar doação'),
                  ),
                  const PopupMenuItem(
                    value: 'institution',
                    child: Text('Ver instituição'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Dia ${donation.dateTime.day.toString().padLeft(2, '0')}/'
            '${donation.dateTime.month.toString().padLeft(2, '0')} às '
            '${donation.dateTime.hour.toString().padLeft(2, '0')}:${donation.dateTime.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(
              fontFamily: 'WildlySans',
              fontSize: 14,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final s in DonationStatus.values)
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        DonationStatusUtils.label(s),
                        style: TextStyle(
                          fontFamily: 'WildlySans',
                          fontSize: 13,
                          color: statusIdx == _statusIndex(s)
                              ? const Color(0xFFF07167)
                              : const Color(0xFF222222),
                          fontWeight: statusIdx == _statusIndex(s)
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Icon(
                        Icons.circle,
                        size: 6,
                        color: statusIdx == _statusIndex(s)
                            ? const Color(0xFFF07167)
                            : const Color(0xFFFDE0C3),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: _barColor(s),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        width: statusIdx == _statusIndex(s) ? 38 : 24,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
