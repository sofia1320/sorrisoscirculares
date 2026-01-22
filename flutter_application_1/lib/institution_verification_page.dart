import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'admin_home_page.dart';
import 'main.dart';

class InstitutionVerificationPage extends StatefulWidget {
  final String email;
  final String password;

  const InstitutionVerificationPage({
    super.key,
    required this.email,
    required this.password,
  });

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

  Future<void> _validateAndLogin() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira o código de validação.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Validate admin with code
      final validated = await ApiService.validateAdmin(
        email: widget.email,
        code: code,
      );

      if (validated) {
        // Auto-login after successful validation
        final loggedIn = await ApiService.loginUser(
          email: widget.email,
          password: widget.password,
        );

        if (!mounted) return;

        if (loggedIn) {
          // Navigate to AdminHomePage
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const AdminHomePage()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao fazer login. Tente novamente.')),
          );
          // Navigate to LoginPage on login failure
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Código de validação inválido.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF07167),
              Color(0xFFF38A7A),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Center(
              child: Image.asset(
                'assets/images/logo branco.png',
                fit: BoxFit.contain,
                width: 260,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 0),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFF4),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(48),
                    topRight: Radius.circular(48),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      const Text(
                        'Validação de Instituição',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          'Insira o código de validação que foi enviado para o seu email.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontFamily: 'SF Pro Display',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: TextField(
                          controller: _codeController,
                          decoration: InputDecoration(
                            hintText: 'Código de Validação',
                            filled: true,
                            fillColor: const Color(0xFFFFFFF4),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      GestureDetector(
                        onTap: _isLoading ? null : _validateAndLogin,
                        child: Container(
                          width: 280,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: _isLoading ? Colors.grey : const Color(0xFFFDE0C3),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Center(
                            child: Text(
                              _isLoading ? 'A VALIDAR...' : 'VALIDAR',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: Color(0xFFF07167),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
