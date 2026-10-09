import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:metal_weight/history_service.dart';
import 'package:metal_weight/models.dart';
import 'package:metal_weight/section_diagram_2d.dart';

class Calculation extends StatefulWidget {
  const Calculation({super.key});

  @override
  State<Calculation> createState() => _CalculationState();
}

class _CalculationState extends State<Calculation> {
  // State variables
  String _selectedMetal = 'Steel';
  String _selectedShape = 'Sheet / Plate';
  bool _isMetric = true; // true = Metric (mm, kg), false = Imperial (in, lbs)

  // Controllers for dimensions
  final TextEditingController _lengthController = TextEditingController(text: '1000');
  final TextEditingController _widthController = TextEditingController(text: '500');
  final TextEditingController _thicknessController = TextEditingController(text: '12');
  final TextEditingController _outerDiaController = TextEditingController(text: '50');
  final TextEditingController _heightController = TextEditingController(text: '100');
  final TextEditingController _webThicknessController = TextEditingController(text: '6');
  final TextEditingController _flangeThicknessController = TextEditingController(text: '8');
  final TextEditingController _quantityController = TextEditingController(text: '1');
  final TextEditingController _priceController = TextEditingController(text: '4.50');
  final TextEditingController _customDensityController = TextEditingController(text: '7.85');

  // Computed Outputs
  double _calculatedWeightPerPiece = 0.0;
  double _calculatedTotalWeight = 0.0;
  double _calculatedCost = 0.0;
  double _calculatedVolume = 0.0; // mm³ or in³
  double _calculatedSurfaceArea = 0.0; // mm² or in²

  final HistoryService _historyService = HistoryService();

  // Metal densities (g/cm³)
  final Map<String, double> _metalDensities = {
    'Steel': 7.85,
    'Stainless Steel': 8.00,
    'Aluminum': 2.70,
    'Copper': 8.96,
    'Brass': 8.73,
    'Bronze': 8.80,
    'Titanium': 4.51,
    'Cast Iron': 7.20,
    'Lead': 11.34,
    'Zinc': 7.13,
    'Custom': 7.85,
  };

  final List<String> _shapes = [
    'Sheet / Plate',
    'Round Bar',
    'Square Bar',
    'Flat Bar',
    'Hexagonal Bar',
    'Round Tube / Pipe',
    'Square / Rectangular Tube',
    'Angle (L-Profile)',
    'Channel (C-Profile)',
    'I-Beam / H-Beam',
  ];

  @override
  void initState() {
    super.initState();
    _performCalculation();
  }

  @override
  void dispose() {
    _lengthController.dispose();
    _widthController.dispose();
    _thicknessController.dispose();
    _outerDiaController.dispose();
    _heightController.dispose();
    _webThicknessController.dispose();
    _flangeThicknessController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _customDensityController.dispose();
    super.dispose();
  }

  double _getEffectiveDensity() {
    if (_selectedMetal == 'Custom') {
      return double.tryParse(_customDensityController.text) ?? 7.85;
    }
    return _metalDensities[_selectedMetal] ?? 7.85;
  }

  void _performCalculation() {
    final double l = double.tryParse(_lengthController.text) ?? 0.0;
    final double w = double.tryParse(_widthController.text) ?? 0.0;
    final double t = double.tryParse(_thicknessController.text) ?? 0.0;
    final double d = double.tryParse(_outerDiaController.text) ?? 0.0;
    final double h = double.tryParse(_heightController.text) ?? 0.0;
    final double tw = double.tryParse(_webThicknessController.text) ?? 0.0;
    final double tf = double.tryParse(_flangeThicknessController.text) ?? 0.0;
    final double q = double.tryParse(_quantityController.text) ?? 1.0;
    final double price = double.tryParse(_priceController.text) ?? 0.0;

    final double density = _getEffectiveDensity(); // g/cm³

    double volume = 0.0; // mm³ or in³
    double surfaceArea = 0.0; // mm² or in²

    switch (_selectedShape) {
      case 'Sheet / Plate':
      case 'Flat Bar':
        volume = l * w * t;
        surfaceArea = 2 * (l * w + l * t + w * t);
        break;

      case 'Round Bar':
        final double r = d > 0 ? d / 2 : t / 2;
        volume = math.pi * r * r * l;
        surfaceArea = 2 * math.pi * r * (r + l);
        break;

      case 'Square Bar':
        final double side = w > 0 ? w : t;
        volume = side * side * l;
        surfaceArea = 2 * side * side + 4 * side * l;
        break;

      case 'Hexagonal Bar':
        final double acrossFlats = w > 0 ? w : t;
        final double areaCross = (math.sqrt(3) / 2) * acrossFlats * acrossFlats;
        volume = areaCross * l;
        final double sideHex = acrossFlats / math.sqrt(3);
        surfaceArea = 2 * areaCross + 6 * sideHex * l;
        break;

      case 'Round Tube / Pipe':
        final double outerRadius = (d > 0 ? d : w) / 2;
        final double innerRadius = outerRadius - t;
        if (innerRadius > 0) {
          final double areaCross = math.pi * (outerRadius * outerRadius - innerRadius * innerRadius);
          volume = areaCross * l;
          surfaceArea = 2 * math.pi * outerRadius * l +
              2 * math.pi * innerRadius * l +
              2 * areaCross;
        } else {
          volume = 0.0;
          surfaceArea = 0.0;
        }
        break;

      case 'Square / Rectangular Tube':
        final double width = w > 0 ? w : d;
        final double height = h > 0 ? h : width;
        final double innerWidth = width - 2 * t;
        final double innerHeight = height - 2 * t;
        if (innerWidth > 0 && innerHeight > 0) {
          final double areaCross = (width * height) - (innerWidth * innerHeight);
          volume = areaCross * l;
          final double outerPerim = 2 * (width + height);
          final double innerPerim = 2 * (innerWidth + innerHeight);
          surfaceArea = outerPerim * l + innerPerim * l + 2 * areaCross;
        } else {
          volume = 0.0;
          surfaceArea = 0.0;
        }
        break;

      case 'Angle (L-Profile)':
        final double legA = w > 0 ? w : h;
        final double legB = h > 0 ? h : legA;
        if (legA > t && legB > t) {
          final double areaCross = t * (legA + legB - t);
          volume = areaCross * l;
          final double perim = 2 * (legA + legB);
          surfaceArea = perim * l + 2 * areaCross;
        } else {
          volume = 0.0;
          surfaceArea = 0.0;
        }
        break;

      case 'Channel (C-Profile)':
        final double heightC = h > 0 ? h : 100;
        final double widthC = w > 0 ? w : 50;
        final double tWeb = tw > 0 ? tw : t;
        final double tFlange = tf > 0 ? tf : t;
        final double areaCross = (heightC * tWeb) + (2 * widthC * tFlange) - (2 * tWeb * tFlange);
        volume = math.max(0.0, areaCross * l);
        final double perim = 4 * widthC + 2 * heightC - 2 * tWeb;
        surfaceArea = perim * l + 2 * math.max(0.0, areaCross);
        break;

      case 'I-Beam / H-Beam':
        final double heightB = h > 0 ? h : 100;
        final double widthB = w > 0 ? w : 100;
        final double tWebB = tw > 0 ? tw : t;
        final double tFlangeB = tf > 0 ? tf : t;
        final double areaCross = (2 * widthB * tFlangeB) + ((heightB - 2 * tFlangeB) * tWebB);
        volume = math.max(0.0, areaCross * l);
        final double perim = 4 * widthB + 2 * heightB - 2 * tWebB;
        surfaceArea = perim * l + 2 * math.max(0.0, areaCross);
        break;

      default:
        volume = l * w * t;
        surfaceArea = 2 * (l * w + l * t + w * t);
    }

    double weightPerPiece = 0.0;
    if (_isMetric) {
      // Volume in mm³, Density in g/cm³ -> Weight in kg = (Volume mm³ / 1,000,000) * Density
      weightPerPiece = (volume / 1000000.0) * density;
    } else {
      // Volume in in³, Density in lbs/in³ (1 g/cm³ = 0.03612729 lbs/in³)
      final double densityLbsIn3 = density * 0.03612729;
      weightPerPiece = volume * densityLbsIn3;
    }

    final double totalWeight = weightPerPiece * math.max(1.0, q);
    final double totalCost = totalWeight * price;

    setState(() {
      _calculatedVolume = volume;
      _calculatedSurfaceArea = surfaceArea;
      _calculatedWeightPerPiece = weightPerPiece;
      _calculatedTotalWeight = totalWeight;
      _calculatedCost = totalCost;
    });
  }

  void _saveCalculationToHistory() async {
    if (_calculatedTotalWeight <= 0) {
      _showSnackBar('Please enter valid dimensions first!', Colors.red);
      return;
    }

    final String unitWeight = _isMetric ? 'kg' : 'lbs';
    final String unitDim = _isMetric ? 'mm' : 'in';
    final String weightStr = '${_calculatedTotalWeight.toStringAsFixed(2)} $unitWeight';

    final String dimSummary = _getDimensionsSummary(unitDim);

    final String iconName = _getIconNameForShape(_selectedShape);

    final model = CalculationModel(
      title: '$_selectedMetal $_selectedShape',
      subtitle: '$dimSummary | Qty: ${_quantityController.text}',
      weight: weightStr,
      time: _getFormattedTime(),
      iconName: iconName,
      bgColor: const Color(0xFFE8F0FE),
      iconColor: const Color(0xFF1A73E8),
      weightValue: _calculatedTotalWeight,
      details: {
        'material': _selectedMetal,
        'shape': _selectedShape,
        'dimensions': dimSummary,
        'quantity': _quantityController.text,
        'weightPerPiece': '${_calculatedWeightPerPiece.toStringAsFixed(3)} $unitWeight',
        'totalWeight': weightStr,
        'totalCost': _calculatedCost > 0 ? _calculatedCost.toStringAsFixed(2) : null,
        'volume': _formatVolume(_calculatedVolume),
        'surfaceArea': _formatSurfaceArea(_calculatedSurfaceArea),
        'unitSystem': _isMetric ? 'Metric' : 'Imperial',
      },
    );

    await _historyService.addCalculation(model);
    _showSnackBar('Calculation saved to history!', const Color(0xFF2C3E50));
  }

  String _getIconNameForShape(String shape) {
    switch (shape) {
      case 'Round Bar':
        return 'round_bar';
      case 'Square Bar':
        return 'square_bar';
      case 'Sheet / Plate':
      case 'Flat Bar':
        return 'sheet';
      case 'Hexagonal Bar':
        return 'hexagon';
      case 'Round Tube / Pipe':
        return 'pipe';
      case 'Square / Rectangular Tube':
        return 'square';
      case 'Angle (L-Profile)':
        return 'angle';
      case 'Channel (C-Profile)':
        return 'channel';
      case 'I-Beam / H-Beam':
        return 'beam';
      default:
        return 'calculate';
    }
  }

  String _getDimensionsSummary(String unitDim) {
    final String l = _lengthController.text;
    final String w = _widthController.text;
    final String t = _thicknessController.text;
    final String d = _outerDiaController.text;
    final String h = _heightController.text;

    switch (_selectedShape) {
      case 'Round Bar':
        return 'Ø$d x L$l $unitDim';
      case 'Square Bar':
        return '$w x $w x L$l $unitDim';
      case 'Hexagonal Bar':
        return 'W$w x L$l $unitDim';
      case 'Round Tube / Pipe':
        return 'Ø$d x t$t x L$l $unitDim';
      case 'Square / Rectangular Tube':
        return '$w x $h x t$t x L$l $unitDim';
      case 'Angle (L-Profile)':
        return '$w x $h x t$t x L$l $unitDim';
      case 'Channel (C-Profile)':
      case 'I-Beam / H-Beam':
        return '$h x $w x L$l $unitDim';
      default:
        return '$l x $w x t$t $unitDim';
    }
  }

  String _getFormattedTime() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _shareResult() {
    final String unitW = _isMetric ? 'kg' : 'lbs';
    final String unitDim = _isMetric ? 'mm' : 'in';

    final String resultText = '''
═══════════════════════════════
       METAL CALCULATOR REPORT
═══════════════════════════════
Material: $_selectedMetal
Shape: $_selectedShape
Dimensions: ${_getDimensionsSummary(unitDim)}
Quantity: ${_quantityController.text} pcs
Density: ${_getEffectiveDensity().toStringAsFixed(2)} g/cm³

📏 Volume: ${_formatVolume(_calculatedVolume)}
📐 Surface Area: ${_formatSurfaceArea(_calculatedSurfaceArea)}
⚖️ Weight / Piece: ${_calculatedWeightPerPiece.toStringAsFixed(3)} $unitW
📦 Total Weight: ${_calculatedTotalWeight.toStringAsFixed(2)} $unitW
💰 Total Cost: \$${_calculatedCost.toStringAsFixed(2)}
═══════════════════════════════
Calculated with Milen Metal Calculator
''';

    Share.share(resultText, subject: 'Metal Weight Calculation Results');
  }

  void _resetFields() {
    setState(() {
      _lengthController.text = '1000';
      _widthController.text = '500';
      _thicknessController.text = '12';
      _outerDiaController.text = '50';
      _heightController.text = '100';
      _webThicknessController.text = '6';
      _flangeThicknessController.text = '8';
      _quantityController.text = '1';
      _priceController.text = '4.50';
      _customDensityController.text = '7.85';
      _selectedMetal = 'Steel';
      _selectedShape = 'Sheet / Plate';
      _isMetric = true;
      _performCalculation();
    });
    _showSnackBar('Fields reset to defaults', const Color(0xFF2C3E50));
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _formatVolume(double volume) {
    if (_isMetric) {
      if (volume >= 1e9) {
        return '${(volume / 1e9).toStringAsFixed(3)} m³';
      } else if (volume >= 1000) {
        return '${(volume / 1000).toStringAsFixed(2)} cm³';
      } else {
        return '${volume.toStringAsFixed(1)} mm³';
      }
    } else {
      if (volume >= 1728) {
        return '${(volume / 1728).toStringAsFixed(2)} ft³';
      } else {
        return '${volume.toStringAsFixed(2)} in³';
      }
    }
  }

  String _formatSurfaceArea(double sa) {
    if (_isMetric) {
      if (sa >= 1e6) {
        return '${(sa / 1e6).toStringAsFixed(3)} m²';
      } else if (sa >= 100) {
        return '${(sa / 100).toStringAsFixed(2)} cm²';
      } else {
        return '${sa.toStringAsFixed(1)} mm²';
      }
    } else {
      if (sa >= 144) {
        return '${(sa / 144).toStringAsFixed(2)} ft²';
      } else {
        return '${sa.toStringAsFixed(2)} in²';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 2,
        title: const Text(
          'Metal Calculator',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Reset Fields',
            onPressed: _resetFields,
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            tooltip: 'Share Results',
            onPressed: _shareResult,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unit Toggle Switch & Material Selector
            _buildMaterialAndUnitCard(),
            const SizedBox(height: 16),

            // Shape Selector Dropdown
            _buildShapeSelectorCard(),
            const SizedBox(height: 16),

            // Shape Preview Box
            _buildShapePreviewBox(),
            const SizedBox(height: 16),

            // Input Fields Card
            _buildDimensionInputCard(),
            const SizedBox(height: 16),

            // Results Card
            _buildResultsCard(),
            const SizedBox(height: 20),

            // Action Buttons (Save & Share)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveCalculationToHistory,
                    icon: const Icon(Icons.bookmark_add_outlined, color: Colors.white),
                    label: const Text(
                      'Save to History',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C3E50),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _shareResult,
                    icon: const Icon(Icons.share, color: Color(0xFFE67E22)),
                    label: const Text(
                      'Share Result',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFFE67E22)),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFFE67E22), width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialAndUnitCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unit system toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Unit System',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
              ),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(value: true, label: Text('Metric (mm/kg)')),
                  ButtonSegment<bool>(value: false, label: Text('Imperial (in/lbs)')),
                ],
                selected: {_isMetric},
                onSelectionChanged: (Set<bool> newSelection) {
                  setState(() {
                    _isMetric = newSelection.first;
                    _performCalculation();
                  });
                },
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: const Color(0xFFE67E22),
                  selectedForegroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          // Material Selector
          Row(
            children: [
              const Text(
                'Material',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedMetal,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: _metalDensities.keys.map((String metal) {
                    return DropdownMenuItem<String>(
                      value: metal,
                      child: Text(
                        metal == 'Custom' ? 'Custom Density' : '$metal (${_metalDensities[metal]} g/cm³)',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedMetal = val;
                        _performCalculation();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          if (_selectedMetal == 'Custom') ...[
            const SizedBox(height: 12),
            TextField(
              controller: _customDensityController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Custom Density (g/cm³)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.fitness_center),
              ),
              onChanged: (_) => _performCalculation(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShapeSelectorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Shape / Profile',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedShape,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: _shapes.map((String shape) {
              return DropdownMenuItem<String>(
                value: shape,
                child: Row(
                  children: [
                    Icon(_getIconForShape(shape), color: const Color(0xFFE67E22), size: 20),
                    const SizedBox(width: 10),
                    Text(shape, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _selectedShape = val;
                  _performCalculation();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  IconData _getIconForShape(String shape) {
    switch (shape) {
      case 'Round Bar':
        return Icons.circle;
      case 'Square Bar':
        return Icons.crop_square;
      case 'Sheet / Plate':
      case 'Flat Bar':
        return Icons.layers;
      case 'Hexagonal Bar':
        return Icons.hexagon;
      case 'Round Tube / Pipe':
        return Icons.radio_button_unchecked;
      case 'Square / Rectangular Tube':
        return Icons.square;
      case 'Angle (L-Profile)':
        return Icons.timeline;
      case 'Channel (C-Profile)':
        return Icons.view_stream;
      case 'I-Beam / H-Beam':
        return Icons.view_column;
      default:
        return Icons.calculate;
    }
  }

  Widget _buildShapePreviewBox() {
    double lenMeters = (double.tryParse(_lengthController.text) ?? 1000) / 1000.0;
    String sizeStr = _heightController.text.isNotEmpty
        ? _heightController.text
        : (_outerDiaController.text.isNotEmpty
            ? _outerDiaController.text
            : (_widthController.text.isNotEmpty ? _widthController.text : '80'));
    String thickStr = _thicknessController.text.isNotEmpty
        ? _thicknessController.text
        : (_webThicknessController.text.isNotEmpty ? _webThicknessController.text : '5');

    double weightPerM = lenMeters > 0 ? (_calculatedWeightPerPiece / lenMeters) : 0.0;
    double sectionAreaCm2 = _calculatedVolume > 0 ? (_calculatedVolume / (lenMeters * 1000)) / 100.0 : 0.0;

    return Section2DDiagramWidget(
      shapeType: _selectedShape,
      selectedSize: sizeStr,
      selectedThickness: thickStr,
      lengthMeters: lenMeters,
      overrideWeight: weightPerM,
      overrideSectionArea: sectionAreaCm2,
      onSliderChanged: (val) {
        setState(() {
          _lengthController.text = (val * 1000).toStringAsFixed(0);
          _performCalculation();
        });
      },
    );
  }


  Widget _buildDimensionInputCard() {
    final String unitDim = _isMetric ? 'mm' : 'in';
    final String unitLen = _isMetric ? 'mm' : 'in';

    List<Widget> fields = [];

    // Length is common to all
    fields.add(
      _buildInputField(
        controller: _lengthController,
        label: 'Length (L)',
        suffix: unitLen,
        icon: Icons.straighten,
      ),
    );

    switch (_selectedShape) {
      case 'Sheet / Plate':
      case 'Flat Bar':
        fields.add(const SizedBox(height: 10));
        fields.add(_buildInputField(controller: _widthController, label: 'Width (W)', suffix: unitDim, icon: Icons.straighten));
        fields.add(const SizedBox(height: 10));
        fields.add(_buildInputField(controller: _thicknessController, label: 'Thickness (T)', suffix: unitDim, icon: Icons.line_weight));
        break;

      case 'Round Bar':
        fields.add(const SizedBox(height: 10));
        fields.add(_buildInputField(controller: _outerDiaController, label: 'Diameter (D)', suffix: unitDim, icon: Icons.circle_outlined));
        break;

      case 'Square Bar':
        fields.add(const SizedBox(height: 10));
        fields.add(_buildInputField(controller: _widthController, label: 'Side Width (S)', suffix: unitDim, icon: Icons.crop_square));
        break;

      case 'Hexagonal Bar':
        fields.add(const SizedBox(height: 10));
        fields.add(_buildInputField(controller: _widthController, label: 'Distance Across Flats (W)', suffix: unitDim, icon: Icons.hexagon_outlined));
        break;

      case 'Round Tube / Pipe':
        fields.add(const SizedBox(height: 10));
        fields.add(_buildInputField(controller: _outerDiaController, label: 'Outer Diameter (D)', suffix: unitDim, icon: Icons.radio_button_unchecked));
        fields.add(const SizedBox(height: 10));
        fields.add(_buildInputField(controller: _thicknessController, label: 'Wall Thickness (T)', suffix: unitDim, icon: Icons.line_weight));
        break;

      case 'Square / Rectangular Tube':
        fields.add(const SizedBox(height: 10));
        fields.add(_buildInputField(controller: _widthController, label: 'Outer Width (W)', suffix: unitDim, icon: Icons.straighten));
        fields.add(const SizedBox(height: 10));
        fields.add(_buildInputField(controller: _heightController, label: 'Outer Height (H)', suffix: unitDim, icon: Icons.height));
        fields.add(const SizedBox(height: 10));
        fields.add(_buildInputField(controller: _thicknessController, label: 'Wall Thickness (T)', suffix: unitDim, icon: Icons.line_weight));
        break;

      case 'Angle (L-Profile)':
        fields.add(const SizedBox(height: 10));
        fields.add(_buildInputField(controller: _widthController, label: 'Leg 1 Width (A)', suffix: unitDim, icon: Icons.straighten));
        fields.add(const SizedBox(height: 10));
        fields.add(_buildInputField(controller: _heightController, label: 'Leg 2 Width (B)', suffix: unitDim, icon: Icons.height));
        fields.add(const SizedBox(height: 10));
        fields.add(_buildInputField(controller: _thicknessController, label: 'Thickness (T)', suffix: unitDim, icon: Icons.line_weight));
        break;

      case 'Channel (C-Profile)':
      case 'I-Beam / H-Beam':
        fields.add(const SizedBox(height: 10));
        fields.add(_buildInputField(controller: _heightController, label: 'Height (H)', suffix: unitDim, icon: Icons.height));
        fields.add(const SizedBox(height: 10));
        fields.add(_buildInputField(controller: _widthController, label: 'Flange Width (W)', suffix: unitDim, icon: Icons.straighten));
        fields.add(const SizedBox(height: 10));
        fields.add(_buildInputField(controller: _webThicknessController, label: 'Web Thickness (Tw)', suffix: unitDim, icon: Icons.line_weight));
        fields.add(const SizedBox(height: 10));
        fields.add(_buildInputField(controller: _flangeThicknessController, label: 'Flange Thickness (Tf)', suffix: unitDim, icon: Icons.line_weight));
        break;
    }

    // Quantity & Price
    fields.add(const SizedBox(height: 10));
    fields.add(
      Row(
        children: [
          Expanded(
            child: _buildInputField(
              controller: _quantityController,
              label: 'Quantity (pcs)',
              suffix: 'pcs',
              icon: Icons.numbers,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildInputField(
              controller: _priceController,
              label: 'Price per ${_isMetric ? 'kg' : 'lb'}',
              suffix: '\$',
              icon: Icons.attach_money,
            ),
          ),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dimensions & Parameters',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
          ),
          const SizedBox(height: 12),
          ...fields,
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String suffix,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        prefixIcon: Icon(icon, color: const Color(0xFF2C3E50), size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      onChanged: (_) => _performCalculation(),
    );
  }

  Widget _buildResultsCard() {
    final String unitW = _isMetric ? 'kg' : 'lbs';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calculation Results',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
          ),
          const SizedBox(height: 16),
          _buildResultTile(
            title: 'Total Weight',
            value: '${_calculatedTotalWeight.toStringAsFixed(2)} $unitW',
            subtitle: 'Single piece: ${_calculatedWeightPerPiece.toStringAsFixed(3)} $unitW',
            icon: Icons.balance,
            color: const Color(0xFFE67E22),
            isHighlighted: true,
          ),
          const SizedBox(height: 10),
          _buildResultTile(
            title: 'Estimated Cost',
            value: '\$${_calculatedCost.toStringAsFixed(2)}',
            subtitle: 'Based on \$${_priceController.text}/$unitW',
            icon: Icons.payments,
            color: const Color(0xFF27AE60),
            isHighlighted: false,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildSmallResultBox('Volume', _formatVolume(_calculatedVolume), Icons.view_in_ar),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSmallResultBox('Surface Area', _formatSurfaceArea(_calculatedSurfaceArea), Icons.square_foot),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultTile({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isHighlighted,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlighted ? color.withValues(alpha: 0.08) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallResultBox(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: const Color(0xFF2C3E50)),
              const SizedBox(width: 4),
              Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF2C3E50), fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
        ],
      ),
    );
  }
}
