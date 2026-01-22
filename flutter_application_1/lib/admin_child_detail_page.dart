import 'package:flutter/material.dart';


import 'admin_edit_child_page.dart';

class AdminChildDetailPage extends StatelessWidget {
  final Map<String, dynamic> child;
  final Function(Map<String, dynamic>)? onEdit;
  final Function()? onDelete;
  const AdminChildDetailPage({super.key, required this.child, this.onEdit, this.onDelete});

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
                        child['nome'],
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
                        backgroundImage: AssetImage(child['imagem']),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              child['detalhes'] ?? 'Sem descrição.',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
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
                              (child['necessidades'] ?? '').isNotEmpty
                                  ? child['necessidades']
                                  : 'Sem necessidades definidas',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFDE0C3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              elevation: 4,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                            ),
                            onPressed: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => AdminEditChildPage(
                                    child: child,
                                    onSave: (updatedChild) {
                                      if (onEdit != null) onEdit!(updatedChild);
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, color: Color(0xFFF07167)),
                            label: const Text(
                              'Editar',
                              style: TextStyle(
                                fontFamily: 'WildlySans',
                                color: Color(0xFFF07167),
                                fontSize: 18,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              elevation: 4,
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: const Color(0xFFFDFCDC),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  title: const Text('Apagar Card', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                                  content: const Text('Tem a certeza que pretende apagar este card? Esta ação não pode ser revertida.', style: TextStyle(color: Color(0xFF222222))),
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
                                        if (onDelete != null) onDelete!();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Apagar', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete, color: Colors.white),
                            label: const Text(
                              'Apagar',
                              style: TextStyle(
                                fontFamily: 'WildlySans',
                                color: Colors.white,
                                fontSize: 18,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ],
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
