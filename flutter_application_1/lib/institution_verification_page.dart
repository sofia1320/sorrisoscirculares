import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'admin_home_page.dart'; // mantém import para navegar para AdminHomePage

class InstitutionVerificationPage extends StatefulWidget {
  final String email;
  final String password; // para auto-login depois
  const InstitutionVerificationPage({super.key, required this.email, required this.password});

  @override
  State<InstitutionVerificationPage> createState() => _InstitutionVerificationPageState();
}

class _InstitutionVerificationPageState extends State<InstitutionVerificationPage> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _validate() async {
    setState(() => _isLoading = true);
    final ok = await ApiService.validateAdmin(email: widget.email, code: _codeController.text.trim());
    setState(() => _isLoading = false);
    if (ok) {
      // tentar login automático
      final logged = await ApiService.loginUser(email: widget.email, password: widget.password);
      if (logged) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const AdminHomePage()));
      } else {
        // validação ok, mas login automático falhou:
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Validação efetuada. Faça login.')));
        // volta para a página anterior (onde o utilizador pode fazer login manual)
        Navigator.of(context).pop();
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Código inválido.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validar Instituição')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Insira o código de validação fornecido:'),
            const SizedBox(height: 12),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Código'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _validate,
              child: _isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Validar'),
            ),
          ],
        ),
      ),
    );
  }
}