import 'package:flutter/material.dart';

class AdminAddChildOverlay extends StatefulWidget {
  final void Function(Map<String, dynamic>) onAdd;
  const AdminAddChildOverlay({super.key, required this.onAdd});

  @override
  State<AdminAddChildOverlay> createState() => _AdminAddChildOverlayState();
}

class _AdminAddChildOverlayState extends State<AdminAddChildOverlay> {
  final _formKey = GlobalKey<FormState>();
  String? nome;
  String? categoria;
  String? detalhes;
  String? imagem;
  final List<String> categorias = [
    'Bebés (0-2 anos)',
    'Criança (3-9 anos)',
    'Pré-Adolescente (10-12 anos)',
    'Adolescente (13-17 anos)',
  ];
  final List<String> necessidades = [
    'alimentação',
    'brinquedos',
    'roupa',
    'calçado',
    'livros',
    'material escolar',
  ];
  final Set<String> necessidadesSelecionadas = {};

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: Container(
            width: 340,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Adicionar Criança', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFF07167))),
                    const SizedBox(height: 24),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (v) => v == null || v.isEmpty ? 'Insira o nome' : null,
                      onSaved: (v) => nome = v,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Categoria'),
                      items: categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      validator: (v) => v == null ? 'Selecione a categoria' : null,
                      onChanged: (v) => categoria = v,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Detalhes'),
                      validator: (v) => v == null || v.isEmpty ? 'Insira os detalhes' : null,
                      onSaved: (v) => detalhes = v,
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
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Imagem (caminho local ex: assets/images/1.jpg)'),
                      validator: (v) => v == null || v.isEmpty ? 'Insira o caminho da imagem' : null,
                      onSaved: (v) => imagem = v,
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancelar', style: TextStyle(color: Color(0xFFF07167))),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF07167),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              widget.onAdd({
                                'nome': nome!,
                                'categoria': categoria!,
                                'detalhes': detalhes!,
                                'imagem': imagem!,
                                'necessidades': necessidadesSelecionadas.join('; '),
                                'ativo': true,
                              });
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('Adicionar', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
