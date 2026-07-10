import 'package:flutter/material.dart';
import 'package:vacina_app/data/http/config/auth_repository.dart';

class RecuperarSenhaScreen extends StatefulWidget {
  final String email;
  const RecuperarSenhaScreen({super.key, required this.email});

  @override
  State<RecuperarSenhaScreen> createState() => _RecuperarSenhaScreenState();
}

class _RecuperarSenhaScreenState extends State<RecuperarSenhaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codigoController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _carregando = false;

  void _confirmarRedefinicao() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    // Chamada ao Passo B do repositório
    bool sucesso = await AuthRepository().redefinirSenha(
      widget.email,
      _codigoController.text.trim(),
      _senhaController.text.trim(),
    );

    setState(() => _carregando = false);

    if (!mounted) return;

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha alterada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      // Volta para a tela de Login limpa
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código inválido ou expirado.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validar Código')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enviamos um código para o e-mail: ${widget.email}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _codigoController,
                keyboardType: TextInputType.number,
                maxLength: 6, // Restringe visualmente para códigos OTP padrão
                decoration: const InputDecoration(
                  labelText: 'Código de 6 dígitos',
                  border: OutlineInputBorder(),
                  counterText:
                      "", // Esconde o contador numérico abaixo do campo
                ),
                validator: (v) =>
                    v!.length < 6 ? 'Digite o código completo' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nova Senha',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.length < 6
                    ? 'A senha deve ter pelo menos 6 dígitos'
                    : null,
              ),
              const SizedBox(height: 24),
              _carregando
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _confirmarRedefinicao,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text('Redefinir Senha'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
