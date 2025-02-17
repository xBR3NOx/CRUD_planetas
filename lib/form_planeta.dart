import 'package:flutter/material.dart';
import 'database_helper.dart';

class FormPlaneta extends StatefulWidget {
  final Map<String, dynamic>? planeta;
  final Function atualizarLista;

  const FormPlaneta({super.key, this.planeta, required this.atualizarLista});

  @override
  _FormPlanetaState createState() => _FormPlanetaState();
}

class _FormPlanetaState extends State<FormPlaneta> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController distanciaController = TextEditingController();
  final TextEditingController tamanhoController = TextEditingController();
  final TextEditingController apelidoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Se for edição, preencher os campos com os dados existentes
    if (widget.planeta != null) {
      nomeController.text = widget.planeta!['nome'];
      distanciaController.text = widget.planeta!['distancia'].toString();
      tamanhoController.text = widget.planeta!['tamanho'].toString();
      apelidoController.text = widget.planeta!['apelido'] ?? '';
    }
  }

  void _salvarPlaneta() async {
    if (_formKey.currentState!.validate()) {
      final planeta = {
        'nome': nomeController.text,
        'distancia': double.tryParse(distanciaController.text) ?? 0.0,
        'tamanho': int.tryParse(tamanhoController.text) ?? 0,
        'apelido': apelidoController.text.isEmpty ? null : apelidoController.text,
      };

      if (widget.planeta == null) {
        await DatabaseHelper.instance.inserirPlaneta(planeta);
      } else {
        await DatabaseHelper.instance.atualizarPlaneta(widget.planeta!['id'], planeta);
      }

      widget.atualizarLista();

      // Exibe um aviso de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Planeta salvo com sucesso!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.planeta == null ? 'Novo Planeta' : 'Editar Planeta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Planeta'),
                validator: (value) => value!.isEmpty ? 'Preencha o nome' : null,
              ),
              TextFormField(
                controller: distanciaController,
                decoration: const InputDecoration(labelText: 'Distância do Sol (UA)'),
                keyboardType: TextInputType.number,
                validator: (value) => (double.tryParse(value ?? '') ?? 0) > 0 ? null : 'Insira um valor positivo',
              ),
              TextFormField(
                controller: tamanhoController,
                decoration: const InputDecoration(labelText: 'Tamanho (km)'),
                keyboardType: TextInputType.number,
                validator: (value) => (int.tryParse(value ?? '') ?? 0) > 0 ? null : 'Insira um número válido',
              ),
              TextFormField(
                controller: apelidoController,
                decoration: const InputDecoration(labelText: 'Apelido (opcional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarPlaneta,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
