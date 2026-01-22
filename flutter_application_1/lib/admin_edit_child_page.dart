import 'package:flutter/material.dart';

class AdminEditChildPage extends StatefulWidget {
  final Map<String, dynamic> child;
  final Function(Map<String, dynamic>) onSave;
  const AdminEditChildPage({super.key, required this.child, required this.onSave});

  @override
  State<AdminEditChildPage> createState() => _AdminEditChildPageState();
}

class _AdminEditChildPageState extends State<AdminEditChildPage> {
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  final List<String> necessidades = [
    'alimentação',
    'brinquedos',
    'roupa',
    'calçado',
    'livros',
    'material escolar',
  ];
  late Set<String> necessidadesSelecionadas;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.child['nome'] ?? '');
    _descricaoController = TextEditingController(text: widget.child['descricao'] ?? widget.child['detalhes'] ?? '');
    necessidadesSelecionadas = <String>{};
    final necessidadesStr = widget.child['necessidades'] ?? '';
    for (final n in necessidades) {
      if (necessidadesStr.contains(n)) {
        necessidadesSelecionadas.add(n);
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

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
        title: const Text('Editar Card', style: TextStyle(color: Color(0xFFF07167))),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Necessidades', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF07167))),
              ),
            ),
            Wrap(
              spacing: 8,
              children: necessidades.map((n) => FilterChip(
                label: Text(n),
                selected: necessidadesSelecionadas.contains(n),
                selectedColor: const Color(0xFFF07167),
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(color: necessidadesSelecionadas.contains(n) ? Colors.white : const Color(0xFFF07167)),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFFF07167)),
                onSelected: (sel) {
                  setState(() {
                    if (sel) {
                      necessidadesSelecionadas.add(n);
                    } else {
                      necessidadesSelecionadas.remove(n);
                    }
                  });
                },
              )).toList(),
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  final updated = Map<String, dynamic>.from(widget.child);
                  updated['nome'] = _nomeController.text;
                  updated['descricao'] = _descricaoController.text;
                  updated['necessidades'] = necessidadesSelecionadas.join('; ');
                  widget.onSave(updated);
                  Navigator.of(context).pop();
                },
                child: const Text('Guardar', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
