import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'form_planeta.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD de Planetas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TelaPlanetas(),
    );
  }
}

class TelaPlanetas extends StatefulWidget {
  const TelaPlanetas({super.key});

  @override
  _TelaPlanetasState createState() => _TelaPlanetasState();
}

class _TelaPlanetasState extends State<TelaPlanetas> {
  List<Map<String, dynamic>> _planetas = [];

  @override
  void initState() {
    super.initState();
    _carregarPlanetas();
  }

  Future<void> _carregarPlanetas() async {
    final data = await DatabaseHelper.instance.listarPlanetas();
    setState(() {
      _planetas = data;
    });
  }

  Future<void> _removerPlaneta(int id) async {
    await DatabaseHelper.instance.excluirPlaneta(id);
    _carregarPlanetas();

    // Exibe uma mensagem ao excluir
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Planeta removido!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Planetas')),
      body: _planetas.isEmpty
          ? const Center(child: Text('Nenhum planeta foi cadastrado ainda.'))
          : ListView.builder(
              itemCount: _planetas.length,
              itemBuilder: (context, index) {
                final planeta = _planetas[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.public, color: Colors.blue),
                    title: Text(
                      planeta['nome'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(planeta['apelido'] ?? 'Sem apelido'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removerPlaneta(planeta['id']),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FormPlaneta(planeta: planeta, atualizarLista: _carregarPlanetas),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FormPlaneta(atualizarLista: _carregarPlanetas),
          ),
        ),
      ),
    );
  }
}
