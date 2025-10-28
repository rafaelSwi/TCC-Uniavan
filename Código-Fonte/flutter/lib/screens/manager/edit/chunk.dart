import 'package:MegaObra/crud/activity.dart';
import 'package:MegaObra/crud/location.dart';
import 'package:MegaObra/crud/user.dart';
import 'package:MegaObra/models/associative/activity_chunk.dart';
import 'package:MegaObra/models/chunk.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/screens/manager/view/user.dart';
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/alerts/simple.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChunkGroupingScreen extends StatefulWidget {
  final String title;
  final int location_id;
  final int activity_id;
  const ChunkGroupingScreen({
    super.key,
    this.title = "",
    required this.activity_id,
    required this.location_id,
  });
  @override
  _ChunkGroupingScreenState createState() => _ChunkGroupingScreenState();
}

class _ChunkGroupingScreenState extends State<ChunkGroupingScreen> {
  List<CompleteChunk> _loadedChunkInfo = [];
  List<CompleteChunk> _filteredChunks = [];
  bool _isDeleteMode = false;
  bool _compressedViewFormat = false;
  bool _moreInfoViewFormat = false;
  // ignore: unused_field
  String _searchTerm = "";

  void _loadChunks() async {
    if (mounted) {
      var result = await getActivityChunkStatus(context, widget.activity_id);
      if (mounted) {
        setState(() {
          _loadedChunkInfo = result;
          _filteredChunks = result;
          _sortChunks();
        });
      }
    }
  }

  void viewUserNavigator(int user_id) async {
    try {
      User? user = await getUserById(context, user_id);
      if (user != null) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdministratorUserViewer(
                user: user,
                spectate: true,
              ),
            ),
          );
        }
      } else if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.errorOpeningUser,
        );
      }
    } catch (e) {
      print("Error: ${e}");
    }
  }

  int getLoggedUserId() {
    User? logged_user = getLoggedUser();
    if (logged_user != null) {
      return logged_user.id;
    } else {
      return 0;
    }
  }

  void _resetLoadedChunksAndReload() {
    if (mounted) {
      setState(() {
        _loadedChunkInfo = [];
        Future.delayed(const Duration(milliseconds: 100), () {
          _loadChunks();
        });
      });
    }
  }

  void _sortChunks() {
    _loadedChunkInfo.sort((a, b) {
      int infoOneComparison = a.info_one.compareTo(b.info_one);
      if (infoOneComparison != 0) {
        return infoOneComparison;
      }
      return a.info_two.compareTo(b.info_two);
    });
    _filteredChunks.sort((a, b) {
      int infoOneComparison = a.info_one.compareTo(b.info_one);
      if (infoOneComparison != 0) {
        return infoOneComparison;
      }
      return a.info_two.compareTo(b.info_two);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadChunks();
  }

  void _createNewChunk(ChunkCreate location_chunk_create) {
    try {
      createNewActivityChunk(
        context,
        widget.activity_id,
        location_chunk_create,
      );
    } catch (e) {
      print("Error trying to create new Activity Chunk: $e");
    }
  }

  void _deleteChunk(int chunk_id) {
    showQuestionAlertDialog(
      context: context,
      title: AppLocalizations.of(context)!.delete,
      text: AppLocalizations.of(context)!.deleteThisChunk,
      confirmText: AppLocalizations.of(context)!.yes,
      cancelText: AppLocalizations.of(context)!.no,
      onConfirm: () {
        try {
          deleteChunk(context, chunk_id);
          _resetLoadedChunksAndReload();
        } catch (e) {
          print("Error trying to delete Chunk: $e");
        }
      },
      onCancel: () {},
    );
  }

  String getNoteContent(bool allInfo, CompleteChunk completeChunk, BuildContext context) {
    if (!allInfo) {
      String stuff = completeChunk.info_three;
      if (completeChunk.mark_done_by != null) {
        stuff = "${stuff}\n\n${AppLocalizations.of(context)!.userHasAlreadyMarkedThisChunkAsComplete}";
      }
      return stuff;
    }
    String infoT = AppLocalizations.of(context)!.chunkHasNoNote;
    if (completeChunk.info_three != "") {
      infoT = completeChunk.info_three;
    }
    String doneDate = "${AppLocalizations.of(context)!.conclusionDate}: ${AppLocalizations.of(context)!.noInfo}.";
    String markedDoneDate =
        "${AppLocalizations.of(context)!.dateWhenItWasMarkedAsCompleted}: ${AppLocalizations.of(context)!.noInfo}.";
    String markedDoneBy = "${AppLocalizations.of(context)!.markedAsCompletedby}: ${AppLocalizations.of(context)!.noInfo}.";

    if (completeChunk.done_date != null) {
      doneDate = "${AppLocalizations.of(context)!.conclusionDate}: ${formatDateTime(dateTime: completeChunk.done_date)}.";
    }

    if (completeChunk.mark_done_date != null) {
      markedDoneDate =
          "${AppLocalizations.of(context)!.dateWhenItWasMarkedAsCompleted}: ${formatDateTime(dateTime: completeChunk.mark_done_date)}.";
    }

    if (completeChunk.mark_done_by != null) {
      markedDoneBy = AppLocalizations.of(context)!.userHasAlreadyMarkedThisChunkAsComplete;
    }

    String content = "${infoT}\n\n${doneDate}\n\n${markedDoneDate}\n\n${markedDoneBy}";

    return content;
  }

  void __updateChunkStatePropertyDialog(
    BuildContext context,
    int chunk_status_id,
    bool new_status,
  ) {
    if (new_status == true) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MegaObraDatePickerAlertDialog(
            title: AppLocalizations.of(context)!.doYouWantToMarkThisChunkAsComplete,
            cancelText: AppLocalizations.of(context)!.close.toUpperCase(),
            confirmText: AppLocalizations.of(context)!.confirm.toUpperCase(),
            selectDateText: AppLocalizations.of(context)!.clickHereToChooseCustomCompletionDate,
            onConfirm: (newDate) {
              _updateChunkStateProperty(
                context,
                chunk_status_id,
                new_status,
                newDate,
              );
            },
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MegaObraQuestionAlertDialog(
            title: AppLocalizations.of(context)!.doYouWantToUnmarkThisChunk,
            text: AppLocalizations.of(context)!.doYouWantToUnmarkThisChunkDescription,
            onConfirm: () {
              _updateChunkStateProperty(
                context,
                chunk_status_id,
                new_status,
                null,
              );
            },
            cancelText: AppLocalizations.of(context)!.no.toUpperCase(),
            confirmText: AppLocalizations.of(context)!.yesUndo.toUpperCase(),
          );
        },
      );
    }
  }

  void _updateChunkStateProperty(
    BuildContext context,
    int chunk_status_id,
    bool new_status,
    DateTime? artificial_done_date,
  ) async {
    try {
      Map<String, dynamic> updateData = {};
      if (new_status) {
        updateData = {
          'status': new_status,
          'mark_done_date': DateTime.now().toIso8601String(),
          'done_date': artificial_done_date == null ? DateTime.now().toIso8601String() : artificial_done_date.toIso8601String(),
          'mark_done_by': getLoggedUserId(),
        };
      } else {
        updateData = {
          'status': new_status,
        };
      }
      await updateActivityChunkProperty(
        context,
        widget.activity_id,
        chunk_status_id,
        updateData,
      );
      _resetLoadedChunksAndReload();
    } catch (e) {
      print("Error while trying to update a activity chunk property: $e");
      if (mounted) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.error,
          text: AppLocalizations.of(context)!.somethingWentWrong,
        );
      }
    }
  }

  void _showInfoThreeDialog(BuildContext context, String infoThree, CompleteChunk chunk) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: megaobraButtonBackground(),
          title: Text(
            AppLocalizations.of(context)!.note,
            style: TextStyle(
              color: megaobraColoredText(),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            getNoteContent(_moreInfoViewFormat, chunk, context),
            style: TextStyle(
              color: megaobraColoredText(),
            ),
          ),
          actions: [
            if (chunk.mark_done_by != null)
              TextButton(
                onPressed: () {
                  if (mounted) {
                    if (chunk.mark_done_by != null) {
                      viewUserNavigator(chunk.mark_done_by!);
                    }
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.userDetails,
                  style: TextStyle(
                    color: megaobraColoredText(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            TextButton(
              onPressed: () {
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                AppLocalizations.of(context)!.close.toUpperCase(),
                style: TextStyle(
                  color: megaobraColoredText(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _filterChunks(String term) {
    if (mounted) {
      setState(() {
        _searchTerm = term;
        _filteredChunks = _loadedChunkInfo.where((chunk) => chunk.info_one.contains(term.toUpperCase())).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<CompleteChunk>> groupedChunks = {};
    for (var chunk in _filteredChunks) {
      String key = chunk.info_one;
      if (!groupedChunks.containsKey(key)) {
        groupedChunks[key] = [];
      }
      groupedChunks[key]!.add(chunk);
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isDeleteMode ? [megaobraAlertText(), Colors.red] : megaobraBackgroundColors(),
            begin: megaobraBackgroundGradientdStart(),
            end: megaobraBackgroundGradientdEnd(),
          ),
        ),
        child: SizedBox.expand(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const MegaObraNavigatorPopButton(),
                    const Spacer(),
                    MegaObraDefaultText(
                      text: formatStringByLength(widget.title, 70),
                      opaque: true,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.construction,
                      size: 60,
                      color: megaobraNeutralOpaqueText(),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () => {
                        if (mounted)
                          {
                            _showAddChunkDialog(context),
                          }
                      },
                      icon: const Icon(Icons.add),
                      color: megaobraIconColor(),
                      iconSize: 60,
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      // here todo
                      onPressed: () => {
                        if (mounted)
                          {
                            setState(() {
                              _moreInfoViewFormat = !_moreInfoViewFormat;
                            }),
                          }
                      },
                      icon: Icon(
                        _moreInfoViewFormat ? Icons.info : Icons.info_outlined,
                      ),
                      color: megaobraIconColor(),
                      iconSize: 60,
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () => {
                        if (mounted)
                          {
                            setState(() {
                              _compressedViewFormat = !_compressedViewFormat;
                            }),
                          }
                      },
                      icon: Icon(
                        _compressedViewFormat ? Icons.photo_size_select_large : Icons.photo_size_select_actual,
                      ),
                      color: megaobraIconColor(),
                      iconSize: 60,
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        if (mounted) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              final TextEditingController searchController = TextEditingController();
                              return AlertDialog(
                                backgroundColor: megaobraButtonBackground(),
                                title: Text(
                                  AppLocalizations.of(context)!.search,
                                  style: TextStyle(
                                    color: megaobraColoredText(),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    labelText: AppLocalizations.of(context)!.insertMainInformation,
                                    labelStyle: TextStyle(
                                      color: megaobraColoredText(),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: megaobraColoredText(),
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: megaobraColoredText(),
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(color: megaobraColoredText()),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.cancelAbbreviated,
                                      style: TextStyle(
                                        color: megaobraColoredText(),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _filterChunks("");
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.resetSearch,
                                      style: TextStyle(
                                        color: megaobraColoredText(),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _filterChunks(searchController.text);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.search,
                                      style: TextStyle(
                                        color: megaobraColoredText(),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      icon: const Icon(Icons.search),
                      color: megaobraIconColor(),
                      iconSize: 60,
                    ),
                  ],
                ),
                ...groupedChunks.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.value[0].info_one,
                        style: TextStyle(
                          fontSize: _compressedViewFormat ? 24 : 30,
                          fontWeight: FontWeight.w600,
                          color: _isDeleteMode ? Colors.white : megaobraChunkTitle(),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: entry.value.map((chunk) {
                          return GestureDetector(
                            onTap: () {
                              if (!mounted) {
                                return;
                              }
                              if (mounted) {
                                setState(() {
                                  _isDeleteMode
                                      ? _deleteChunk(chunk.chunk_id)
                                      : __updateChunkStatePropertyDialog(
                                          context,
                                          chunk.status_id,
                                          !chunk.status,
                                        );
                                  _resetLoadedChunksAndReload();
                                });
                              }
                            },
                            child: Container(
                              width: _compressedViewFormat ? 90 : 120,
                              height: _compressedViewFormat ? 50 : 80,
                              decoration: BoxDecoration(
                                color: chunk.status ? Colors.green : megaobraChunkBox(),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          chunk.info_two,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: _compressedViewFormat ? 12 : 16,
                                          ),
                                        ),
                                        SizedBox(
                                          height: _compressedViewFormat ? 2 : 4,
                                        ),
                                        Text(
                                          chunk.status
                                              ? AppLocalizations.of(context)!.done
                                              : _compressedViewFormat
                                                  ? AppLocalizations.of(context)!.inProgressAbbreviated
                                                  : AppLocalizations.of(context)!.inProgress,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (chunk.info_three != "" || _moreInfoViewFormat)
                                    Positioned(
                                      right: _compressedViewFormat ? -12 : 2,
                                      top: _compressedViewFormat ? -12 : 2,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.info,
                                          color: Colors.white70,
                                          size: _compressedViewFormat ? 8 : 16,
                                        ),
                                        onPressed: () {
                                          if (mounted) {
                                            _showInfoThreeDialog(
                                              context,
                                              chunk.info_three,
                                              chunk,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (mounted) {
            setState(() {
              _isDeleteMode = !_isDeleteMode;
            });
          }
        },
        backgroundColor: _isDeleteMode ? Colors.white : megaobraButtonBackground(),
        foregroundColor: megaobraColoredText(),
        child: Icon(
          _isDeleteMode ? Icons.cancel : Icons.delete,
        ),
      ),
    );
  }

  void _showAddChunkDialog(BuildContext context) {
    final TextEditingController infoOneController = TextEditingController();
    final TextEditingController infoTwoController = TextEditingController();
    final TextEditingController infoThreeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: megaobraButtonBackground(),
          title: Text(
            AppLocalizations.of(context)!.addChunk,
            style: TextStyle(
              color: megaobraColoredText(),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: infoOneController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.mainInformation,
                  labelStyle: TextStyle(
                    color: megaobraColoredText(),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: megaobraColoredText(),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: megaobraColoredText(),
                    ),
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(8),
                ],
                style: TextStyle(color: megaobraColoredText()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: infoTwoController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.secondaryInformation,
                  labelStyle: TextStyle(
                    color: megaobraColoredText(),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: megaobraColoredText(),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: megaobraColoredText(),
                    ),
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(8),
                ],
                style: TextStyle(color: megaobraColoredText()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: infoThreeController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.note,
                  labelStyle: TextStyle(
                    color: megaobraColoredText(),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: megaobraColoredText(),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: megaobraColoredText(),
                    ),
                  ),
                ),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(32),
                ],
                style: TextStyle(color: megaobraColoredText()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: TextStyle(
                  color: megaobraColoredText(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (!mounted) {
                  return;
                }
                if (infoOneController.text == "" || infoTwoController.text == "") {
                  return;
                }
                final newChunk = ChunkCreate(
                  location_id: widget.location_id,
                  info_one: infoOneController.text.toUpperCase(),
                  info_two: infoTwoController.text.toUpperCase(),
                  info_three: infoThreeController.text,
                );
                _createNewChunk(newChunk);
                Navigator.of(context).pop();
                _resetLoadedChunksAndReload();
              },
              child: Text(
                AppLocalizations.of(context)!.add,
                style: TextStyle(
                  color: megaobraColoredText(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
