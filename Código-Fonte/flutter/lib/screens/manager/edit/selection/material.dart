import 'package:MegaObra/crud/material.dart';
import 'package:MegaObra/models/material.dart' as model;
import 'package:MegaObra/screens/manager/view/material.dart';
import 'package:MegaObra/utils/customization.dart';
import 'package:MegaObra/utils/formatting.dart';
import 'package:MegaObra/widgets/fields/fields.dart';
import 'package:MegaObra/widgets/info/container.dart';
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/widgets/info/texts.dart';
import 'package:flutter/material.dart';

class MaterialSelectionPage extends StatefulWidget {
  final List<int> selectedMaterialIds;
  final List<double> selectedAmounts;
  final Function(List<int>, List<double>) onApply;

  const MaterialSelectionPage({
    Key? key,
    required this.selectedMaterialIds,
    required this.selectedAmounts,
    required this.onApply,
  }) : super(key: key);

  @override
  _MaterialSelectionPageState createState() => _MaterialSelectionPageState();
}

class _MaterialSelectionPageState extends State<MaterialSelectionPage> {
  List<model.Material> _loadedMaterials = [];
  List<model.Material> _filteredMaterials = [];
  Set<int> _markedMaterialds = {};
  Map<int, TextEditingController> _amountControllers = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _markedMaterialds = widget.selectedMaterialIds.toSet();

    // cria controllers para os já selecionados e seta valores
    for (int i = 0; i < widget.selectedMaterialIds.length; i++) {
      final id = widget.selectedMaterialIds[i];
      final amount = i < widget.selectedAmounts.length ? widget.selectedAmounts[i] : 0;
      _amountControllers[id] = TextEditingController(text: amount > 0 ? amount.toString() : '');
    }

    _loadMaterials();
  }

  void _loadMaterials() async {
    var resultUsers = await getAllMaterials(context);
    if (mounted) {
      setState(() {
        _loadedMaterials = resultUsers;
        _filteredMaterials = resultUsers;
      });
    }
  }

  void _toggleMaterialSelection(int materialId) {
    if (!mounted) return;

    setState(() {
      if (_markedMaterialds.contains(materialId)) {
        _markedMaterialds.remove(materialId);
        _amountControllers.remove(materialId);
      } else {
        _markedMaterialds.add(materialId);
        _amountControllers.putIfAbsent(materialId, () => TextEditingController());
      }
    });
  }

  void _filterMaterials(String query) {
    if (mounted) {
      setState(() {
        _searchQuery = query;
        _filteredMaterials = _loadedMaterials.where((user) => user.name.toLowerCase().contains(query.toLowerCase())).toList();
      });
    }
  }

  void _applySelection() {
    final ids = _markedMaterialds.toList();
    final amounts = ids.map((id) {
      final text = _amountControllers[id]?.text ?? '0';
      final parsed = double.tryParse(text);
      return parsed ?? 0;
    }).toList();

    widget.onApply(ids, amounts);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    for (final controller in _amountControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: megaobraNeutralText()),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Icon(Icons.search, color: megaobraNeutralOpaqueText()),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                onChanged: _filterMaterials,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.searchByName,
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: megaobraNeutralOpaqueText()),
                ),
                style: TextStyle(color: megaobraNeutralOpaqueText()),
              ),
            ),
          ],
        ),
        backgroundColor: megaobraSwitchBackground(),
      ),
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
            Expanded(
              child: _filteredMaterials.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _filteredMaterials.length,
                      itemBuilder: (context, index) {
                        final material = _filteredMaterials[index];
                        final isMarked = _markedMaterialds.contains(material.id);
                        final controller = _amountControllers[material.id];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () => _toggleMaterialSelection(material.id),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 5),
                                    Checkbox(
                                      value: isMarked,
                                      onChanged: (_) => _toggleMaterialSelection(material.id),
                                      activeColor: Colors.green,
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          MegaObraDefaultText(
                                            text: formatStringByLength(material.name, 68),
                                          ),
                                          MegaObraTinyText(
                                            text: material.description ?? "",
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.image_search_rounded),
                                      color: megaobraIconColor(),
                                      onPressed: () {
                                        if (mounted) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AdministratorMaterialViewer(
                                                material: material,
                                              ),
                                              fullscreenDialog: true,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              if (isMarked && controller != null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 50, right: 10, top: 12),
                                  child: SizedBox(
                                    width: 300,
                                    child: MegaObraFieldNumerical(
                                      controller: controller,
                                      label: AppLocalizations.of(context)!.amount,
                                      allowDecimal: true,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MegaObraInformationContainer(
                text: AppLocalizations.of(context)!.selectedPlural,
                containerWidth: 270,
                maxWidth: 320,
                sideText: _markedMaterialds.length.toString(),
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _applySelection,
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
