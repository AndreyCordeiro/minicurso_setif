import 'package:minicurso_setif/core/entity/tarefa.dart';
import 'package:sqflite/sqflite.dart';

import '../banco.dart';

class DaoTarefa {
  @override
  Future<bool> salvarTarefa(Tarefa tarefa) async {
    Database db = await Conexao.abrirConexao();

    const sql = 'INSERT INTO tarefa (descricao) VALUES (?)';
    var linhasAfetadas = await db.rawInsert(sql, [tarefa.descricao]);

    return linhasAfetadas > 0;
  }

  @override
  Future<List<Tarefa>> listarTarefas() async {
    late Database db;

    const sql = 'SELECT * FROM tarefa';
    db = await Conexao.abrirConexao();

    List<Map<String, Object?>> resultados = (await db.rawQuery(sql));

    List<Tarefa> tarefas = resultados.map((resultado) {
      return Tarefa(
          id: resultado['id'] as int,
          descricao: resultado['descricao'].toString());
    }).toList();

    return tarefas;
  }

  @override
  Future<bool> atualizarTarefa(Tarefa tarefa) async {
    Database db = await Conexao.abrirConexao();

    var sql = 'UPDATE tarefa SET descricao = ? WHERE id = ?';

    var linhasAfetadas = await db.rawUpdate(sql, [
      tarefa.descricao.trim(),
      tarefa.id,
    ]);

    return linhasAfetadas > 0;
  }

  @override
  Future<bool> excluirTarefa(int id) async {
    Database db = await Conexao.abrirConexao();

    const sql = 'DELETE FROM tarefa WHERE id =?';
    int resultados = await db.rawDelete(sql, [id]);

    return resultados > 0;
  }
}
