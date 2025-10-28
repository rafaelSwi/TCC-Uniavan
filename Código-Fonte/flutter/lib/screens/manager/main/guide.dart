import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/widgets/buttons/default.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:flutter/material.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class HowToUseScreen extends StatefulWidget {
  int selectedLang;
  HowToUseScreen({super.key, required this.selectedLang});

  @override
  State<HowToUseScreen> createState() => _HowToUseScreenState();
}

class _HowToUseScreenState extends State<HowToUseScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> itemsLang0 = [
      {
        'title': 'Atividade',
        'description':
            'Uma atividade possui um objetivo, que será seu título. As atividades podem estar associadas a funcionários, que determinarão se essas atividades foram concluídas nos espaços selecionados de uma localização. As atividades não são diretamente associadas a responsáveis, moderadores ou projetos, mas apenas a funcionários, localizações e partes dessa localização.'
      },
      {
        'title': 'Em caso de chuva',
        'description':
            'Atividades "em caso de chuva" são atividades manualmente selecionadas para serem executadas em dias de chuva. Essas atividades são associadas a projetos e são gerenciadas exatamente da mesma forma que as atividades normais.'
      },
      {
        'title': 'Projeto',
        'description':
            'De forma resumida, um projeto é uma reunião de atividades. O principal objetivo de um projeto é centralizar as atividades em um único local de fácil acesso e gerenciamento.'
      },
      {
        'title': 'Moderador de um Projeto',
        'description':
            'Um moderador de um projeto não pode fazer alterações no projeto em questão (ou nas atividades associadas) de nenhuma forma. Ele pode apenas acompanhar e definir o progresso nas atividades associadas. Portanto, definir um usuário como moderador de um projeto significa que o mesmo pode acompanhar e gerenciar o progresso das atividades associadas ao projeto.'
      },
      {
        'title': 'Responsável por um Projeto',
        'description':
            'O responsável por um projeto possui controle total sobre o projeto, podendo, assim, adicionar ou remover funcionários e atividades. Além disso, o responsável pelo projeto também tem controle sobre as atividades associadas, gerenciando seu progresso, os funcionários envolvidos e suas restrições. É importante destacar que o responsável por um projeto não pode criar novas atividades para associar ao projeto caso não possua permissões elevadas.'
      },
      {
        'title': 'Localização',
        'description':
            'Uma localização é a representação mais básica para identificar um lugar. Ela inclui o nome do empreendimento, o CEP e, se necessário, uma descrição adicional. Para especificar áreas mais detalhadas dentro de uma localização, como uma sala, utilizam-se os chamados "pedaços".'
      },
      {
        'title': 'Pedaço de uma Localização',
        'description':
            'Um pedaço de uma localização tem o propósito de especificar uma área dentro dessa localização, como, por exemplo, salas. A informação principal indica a área onde o pedaço está localizado, como "BLOCO 1". A informação secundária é a especificação, como "SALA 15".'
      },
      {
        'title': 'Horário',
        'description':
            'Um horário define a entrada e a saída de um funcionário no trabalho. Opcionalmente, também é possível registrar intervalos. Um único horário pode ser compartilhado entre múltiplos funcionários, e ao alterar um horário utilizado por vários funcionários, essa alteração afetará todos os usuários que o compartilham.'
      },
      {
        'title': 'Análise de Planilha',
        'description':
            'Uma análise de planilha coleta as informações de uma planilha que contenha os campos "Nome" e "Duração", e realiza a soma de todos os horários que um funcionário teve em um intervalo específico de tempo.'
      },
      {
        'title': 'Gantt',
        'description':
            'O gráfico de Gantt fornece uma visão mais acessível de atividades ou projetos, utilizando como base suas datas de início e prazo.'
      },
      {
        'title': 'Permissão Administrativa',
        'description':
            'Um administrador possui todas as permissões possíveis dentro do sistema. Isso inclui visualizar todas as atividades e projetos, acompanhar o progresso, entre outras ações.'
      },
      {
        'title': 'Permissão de Gerente',
        'description':
            'Um gerente pode realizar todas as ações que um administrador faz, exceto alterar propriedades de outros usuários, como CPF ou nome.'
      },
      {
        'title': 'Permissão Comum',
        'description':
            'A permissão comum (referida como "trabalhador") permite ao usuário acompanhar os projetos e atividades aos quais está associado. Um funcionário com permissão comum pode marcar atividades associadas como concluídas, por exemplo, mas não tem acesso a projetos e/ou atividades que não estejam vinculadas a ele.'
      },
      {
        'title': 'Permissão Restritiva',
        'description':
            'A permissão restritiva (referida como "restrito") impede o funcionário de realizar qualquer ação dentro do sistema, incluindo a visualização de informações. Pode-se considerar um funcionário com permissão restritiva como um funcionário bloqueado no sistema. Suas ações passadas, no entanto, continuam registradas.'
      },
    ];

    final List<Map<String, String>> itemsLang1 = [
      {
        'title': 'Activity',
        'description':
            'An activity has an objective, which will be its title. Activities can be associated with employees, who will determine if these activities have been completed in selected areas of a location. Activities are not directly associated with responsible persons, moderators, or projects, but only with employees, locations, and parts of that location.'
      },
      {
        'title': 'Rainy day activities',
        'description':
            '"Rainy day activities" are activities manually selected to be performed on rainy days. These activities are associated with projects and are managed in exactly the same way as regular activities.'
      },
      {
        'title': 'Project',
        'description':
            'In short, a project is a collection of activities. The main purpose of a project is to centralize activities in a single location for easy access and management.'
      },
      {
        'title': 'Project Moderator',
        'description':
            'A project moderator cannot make any changes to the project in question (or the associated activities) in any way. They can only monitor and set the progress of the associated activities. Therefore, assigning a user as a project moderator means they can monitor and manage the progress of activities associated with the project.'
      },
      {
        'title': 'Project Manager',
        'description':
            'The project manager has full control over the project, allowing them to add or remove employees and activities. Additionally, the project manager also controls the associated activities, managing their progress, involved employees, and restrictions. It is important to highlight that the project manager cannot create new activities to associate with the project unless they have elevated permissions.'
      },
      {
        'title': 'Location',
        'description':
            'A location is the most basic representation to identify a place. It includes the name of the enterprise, postal code (CEP), and, if necessary, additional description. To specify more detailed areas within a location, such as a room, "chunks" are used.'
      },
      {
        'title': 'Location Chunk',
        'description':
            'A location chunk serves to specify an area within the location, such as rooms. The main information indicates the area where the chunk is located, such as "BLOCK 1". The secondary information specifies the area, like "ROOM 15".'
      },
      {
        'title': 'Schedule',
        'description':
            'A schedule defines the entry and exit times of an employee at work. Optionally, schedules may have breaks. A single schedule can be shared by multiple employees, and if the schedule is changed, that change will affect all users sharing it.'
      },
      {
        'title': 'Spreadsheet Analysis',
        'description':
            'A spreadsheet analysis collects information from a spreadsheet containing "Nome" (name) and "Duração" (duration) fields and sums up all the hours an employee worked in a specific time period.'
      },
      {
        'title': 'Gantt',
        'description':
            'The Gantt chart provides a more accessible view of activities or projects, based on their start dates and deadlines.'
      },
      {
        'title': 'Administrative Permission',
        'description':
            'An administrator has all possible permissions within the system. This includes viewing all activities and projects, tracking progress, among other actions.'
      },
      {
        'title': 'Manager Permission',
        'description':
            'A manager can perform all actions that an administrator can do, except for altering other users\' properties, such as CPF or personal name.'
      },
      {
        'title': 'Common Permission',
        'description':
            'Common permission (referred to as "worker") allows the user to track projects and activities they are associated with. A user with common permission can mark associated activities as completed, for example, but does not have access to projects or activities that are not linked to them.'
      },
      {
        'title': 'Restrictive Permission',
        'description':
            'Restrictive permission (referred to as "restricted") prevents the user from performing ANY action within the server or dabatase. An user with restrictive permission can be considered as a banned user. However, their past actions remain intact.'
      },
    ];

    final List<String> iconPaths = [
      'lib/assets/tutorial/activity.png',
      'lib/assets/tutorial/rain.png',
      'lib/assets/tutorial/project.png',
      'lib/assets/tutorial/moderator.png',
      'lib/assets/tutorial/responsible.png',
      'lib/assets/tutorial/location.png',
      'lib/assets/tutorial/chunk.png',
      'lib/assets/tutorial/schedule.png',
      'lib/assets/tutorial/spreadsheet.png',
      'lib/assets/tutorial/gantt.png',
      'lib/assets/tutorial/perm_adm.png',
      'lib/assets/tutorial/perm_man.png',
      'lib/assets/tutorial/perm_wor.png',
      'lib/assets/tutorial/perm_res.png',
    ];

    final List<double> heightsLang0 = [
      270,
      210,
      180,
      280,
      310,
      220,
      240,
      240,
      180,
      160,
      180,
      180,
      240,
      240,
    ];

    final List<double> heightsLang1 = [
      240,
      180,
      180,
      240,
      270,
      220,
      210,
      215,
      180,
      160,
      180,
      150,
      210,
      210,
    ];

    return Scaffold(
      body: Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MegaObraButton(
                  width: 300,
                  height: 40,
                  text: AppLocalizations.of(context)!.readInPortuguese,
                  padding: const EdgeInsets.all(10.0),
                  function: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HowToUseScreen(
                        selectedLang: 0,
                      ),
                    ),
                  ),
                ),
                MegaObraButton(
                  width: 300,
                  height: 40,
                  text: AppLocalizations.of(context)!.readInEnglish,
                  padding: const EdgeInsets.all(10.0),
                  function: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HowToUseScreen(
                        selectedLang: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedLang == 0 ? itemsLang0.length : itemsLang1.length,
                itemBuilder: (context, index) {
                  final item = widget.selectedLang == 0 ? itemsLang0[index] : itemsLang1[index];

                  final double itemHeight = widget.selectedLang == 0 ? heightsLang0[index] : heightsLang1[index];

                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 900,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        child: Card(
                          elevation: 12,
                          color: megaobraBackgroundColors()[0],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            height: itemHeight,
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  padding: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    color: megaobraButtonBackground(),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: ImageIcon(
                                    AssetImage(
                                      iconPaths[index % iconPaths.length],
                                    ),
                                    size: 36,
                                    color: megaobraColoredText(),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MegaObraDefaultText(
                                        text: item['title'] ?? '',
                                        size: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.only(right: 16.0),
                                        child: Text(
                                          item['description'] ?? '',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: megaobraNeutralText(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
