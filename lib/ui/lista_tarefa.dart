import 'package:flutter/material.dart';
import 'package:minicurso_setif/core/entity/tarefa.dart';
import 'package:minicurso_setif/core/sqflite/dao/dao_tarefa.dart';

class ListaTarefa extends StatefulWidget {
  const ListaTarefa({super.key});

  @override
  State<ListaTarefa> createState() => _ListaTarefaState();
}

class _ListaTarefaState extends State<ListaTarefa> {
  final TextEditingController _descricaoController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final DaoTarefa daoTarefa = DaoTarefa();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: daoTarefa.listarTarefas(),
        builder: (context, AsyncSnapshot<List<Tarefa>> dados) {
          if (!dados.hasData) {
            return const CircularProgressIndicator();
          } else {
            List<Tarefa> tarefas = dados.data!;

            return ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                var tarefaAtual = tarefas[index];

                var tarefa = Tarefa(
                  id: tarefaAtual.id,
                  descricao: tarefaAtual.descricao,
                );

                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 6.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    title: Text(
                      tarefa.descricao,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                            ),
                            onPressed: () {
                              atualizarTarefa(tarefa, context, formKey);
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              daoTarefa.excluirTarefa(tarefa.id);
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => Container(
              padding: const EdgeInsets.only(
                top: 4.0,
                left: 30,
                right: 30,
                bottom: 30,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _descricaoController,
                          decoration: const InputDecoration(
                            labelText: 'Descrição da tarefa',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe a descrição da tarefa';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              var tarefa =
                                  Tarefa(descricao: _descricaoController.text);

                              setState(() {
                                daoTarefa.salvarTarefa(tarefa);

                                _descricaoController.clear();
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: const Text('Cadastrar Tarefa'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        tooltip: 'Adicionar',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<Widget?> atualizarTarefa(
    Tarefa tarefa,
    BuildContext context,
    GlobalKey<FormState> formKey,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.only(
          top: 4.0,
          left: 30,
          right: 30,
          bottom: 30,
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: tarefa.descricao,
                    decoration: const InputDecoration(
                      labelText: 'Descrição da tarefa',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe a descrição da tarefa';
                      } else {
                        tarefa.descricao = value;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          daoTarefa.atualizarTarefa(tarefa);
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: const Text('Atualizar Tarefa'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
