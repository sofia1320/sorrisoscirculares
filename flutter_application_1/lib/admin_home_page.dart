import 'package:flutter/material.dart';
import 'admin_child_detail_page.dart';
import 'admin_add_child_overlay.dart';
import 'admin_donations_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  bool showAtivos = true;
  bool selectionMode = false;
  final Set<Map<String, dynamic>> selectedToHide = {};

  // Exemplo de dados (depois substituir por dados do backend)
  final List<Map<String, dynamic>> children = [
    {
      'nome': 'ANA CAROLINA',
      'categoria': 'Bebés (0-2 anos)',
      'detalhes': 'Roupa e Brinquedos',
      'imagem': 'assets/images/1.jpg',
      'ativo': true,
    },
    {
      'nome': 'LUCAS ANDRADE',
      'categoria': 'Bebés (0-2 anos)',
      'detalhes': 'Alimentação e Roupa',
      'imagem': 'assets/images/2.jpg',
      'ativo': true,
    },
    {
      'nome': 'MARIANA COSTA',
      'categoria': 'Criança (3-9 anos)',
      'detalhes': 'Calçado e Brinquedos',
      'imagem': 'assets/images/1.jpg',
      'ativo': true,
    },
    {
      'nome': 'ISABELA RIBEIRO',
      'categoria': 'Criança (3-9 anos)',
      'detalhes': 'Livros e Roupa',
      'imagem': 'assets/images/2.jpg',
      'ativo': true,
    },
    {
      'nome': 'SOFIA MARTINS',
      'categoria': 'Pré-Adolescente (10-12 anos)',
      'detalhes': 'Material Escolar e Brinquedos',
      'imagem': 'assets/images/3.jpg',
      'ativo': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final ativos = children.where((c) => c['ativo'] == true).toList();
    final ocultos = children.where((c) => c['ativo'] == false).toList();
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCDC),
      body: SafeArea(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TabButton(
                  text: 'ATIVOS',
                  selected: showAtivos && !selectionMode,
                  onTap: () => setState(() {
                    showAtivos = true;
                    selectionMode = false;
                    selectedToHide.clear();
                  }),
                ),
                const SizedBox(width: 16),
                _TabButton(
                  text: 'OCULTOS',
                  selected: !showAtivos && !selectionMode,
                  onTap: () => setState(() {
                    showAtivos = false;
                    selectionMode = false;
                    selectedToHide.clear();
                  }),
                ),
              ],
            ),
            if (selectionMode)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF07167),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  ),
                  onPressed: selectedToHide.isEmpty
                      ? null
                      : () {
                          setState(() {
                            for (var c in selectedToHide) {
                              c['ativo'] = false;
                            }
                            selectionMode = false;
                            selectedToHide.clear();
                          });
                        },
                  icon: const Icon(Icons.visibility_off, color: Colors.white),
                  label: const Text('Ocultar selecionados', style: TextStyle(color: Colors.white)),
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ..._buildCategorySection(
                    (!showAtivos && !selectionMode)
                        ? ocultos
                        : ativos,
                    selectionMode: selectionMode,
                    selectedToHide: selectedToHide,
                    onSelect: (c, selected) {
                      setState(() {
                        if (selected) {
                          selectedToHide.add(c);
                        } else {
                          selectedToHide.remove(c);
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _AdminBottomNav(
        selectionMode: selectionMode,
        onSelectHide: () {
          setState(() {
            if (!selectionMode) {
              showAtivos = true;
              selectionMode = true;
            } else {
              selectionMode = false;
              selectedToHide.clear();
            }
          });
        },
        onAtivos: () => setState(() {
          showAtivos = true;
          selectionMode = false;
          selectedToHide.clear();
        }),
        onOcultos: () => setState(() {
          showAtivos = false;
          selectionMode = false;
          selectedToHide.clear();
        }),
        showAtivos: showAtivos,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _AdminFabMenu(),
    );
  }

  List<Widget> _buildCategorySection(
    List<Map<String, dynamic>> list, {
    bool selectionMode = false,
    Set<Map<String, dynamic>>? selectedToHide,
    void Function(Map<String, dynamic>, bool)? onSelect,
  }) {
    // Categorias fixas
    final fixedCategories = [
      'Bebés (0-2 anos)',
      'Criança (3-9 anos)',
      'Pré-Adolescente (10-12 anos)',
      'Adolescente (13-17 anos)',
    ];
    return fixedCategories.map((cat) {
      final catChildren = list.where((c) => c['categoria'] == cat).toList();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              cat,
              style: const TextStyle(
                color: Color(0xFFF07167),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          if (catChildren.isEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
              child: Text(
                'Sem crianças nesta categoria',
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 14),
              ),
            ),
          ...catChildren.map((c) => _ChildCard(
                child: c,
                selectionMode: selectionMode,
                selected: selectedToHide?.contains(c) ?? false,
                onSelect: onSelect,
                onEdit: (updatedChild) {
                  setState(() {
                    final idx = children.indexOf(c);
                    if (idx != -1) children[idx] = updatedChild;
                  });
                },
                onDelete: () {
                  setState(() {
                    children.remove(c);
                  });
                },
              )),
        ],
      );
    }).toList();
  }
}

class _TabButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _TabButton({required this.text, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF07167) : Colors.transparent,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFFF07167), width: 2),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFFF07167),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

// Move _ChildCard to top-level (not nested in any other class)
class _ChildCard extends StatelessWidget {
  final Map<String, dynamic> child;
  final bool selectionMode;
  final bool selected;
  final void Function(Map<String, dynamic>, bool)? onSelect;
  final void Function(Map<String, dynamic>)? onEdit;
  final void Function()? onDelete;
  const _ChildCard({
    required this.child,
    this.selectionMode = false,
    this.selected = false,
    this.onSelect,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectionMode
          ? () {
              if (onSelect != null) onSelect!(child, !selected);
            }
          : () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AdminChildDetailPage(
                    child: child,
                    onEdit: onEdit,
                    onDelete: onDelete,
                  ),
                ),
              );
            },
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
            if (selectionMode)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                child: Checkbox(
                  value: selected,
                  onChanged: (val) {
                    if (onSelect != null) onSelect!(child, val ?? false);
                  },
                  activeColor: const Color(0xFFF07167),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.asset(
                  child['imagem'],
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
                      child['nome'],
                      style: const TextStyle(
                        fontFamily: 'WildlySans',
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      (child['necessidades'] ?? '').isNotEmpty
                          ? child['necessidades']
                          : 'Sem necessidades definidas',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
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

class _AdminBottomNav extends StatelessWidget {
  final bool selectionMode;
  final VoidCallback onSelectHide;
  final VoidCallback onAtivos;
  final VoidCallback onOcultos;
  final bool showAtivos;
  const _AdminBottomNav({
    required this.selectionMode,
    required this.onSelectHide,
    required this.onAtivos,
    required this.onOcultos,
    required this.showAtivos,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xFFFDE0C3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.home, color: showAtivos && !selectionMode ? const Color(0xFFF07167) : Colors.grey),
            onPressed: onAtivos,
            tooltip: 'Ativos',
          ),
          IconButton(
            icon: Icon(Icons.visibility_off, color: selectionMode ? const Color(0xFFF07167) : Colors.grey),
            onPressed: onSelectHide,
            tooltip: selectionMode ? 'Cancelar seleção' : 'Selecionar para ocultar',
          ),
          IconButton(
            icon: Icon(Icons.person, color: !showAtivos && !selectionMode ? const Color(0xFFF07167) : Colors.grey),
            onPressed: onOcultos,
            tooltip: 'Ocultos',
          ),
        ],
      ),
    );
  }
}

class _AdminFabMenu extends StatefulWidget {
  @override
  State<_AdminFabMenu> createState() => _AdminFabMenuState();
}

class _AdminFabMenuState extends State<_AdminFabMenu> with SingleTickerProviderStateMixin {
  bool _open = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Menu flutuante
        if (_open)
          Positioned(
            bottom: 80,
            child: Material(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _AdminFabOption(
                    icon: Icons.add,
                    label: 'Adicionar',
                    onTap: () async {
                      final state = context.findAncestorStateOfType<_AdminHomePageState>();
                      _toggle();
                      if (state != null) {
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) => AdminAddChildOverlay(
                            onAdd: (newChild) {
                              state.setState(() {
                                state.children.add(newChild);
                              });
                            },
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 24),
                  _AdminFabOption(
                    icon: Icons.calendar_today,
                    label: 'Agenda',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AdminDonationsPage(),
                        ),
                      );
                      _toggle();
                    },
                  ),
                  const SizedBox(width: 24),
                  _AdminFabOption(
                    icon: Icons.visibility_off,
                    label: 'Ocultar cards',
                    onTap: () {
                      // Ativar modo de seleção para ocultar cards
                      final state = context.findAncestorStateOfType<_AdminHomePageState>();
                      if (state != null) {
                        state.setState(() {
                          state.showAtivos = true;
                          state.selectionMode = true;
                        });
                      }
                      _toggle();
                    },
                  ),
                ],
              ),
            ),
          ),
        // Botão principal '+'
        Positioned(
          bottom: 8,
          child: FloatingActionButton(
            heroTag: 'main',
            backgroundColor: Colors.white,
            onPressed: _toggle,
            child: Icon(_open ? Icons.close : Icons.add, color: const Color(0xFFF07167)),
          ),
        ),
      ],
    );
  }
}

class _AdminFabOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _AdminFabOption({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: label,
      backgroundColor: const Color(0xFFF07167),
      mini: true,
      onPressed: onTap,
      child: Icon(icon, color: Colors.white),
    );
  }
}
