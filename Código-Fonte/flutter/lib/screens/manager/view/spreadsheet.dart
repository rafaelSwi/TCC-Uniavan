import 'dart:io';
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:MegaObra/screens/manager/create/user.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/widgets/info/container.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class SpreadsheetAnalysisView extends StatefulWidget {
  @override
  _SpreadsheetAnalysisViewState createState() => _SpreadsheetAnalysisViewState();
}

class _SpreadsheetAnalysisViewState extends State<SpreadsheetAnalysisView> {
  Map<String, int> resultado = {};
  String nomeColuna = 'Nome';
  String duracaoColuna = 'Duração';

  Future<void> processarExcel(String filePath) async {
    var fileBytes = File(filePath).readAsBytesSync();
    var excel = Excel.decodeBytes(fileBytes);

    Map<String, int> duracaoPorFuncionario = {};

    // Processa a primeira aba da planilha
    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];

      if (sheet != null) {
        var headerRow = sheet.rows.first; // Primeira linha (Cabeçalhos)
        int nomeIndex =
            headerRow.indexWhere((cell) => cell != null && cell.value.toString().toLowerCase() == nomeColuna.toLowerCase());
        int duracaoIndex =
            headerRow.indexWhere((cell) => cell != null && cell.value.toString().toLowerCase() == duracaoColuna.toLowerCase());

        if (nomeIndex == -1 || duracaoIndex == -1) {
          print('Error: The specified columns could not be found.');
          return;
        }

        // Itera pelas linhas, começando após o cabeçalho
        for (var row in sheet.rows.skip(1)) {
          String nome = row[nomeIndex]?.value.toString() ?? ''; // Coluna 'Nome'
          String duracao = row[duracaoIndex]?.value.toString() ?? ''; // Coluna 'Duração' (Formato HH:MM)

          if (nome.isNotEmpty && duracao.isNotEmpty) {
            int minutos = converterParaMinutos(duracao);

            // Soma a duração se o nome já existir no dicionário
            if (duracaoPorFuncionario.containsKey(nome)) {
              duracaoPorFuncionario[nome] = duracaoPorFuncionario[nome]! + minutos;
            } else {
              duracaoPorFuncionario[nome] = minutos;
            }
          }
        }
      }
    }
    if (mounted) {
      setState(() {
        resultado = duracaoPorFuncionario;
      });
    }
  }

  void showPermissionErrorMessage() {
    if (mounted) {
      showAlertDialog(
        context: context,
        title: AppLocalizations.of(context)!.permissionError,
        text: AppLocalizations.of(context)!.youCannotCreateNewUser,
      );
    }
  }

  int converterParaMinutos(String tempoStr) {
    var partes = tempoStr.split(':');
    if (partes.length == 2) {
      int horas = int.parse(partes[0]);
      int minutos = int.parse(partes[1]);
      return horas * 60 + minutos;
    }
    return 0; // Retorna 0 se o formato for inválido
  }

  Future<void> selecionarArquivo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      String filePath = result.files.single.path!;
      await processarExcel(filePath);
    }
  }

  Future<void> exportarExcel() async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Resultado'];
    sheetObject.appendRow(["Nome", "Total de Minutos"]);

    resultado.forEach((nome, minutos) {
      sheetObject.appendRow([nome, minutos]);
    });

    // Salva o arquivo Excel
    final directory = Directory.current.path;
    final filePath = "$directory/resultado.xlsx";

    // Adicionando a escrita do arquivo
    final bytes = excel.encode();
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(bytes!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Arquivo exportado para: $filePath")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: megaobraBackgroundColors(),
            begin: megaobraBackgroundGradientdStart(),
            end: megaobraBackgroundGradientdEnd(),
          ),
        ),
        child: Column(
          children: [
            const MegaObraNavigatorPopButton(),
            Container(
              width: 500,
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(
                      color: megaobraNeutralText(),
                    ),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.nameColumnLabel,
                      labelStyle: TextStyle(
                        color: megaobraNeutralOpaqueText(),
                      ),
                    ),
                    onChanged: (value) => nomeColuna = value,
                  ),
                  TextField(
                    style: TextStyle(
                      color: megaobraNeutralText(),
                    ),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.durationColumnLabel,
                      labelStyle: TextStyle(
                        color: megaobraNeutralOpaqueText(),
                      ),
                    ),
                    onChanged: (value) => duracaoColuna = value,
                  ),
                ],
              ),
            ),
            MegaObraButton(
                width: 300,
                height: 40,
                text: AppLocalizations.of(context)!.selectFile,
                padding: EdgeInsets.all(30.0),
                function: selecionarArquivo),
            SizedBox(height: 20),
            resultado.isEmpty
                ? MegaObraTinyText(
                    text: AppLocalizations.of(context)!.onlyXlsxFilesWillWork,
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: resultado.length,
                      itemBuilder: (context, index) {
                        String nome = resultado.keys.elementAt(index);
                        int duracao = resultado[nome]!;
                        double horas = duracao / 60;
                        return Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.person_add),
                                  color: megaobraIconColor(),
                                  onPressed: () => {
                                    [1, 2].contains(getLoggedUser()?.permission_id)
                                        ? mounted
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => CreateUserScreen(
                                                    setName: nome,
                                                  ),
                                                ),
                                              )
                                            : null
                                        : showPermissionErrorMessage(),
                                  },
                                ),
                                const SizedBox(width: 10),
                                MegaObraInformationContainer(
                                  maxWidth: 360,
                                  containerWidth: 350,
                                  text: formatStringByLength(nome, 28),
                                ),
                                const SizedBox(width: 50),
                                Icon(
                                  Icons.timer,
                                  color: megaobraIconColor(),
                                ),
                                const SizedBox(width: 10),
                                MegaObraInformationContainer(
                                  maxWidth: 220,
                                  containerWidth: 210,
                                  text: "${AppLocalizations.of(context)!.inMinutes}: ${duracao}",
                                ),
                                MegaObraInformationContainer(
                                  maxWidth: 250,
                                  containerWidth: 210,
                                  text: "${AppLocalizations.of(context)!.inHours}: ${horas.toStringAsFixed(2)}",
                                ),
                                const Spacer(),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
