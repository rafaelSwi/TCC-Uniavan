import 'package:MegaObra/crud/location.dart';
import 'package:MegaObra/models/chunk.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:flutter/material.dart';

class ActivityChunkSelector extends StatefulWidget {
  final String title;
  final int location_id;
  final List<int> preSelectedIds;
  final Function(List<int>) onApply;

  const ActivityChunkSelector({
    super.key,
    this.title = "",
    required this.location_id,
    required this.preSelectedIds,
    required this.onApply,
  });

  @override
  _ActivityChunkSelectorState createState() => _ActivityChunkSelectorState();
}

class _ActivityChunkSelectorState extends State<ActivityChunkSelector> {
  List<LocationChunk> _loadedChunkInfo = [];
  List<LocationChunk> _filteredChunks = [];
  List<int> selectedChunks = [];
  bool _compressedViewFormat = false;
  // ignore: unused_field
  String _searchTerm = "";

  void _loadChunks() async {
    if (mounted) {
      var result = await getLocationChunks(context, widget.location_id);
      if (mounted) {
        setState(() {
          _loadedChunkInfo = result;
          _filteredChunks = result;
          _sortChunks();
          for (var chunk in _loadedChunkInfo) {
            if (widget.preSelectedIds.contains(chunk.id)) {
              selectedChunks.add(chunk.id);
            }
          }
        });
      }
    }
  }

  void makeChunkSelected(LocationChunk chunk) {
    if (mounted) {
      setState(() {
        selectedChunks.add(chunk.id);
      });
    }
  }

  void removeChunkSelection(LocationChunk chunk) {
    if (mounted) {
      setState(() {
        selectedChunks.remove(chunk.id);
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
            colors: megaobraBackgroundColors(),
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
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: megaobraIconColor(),
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 12),
                        MegaObraDefaultText(
                          text: AppLocalizations.of(context)!.cancel,
                          size: 40,
                        ),
                      ],
                    ),
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
                        if (mounted)
                          {
                            setState(() {
                              selectedChunks = [];
                            }),
                          }
                      },
                      icon: const Icon(
                        Icons.layers_clear_outlined,
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
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => {
                              for (int i = 0; i < _filteredChunks.length; i++)
                                {
                                  if (_filteredChunks[i].info_one == entry.value[0].info_one)
                                    {
                                      makeChunkSelected(_filteredChunks[i]),
                                    }
                                }
                            },
                            icon: Icon(
                              Icons.done_all_rounded,
                              size: _compressedViewFormat ? 21 : 28,
                            ),
                            color: megaobraChunkTitle(),
                          ),
                          Text(
                            entry.value[0].info_one,
                            style: TextStyle(
                              fontSize: _compressedViewFormat ? 24 : 30,
                              fontWeight: FontWeight.w600,
                              color: megaobraChunkTitle(),
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
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
                                  selectedChunks.contains(chunk.id) ? removeChunkSelection(chunk) : makeChunkSelected(chunk);
                                });
                              }
                            },
                            child: Container(
                              width: _compressedViewFormat ? 90 : 120,
                              height: _compressedViewFormat ? 40 : 80,
                              decoration: BoxDecoration(
                                color: selectedChunks.contains(chunk.id) ? Colors.green : megaobraChunkBox(),
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
                                            fontSize: _compressedViewFormat ? 12 : 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          selectedChunks.contains(chunk.id)
                                              ? AppLocalizations.of(context)!.marked
                                              : AppLocalizations.of(context)!.available,
                                          style: TextStyle(
                                            fontSize: _compressedViewFormat ? 12 : 16,
                                            fontWeight: FontWeight.w200,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
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
                }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (mounted) {
            setState(() {
              widget.onApply(selectedChunks);
              Navigator.pop(context, true);
            });
          }
        },
        backgroundColor: megaobraButtonBackground(),
        foregroundColor: megaobraColoredText(),
        child: const Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.green,
        ),
      ),
    );
  }
}
