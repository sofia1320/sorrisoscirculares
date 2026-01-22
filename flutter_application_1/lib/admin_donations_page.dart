import 'package:flutter/material.dart';

class AdminDonationsPage extends StatefulWidget {
  const AdminDonationsPage({super.key});

  @override
  State<AdminDonationsPage> createState() => _AdminDonationsPageState();
}

class _AdminDonationsPageState extends State<AdminDonationsPage> {
  final List<Map<String, dynamic>> donations = [
    {
      'doador': 'João Silva',
      'email': 'joao@email.com',
      'telefone': '912345678',
      'criança': 'ANA CAROLINA',
      'categoria': 'Bebés (0-2 anos)',
      'necessidades': 'roupa; brinquedos',
      'detalhes': 'Roupa e Brinquedos',
      'data': '2026-01-21',
      'estado': 'pendente',
    },
    {
      'doador': 'Maria Costa',
      'email': 'maria@email.com',
      'telefone': '934567890',
      'criança': 'LUCAS ANDRADE',
      'categoria': 'Bebés (0-2 anos)',
      'necessidades': 'alimentação',
      'detalhes': 'Alimentação e Roupa',
      'data': '2026-01-20',
      'estado': 'pendente',
    },
  ];

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
        title: const Text('Pedidos de Doação', style: TextStyle(color: Color(0xFFF07167))),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemCount: donations.length,
        itemBuilder: (context, i) {
          final d = donations[i];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            elevation: 4,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Doação para: ${d['criança']}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFF07167)),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: d['estado'] == 'aceite' ? Colors.green[100] : d['estado'] == 'recusada' ? Colors.red[100] : Colors.orange[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      d['estado'].toUpperCase(),
                      style: TextStyle(
                        color: d['estado'] == 'aceite' ? Colors.green[800] : d['estado'] == 'recusada' ? Colors.red[800] : Colors.orange[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Necessidades: ${d['necessidades']}', style: const TextStyle(color: Color(0xFFF07167)), softWrap: true, overflow: TextOverflow.visible),
                  const SizedBox(height: 12),
                  Text('Doador: ${d['doador']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Email: ${d['email']}'),
                  Text('Telefone: ${d['telefone']}'),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[400],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        onPressed: d['estado'] == 'aceite'
                            ? null
                            : () {
                                setState(() {
                                  d['estado'] = 'aceite';
                                });
                              },
                        icon: const Icon(Icons.check, color: Colors.white),
                        label: const Text('Aceitar', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        onPressed: d['estado'] == 'recusada'
                            ? null
                            : () {
                                setState(() {
                                  d['estado'] = 'recusada';
                                });
                              },
                        icon: const Icon(Icons.close, color: Colors.white),
                        label: const Text('Recusar', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
