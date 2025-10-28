import 'package:MegaObra/crud/location.dart';
import 'package:MegaObra/models/chunk.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/utils/error_messages.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:MegaObra/widgets/navigator/pop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';

class AdministratorChunkViewer extends StatefulWidget {
  final String title;
  final int location_id;

  const AdministratorChunkViewer({
    super.key,
    this.title = "",
    required this.location_id,
  });

  @override
  _AdministratorChunkViewerState createState() => _AdministratorChunkViewerState();
}

class _AdministratorChunkViewerState extends State<AdministratorChunkViewer> {
  List<LocationChunk> _loadedChunkInfo = [];
  List<LocationChunk> _filteredChunks = [];
  bool _isDeleteMode = false;
  bool _compressedViewFormat = false;
  // ignore: unused_field
  String _searchTerm = "";

  void _loadChunks() async {
    if (!mounted) {
      return;
    }
    var result = await getLocationChunks(context, widget.location_id);
    if (mounted) {
      setState(() {
        _loadedChunkInfo = result;
        _filteredChunks = result;
        _sortChunks();
      });
    }
  }

  void _resetLoadedChunksAndReload() {
    if (mounted) {
      setState(() {
        _loadedChunkInfo = [];
        _filteredChunks = [];
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

  void _filterChunks(String term) {
    if (mounted) {
      setState(() {
        _searchTerm = term;
        _filteredChunks = _loadedChunkInfo.where((chunk) => chunk.info_one.contains(term.toUpperCase())).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadChunks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _createNewChunk(Chunk location_chunk_info) {
    try {
      createNewLocationChunk(
        context,
        widget.location_id,
        location_chunk_info,
      );
    } catch (e) {
      print("Error trying to create new Location Chunk: $e");
    }
  }

  String formatInfoTwo(String input) {
    final regex = RegExp(r'(\d+)');
    final match = regex.firstMatch(input);

    if (match != null) {
      int number = int.parse(match.group(0)!);
      int incrementedNumber = number + 1;

      String updatedString = input.replaceFirst(
        match.group(0)!,
        incrementedNumber.toString(),
      );
      return updatedString;
    }

    return "";
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

  void _showInfoThreeDialog(BuildContext context, String infoThree) {
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
            infoThree,
            style: TextStyle(
              color: megaobraColoredText(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.close,
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

  @override
  Widget build(BuildContext context) {
    final Map<String, List<LocationChunk>> groupedChunks = {};
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
                    const SizedBox(width: 10),
                    Icon(
                      Icons.location_on,
                      size: 60,
                      color: megaobraNeutralOpaqueText(),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () => {
                        _showAddChunkDialog(context: context),
                      },
                      icon: const Icon(Icons.add),
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
                              if (mounted) {
                                setState(() {
                                  _isDeleteMode
                                      ? {
                                          _deleteChunk(chunk.id),
                                        }
                                      : _showAddChunkDialog(
                                          context: context,
                                          setInfoOne: chunk.info_one,
                                          setInfoTwo: formatInfoTwo(chunk.info_two),
                                        );
                                });
                              }
                            },
                            child: Container(
                              width: _compressedViewFormat ? 90 : 120,
                              height: _compressedViewFormat ? 32 : 80,
                              decoration: BoxDecoration(
                                color: megaobraChunkBox(),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Text(
                                      chunk.info_two,
                                      style: TextStyle(
                                        fontSize: _compressedViewFormat ? 12 : 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  if (chunk.info_three != "")
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
                                          _showInfoThreeDialog(
                                            context,
                                            chunk.info_three,
                                          );
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

  void _showAddChunkDialog({
    required BuildContext context,
    String setInfoOne = "",
    String setInfoTwo = "",
  }) {
    final TextEditingController infoOneController = TextEditingController(text: setInfoOne);
    final TextEditingController infoTwoController = TextEditingController(text: setInfoTwo);
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
                Navigator.of(context).pop();
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
                if (infoOneController.text == "" || infoTwoController.text == "") {
                  return;
                }
                final newChunk = Chunk(
                  info_one: infoOneController.text.toUpperCase(),
                  info_two: infoTwoController.text.toUpperCase(),
                  info_three: infoThreeController.text,
                  deprecated: false,
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
