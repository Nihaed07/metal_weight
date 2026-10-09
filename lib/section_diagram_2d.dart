import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Specification details for standard structural profile
class StandardProfileSpec {
  final double h; // height in mm
  final double b; // width in mm
  final double tw; // web thickness in mm
  final double tf; // flange thickness in mm
  final double weight; // Kg/m
  final double area; // cm2

  const StandardProfileSpec({
    required this.h,
    required this.b,
    required this.tw,
    required this.tf,
    required this.weight,
    required this.area,
  });
}

/// Comprehensive Standard Engineering Profile Specs matching Alnafie Steel & EURONORM/DIN/BS
final Map<String, StandardProfileSpec> kStandardProfilesMap = {
  // --- UPE Profiles (DIN 1026-2) ---
  'UPE 80': const StandardProfileSpec(h: 80, b: 40, tw: 4.5, tf: 7.4, weight: 7.10, area: 8.98),
  'UPE 100': const StandardProfileSpec(h: 100, b: 55, tw: 4.5, tf: 7.5, weight: 9.82, area: 12.50),
  'UPE 120': const StandardProfileSpec(h: 120, b: 60, tw: 5.0, tf: 8.0, weight: 12.10, area: 15.40),
  'UPE 140': const StandardProfileSpec(h: 140, b: 65, tw: 5.0, tf: 9.0, weight: 14.50, area: 18.40),
  'UPE 160': const StandardProfileSpec(h: 160, b: 70, tw: 5.5, tf: 9.5, weight: 17.00, area: 21.70),
  'UPE 180': const StandardProfileSpec(h: 180, b: 75, tw: 5.5, tf: 10.5, weight: 19.70, area: 25.10),
  'UPE 200': const StandardProfileSpec(h: 200, b: 80, tw: 6.0, tf: 11.0, weight: 22.80, area: 29.00),
  'UPE 220': const StandardProfileSpec(h: 220, b: 85, tw: 6.5, tf: 12.0, weight: 26.60, area: 33.90),
  'UPE 240': const StandardProfileSpec(h: 240, b: 90, tw: 7.0, tf: 12.5, weight: 30.20, area: 38.50),
  'UPE 270': const StandardProfileSpec(h: 270, b: 95, tw: 7.5, tf: 13.5, weight: 35.20, area: 44.80),
  'UPE 300': const StandardProfileSpec(h: 300, b: 100, tw: 9.5, tf: 15.0, weight: 44.40, area: 56.60),
  'UPE 330': const StandardProfileSpec(h: 330, b: 105, tw: 11.0, tf: 16.0, weight: 53.40, area: 68.00),
  'UPE 360': const StandardProfileSpec(h: 360, b: 110, tw: 12.0, tf: 17.0, weight: 61.20, area: 77.90),
  'UPE 400': const StandardProfileSpec(h: 400, b: 115, tw: 13.5, tf: 18.0, weight: 72.20, area: 91.90),

  // --- UPN / EPN Profiles (DIN 1026-1) ---
  'UPN 80': const StandardProfileSpec(h: 80, b: 45, tw: 6.0, tf: 8.0, weight: 8.64, area: 11.00),
  'UPN 100': const StandardProfileSpec(h: 100, b: 50, tw: 6.0, tf: 8.5, weight: 10.60, area: 13.50),
  'UPN 120': const StandardProfileSpec(h: 120, b: 55, tw: 7.0, tf: 9.0, weight: 13.40, area: 17.00),
  'UPN 140': const StandardProfileSpec(h: 140, b: 60, tw: 7.0, tf: 10.0, weight: 16.00, area: 20.40),
  'UPN 160': const StandardProfileSpec(h: 160, b: 65, tw: 7.5, tf: 10.5, weight: 18.80, area: 24.00),
  'UPN 180': const StandardProfileSpec(h: 180, b: 70, tw: 8.0, tf: 11.0, weight: 22.00, area: 28.00),
  'UPN 200': const StandardProfileSpec(h: 200, b: 75, tw: 8.5, tf: 11.5, weight: 25.30, area: 32.20),
  'UPN 220': const StandardProfileSpec(h: 220, b: 80, tw: 9.0, tf: 12.5, weight: 29.40, area: 37.40),
  'UPN 240': const StandardProfileSpec(h: 240, b: 85, tw: 9.5, tf: 13.0, weight: 33.20, area: 42.30),
  'UPN 270': const StandardProfileSpec(h: 270, b: 90, tw: 10.5, tf: 14.0, weight: 39.60, area: 50.40),
  'UPN 300': const StandardProfileSpec(h: 300, b: 100, tw: 10.0, tf: 16.0, weight: 46.20, area: 58.80),
  'UPN 330': const StandardProfileSpec(h: 330, b: 105, tw: 11.0, tf: 16.0, weight: 54.50, area: 69.40),
  'UPN 360': const StandardProfileSpec(h: 360, b: 110, tw: 13.0, tf: 18.0, weight: 63.90, area: 81.40),
  'UPN 400': const StandardProfileSpec(h: 400, b: 115, tw: 14.0, tf: 18.0, weight: 71.80, area: 91.50),

  // --- HEA Profiles (Euronorm 53-62) ---
  'HEA 100': const StandardProfileSpec(h: 96, b: 100, tw: 5.0, tf: 8.0, weight: 16.70, area: 21.20),
  'HEA 120': const StandardProfileSpec(h: 114, b: 120, tw: 5.0, tf: 8.0, weight: 19.90, area: 25.30),
  'HEA 140': const StandardProfileSpec(h: 133, b: 140, tw: 5.5, tf: 8.5, weight: 24.70, area: 31.40),
  'HEA 160': const StandardProfileSpec(h: 152, b: 160, tw: 6.0, tf: 9.0, weight: 30.40, area: 38.80),
  'HEA 180': const StandardProfileSpec(h: 171, b: 180, tw: 6.0, tf: 9.5, weight: 35.50, area: 45.30),
  'HEA 200': const StandardProfileSpec(h: 190, b: 200, tw: 6.5, tf: 10.0, weight: 42.30, area: 53.80),
  'HEA 220': const StandardProfileSpec(h: 210, b: 220, tw: 7.0, tf: 11.0, weight: 50.50, area: 64.30),
  'HEA 240': const StandardProfileSpec(h: 230, b: 240, tw: 7.5, tf: 12.0, weight: 60.30, area: 76.80),
  'HEA 260': const StandardProfileSpec(h: 250, b: 260, tw: 7.5, tf: 12.5, weight: 68.20, area: 86.80),
  'HEA 280': const StandardProfileSpec(h: 270, b: 280, tw: 8.0, tf: 13.0, weight: 76.40, area: 97.30),
  'HEA 300': const StandardProfileSpec(h: 290, b: 300, tw: 8.5, tf: 14.0, weight: 88.30, area: 112.50),

  // --- HEB Profiles (Euronorm 53-62) ---
  'HEB 100': const StandardProfileSpec(h: 100, b: 100, tw: 6.0, tf: 10.0, weight: 20.40, area: 26.00),
  'HEB 120': const StandardProfileSpec(h: 120, b: 120, tw: 6.5, tf: 11.0, weight: 26.70, area: 34.00),
  'HEB 140': const StandardProfileSpec(h: 140, b: 140, tw: 7.0, tf: 12.0, weight: 33.70, area: 43.00),
  'HEB 160': const StandardProfileSpec(h: 160, b: 160, tw: 8.0, tf: 13.0, weight: 42.60, area: 54.30),
  'HEB 180': const StandardProfileSpec(h: 180, b: 180, tw: 8.5, tf: 14.0, weight: 51.20, area: 65.30),
  'HEB 200': const StandardProfileSpec(h: 200, b: 200, tw: 9.0, tf: 15.0, weight: 61.30, area: 78.10),
  'HEB 220': const StandardProfileSpec(h: 220, b: 220, tw: 9.5, tf: 16.0, weight: 71.50, area: 91.00),
  'HEB 240': const StandardProfileSpec(h: 240, b: 240, tw: 10.0, tf: 17.0, weight: 83.20, area: 106.00),
  'HEB 260': const StandardProfileSpec(h: 260, b: 260, tw: 10.0, tf: 17.5, weight: 93.00, area: 118.40),
  'HEB 280': const StandardProfileSpec(h: 280, b: 280, tw: 10.5, tf: 18.0, weight: 103.00, area: 131.20),
  'HEB 300': const StandardProfileSpec(h: 300, b: 300, tw: 11.0, tf: 19.0, weight: 117.00, area: 149.10),

  // --- IPE Profiles (DIN 1025-5) ---
  'IPE 80': const StandardProfileSpec(h: 80, b: 46, tw: 3.8, tf: 5.2, weight: 6.00, area: 7.64),
  'IPE 100': const StandardProfileSpec(h: 100, b: 55, tw: 4.1, tf: 5.7, weight: 8.10, area: 10.30),
  'IPE 120': const StandardProfileSpec(h: 120, b: 64, tw: 4.4, tf: 6.3, weight: 10.40, area: 13.20),
  'IPE 140': const StandardProfileSpec(h: 140, b: 73, tw: 4.7, tf: 6.9, weight: 12.90, area: 16.40),
  'IPE 160': const StandardProfileSpec(h: 160, b: 82, tw: 5.0, tf: 7.4, weight: 15.80, area: 20.10),
  'IPE 180': const StandardProfileSpec(h: 180, b: 91, tw: 5.3, tf: 8.0, weight: 18.80, area: 23.90),
  'IPE 200': const StandardProfileSpec(h: 200, b: 100, tw: 5.6, tf: 8.5, weight: 22.40, area: 28.50),
  'IPE 220': const StandardProfileSpec(h: 220, b: 110, tw: 5.9, tf: 9.2, weight: 26.20, area: 33.40),
  'IPE 240': const StandardProfileSpec(h: 240, b: 120, tw: 6.2, tf: 9.8, weight: 30.70, area: 39.10),
  'IPE 270': const StandardProfileSpec(h: 270, b: 135, tw: 6.6, tf: 10.2, weight: 36.10, area: 45.90),
  'IPE 300': const StandardProfileSpec(h: 300, b: 150, tw: 7.1, tf: 10.7, weight: 42.20, area: 53.80),
};

/// Interactive 2D Blueprint Engineering Diagram Widget matching Alnafie Steel UI aesthetics
class Section2DDiagramWidget extends StatefulWidget {
  final String shapeType; // e.g. 'UPE/UPN', 'Bars', 'Angle Equal', 'Beams', etc.
  final String selectedSize;
  final String selectedThickness;
  final double lengthMeters;
  final List<String>? availableSizes;
  final ValueChanged<String>? onVariantChanged;
  final ValueChanged<double>? onSliderChanged;
  final ValueChanged<String>? onSizeChanged;
  final String? activeVariant;
  final double? overrideWeight;
  final double? overrideSectionArea;

  const Section2DDiagramWidget({
    super.key,
    required this.shapeType,
    required this.selectedSize,
    required this.selectedThickness,
    this.lengthMeters = 6.0,
    this.availableSizes,
    this.onVariantChanged,
    this.onSliderChanged,
    this.onSizeChanged,
    this.activeVariant,
    this.overrideWeight,
    this.overrideSectionArea,
  });

  @override
  State<Section2DDiagramWidget> createState() => _Section2DDiagramWidgetState();
}

class _Section2DDiagramWidgetState extends State<Section2DDiagramWidget>
    with SingleTickerProviderStateMixin {
  late String _currentVariant;
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    _currentVariant = widget.activeVariant ?? _getDefaultVariant(widget.shapeType);
    _sliderValue = _calcInitialSliderVal();
  }

  @override
  void didUpdateWidget(covariant Section2DDiagramWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeVariant != null && widget.activeVariant != _currentVariant) {
      _currentVariant = widget.activeVariant!;
      _sliderValue = _calcInitialSliderVal();
    } else if (widget.shapeType != oldWidget.shapeType) {
      _currentVariant = widget.activeVariant ?? _getDefaultVariant(widget.shapeType);
      _sliderValue = _calcInitialSliderVal();
    } else if (widget.selectedSize != oldWidget.selectedSize) {
      _sliderValue = _calcInitialSliderVal();
    }
  }

  List<String> _getActiveSizes() {
    if (widget.availableSizes != null && widget.availableSizes!.isNotEmpty) {
      return widget.availableSizes!;
    }
    return _getSizesForVariant(widget.shapeType, _currentVariant);
  }

  double _calcInitialSliderVal() {
    final List<String> sizes = _getActiveSizes();
    if (sizes.isEmpty) return 0.5;
    int idx = sizes.indexOf(widget.selectedSize);
    if (idx < 0) {
      String cleanSelected = widget.selectedSize.replaceAll(RegExp(r'[^0-9.]'), '');
      idx = sizes.indexWhere((s) => s.replaceAll(RegExp(r'[^0-9.]'), '') == cleanSelected);
    }
    if (idx < 0) idx = 0;
    return sizes.length > 1 ? idx / (sizes.length - 1) : 0.5;
  }

  String _getDefaultVariant(String shape) {
    if (shape.contains('UPE') || shape.contains('UPN') || shape.contains('U-Channel')) {
      return 'UPE';
    } else if (shape.contains('Angle') || shape.contains('ANGLE')) {
      return 'Equal';
    } else if (shape.contains('HEA') || shape.contains('HEB')) {
      return 'HEA';
    } else if (shape.contains('UB') || shape.contains('UC') || shape.contains('Beams')) {
      return 'UB';
    } else if (shape.contains('Bar') || shape == 'Bars') {
      return 'Round Bar';
    } else if (shape.contains('Sheet') || shape.contains('Sheets')) {
      return 'Sheet';
    } else if (shape.contains('Tube') || shape.contains('Pipe')) {
      return 'Round Tube';
    }
    return shape;
  }

  List<String> _getAvailableVariants(String shape) {
    if (shape.contains('UPE') || shape.contains('UPN') || shape.contains('U-Channel')) {
      return ['UPE', 'UPN'];
    } else if (shape.contains('HEA') || shape.contains('HEB')) {
      return ['HEA', 'HEB'];
    } else if (shape.contains('UB') || shape.contains('UC') || shape.contains('Beams')) {
      return ['UB', 'UC', 'IPE'];
    } else if (shape.contains('Angle') || shape.contains('ANGLE')) {
      return ['Equal', 'Unequal'];
    } else if (shape.contains('Bar') || shape == 'Bars') {
      return ['Round Bar', 'Square Bar'];
    } else if (shape.contains('Tube') || shape.contains('Pipe')) {
      return ['Round Tube', 'Square Tube'];
    }
    return [];
  }

  List<String> _getSizesForVariant(String shape, String variant) {
    if (variant == 'UPE') {
      return ['UPE 80', 'UPE 100', 'UPE 120', 'UPE 140', 'UPE 160', 'UPE 180', 'UPE 200', 'UPE 220', 'UPE 240', 'UPE 270', 'UPE 300', 'UPE 330', 'UPE 360', 'UPE 400'];
    } else if (variant == 'UPN') {
      return ['UPN 80', 'UPN 100', 'UPN 120', 'UPN 140', 'UPN 160', 'UPN 180', 'UPN 200', 'UPN 220', 'UPN 240', 'UPN 270', 'UPN 300', 'UPN 330', 'UPN 360', 'UPN 400'];
    } else if (variant == 'HEA') {
      return ['HEA 100', 'HEA 120', 'HEA 140', 'HEA 160', 'HEA 180', 'HEA 200', 'HEA 220', 'HEA 240', 'HEA 260', 'HEA 280', 'HEA 300'];
    } else if (variant == 'HEB') {
      return ['HEB 100', 'HEB 120', 'HEB 140', 'HEB 160', 'HEB 180', 'HEB 200', 'HEB 220', 'HEB 240', 'HEB 260', 'HEB 280', 'HEB 300'];
    } else if (variant == 'IPE') {
      return ['IPE 80', 'IPE 100', 'IPE 120', 'IPE 140', 'IPE 160', 'IPE 180', 'IPE 200', 'IPE 220', 'IPE 240', 'IPE 270', 'IPE 300'];
    } else if (variant == 'UB' || variant == 'UC') {
      return ['100', '120', '140', '160', '180', '200', '220', '240', '260', '280', '300', '320', '340', '360'];
    } else if (variant == 'Round Bar' || variant == 'Square Bar') {
      return ['6', '8', '10', '12', '14', '16', '18', '20', '22', '25', '28', '30', '32', '36', '40'];
    }
    return ['20', '25', '30', '40', '50', '60', '75', '100', '120', '150', '200'];
  }

  void _onVariantTap(String variant) {
    setState(() {
      _currentVariant = variant;
      _sliderValue = 0.0;
    });
    widget.onVariantChanged?.call(variant);
    final sizes = _getSizesForVariant(widget.shapeType, variant);
    if (sizes.isNotEmpty) {
      widget.onSizeChanged?.call(sizes.first);
    }
  }

  void _onSliderSlide(double val) {
    setState(() {
      _sliderValue = val;
    });

    final sizes = _getActiveSizes();
    if (sizes.isNotEmpty) {
      int idx = (val * (sizes.length - 1)).round().clamp(0, sizes.length - 1);
      final String targetSize = sizes[idx];
      if (targetSize != widget.selectedSize) {
        widget.onSizeChanged?.call(targetSize);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final DiagramData data = DiagramData.calculate(
      shapeType: widget.shapeType,
      variant: _currentVariant,
      sizeStr: widget.selectedSize,
      thickStr: widget.selectedThickness,
      lengthMeters: widget.lengthMeters,
      overrideWeight: widget.overrideWeight,
      overrideSectionArea: widget.overrideSectionArea,
    );

    final List<String> availableVariants = _getAvailableVariants(widget.shapeType);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003E80).withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF0A58A5).withValues(alpha: 0.15),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Bar matching Alnafie Steel deep blue top bar
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF003E80),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.headerTitle.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '2D BLUEPRINT VIEW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sub-Tabs Row (e.g. UPE | UPN) matching Alnafie screenshot
          if (availableVariants.isNotEmpty)
            Container(
              color: const Color(0xFF003E80),
              child: Row(
                children: availableVariants.map((v) {
                  final bool isSelected = (v == _currentVariant);
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _onVariantTap(v),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: isSelected ? Colors.white : Colors.transparent,
                              width: 3.0,
                            ),
                          ),
                        ),
                        child: Text(
                          v,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // Main 2D Blueprint Canvas
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
            child: SizedBox(
              height: 230,
              width: double.infinity,
              child: TweenAnimationBuilder<DiagramData>(
                tween: DiagramDataTween(begin: data, end: data),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                builder: (context, animData, child) {
                  return CustomPaint(
                    size: const Size(double.infinity, 230),
                    painter: Section2DPainter(data: animData),
                  );
                },
              ),
            ),
          ),

          // Bottom Interactive Size Slider Slider Control
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: const Color(0xFF0A58A5).withValues(alpha: 0.3),
                inactiveTrackColor: Colors.grey.shade200,
                thumbColor: const Color(0xFF0A58A5),
                overlayColor: const Color(0xFF0A58A5).withValues(alpha: 0.12),
                trackHeight: 6.0,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
              ),
              child: Slider(
                value: _sliderValue.clamp(0.0, 1.0),
                onChanged: _onSliderSlide,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Model holding dimension & property data for 2D cross-section diagram
class DiagramData {
  final String headerTitle;
  final String shapeCategory; // 'U_CHANNEL', 'ANGLE', 'BEAM', 'BAR', 'TUBE', 'SHEET', 'FLAT'
  final String displayName;
  final double heightVal; // H (mm)
  final double widthVal; // B (mm)
  final double webThickVal; // tw (mm)
  final double flangeThickVal; // tf (mm)
  final double diameterVal; // d (mm)
  final double weightVal; // Kg/m
  final double sectionAreaVal; // cm2
  final double lengthMeters;

  DiagramData({
    required this.headerTitle,
    required this.shapeCategory,
    required this.displayName,
    required this.heightVal,
    required this.widthVal,
    required this.webThickVal,
    required this.flangeThickVal,
    required this.diameterVal,
    required this.weightVal,
    required this.sectionAreaVal,
    required this.lengthMeters,
  });

  factory DiagramData.calculate({
    required String shapeType,
    required String variant,
    required String sizeStr,
    required String thickStr,
    required double lengthMeters,
    double? overrideWeight,
    double? overrideSectionArea,
  }) {
    double sizeNum = double.tryParse(sizeStr) ?? 80.0;
    double thickNum = double.tryParse(thickStr) ?? 5.0;

    String category = 'U_CHANNEL';
    String title = shapeType;
    String dispName = variant.isNotEmpty ? variant : shapeType;

    double h = 80;
    double b = 40;
    double tw = 4.5;
    double tf = 7.4;
    double d = 0;
    double w = 7.1;
    double area = 8.98;

    if (shapeType.contains('UPE') || shapeType.contains('UPN') || shapeType.contains('U-Channel')) {
      category = 'U_CHANNEL';
      title = 'UPE EPN';
      dispName = variant.contains('UPN') ? 'UPN' : 'UPE';

      // Check standard profile specs map first
      String lookupKey = '$dispName ${sizeStr.replaceAll(RegExp(r'[^0-9.]'), '')}';
      if (lookupKey == 'UPE ' || lookupKey == 'UPN ') {
        lookupKey = '$dispName ${sizeNum.toInt()}';
      }

      if (kStandardProfilesMap.containsKey(lookupKey)) {
        final spec = kStandardProfilesMap[lookupKey]!;
        h = spec.h;
        b = spec.b;
        tw = spec.tw;
        tf = spec.tf;
        w = spec.weight;
        area = spec.area;
      } else if (dispName == 'UPE') {
        h = sizeNum;
        b = (sizeNum * 0.5).clamp(40, 100);
        tw = (sizeNum * 0.055).clamp(4.5, 9.5);
        tf = (sizeNum * 0.09).clamp(7.4, 15.0);
        w = (sizeNum * 0.09 + 0.1).clamp(7.1, 45.0);
        area = w * 1.26;
      } else {
        h = sizeNum;
        b = (sizeNum * 0.52).clamp(45, 105);
        tw = (sizeNum * 0.07).clamp(6.0, 11.0);
        tf = (sizeNum * 0.10).clamp(8.0, 16.0);
        w = (sizeNum * 0.105).clamp(8.64, 48.0);
        area = w * 1.27;
      }
    } else if (shapeType.contains('Angle') || shapeType.contains('ANGLE')) {
      category = 'ANGLE';
      title = 'ANGLE PROFILE';
      dispName = 'ANGLE';

      if (variant == 'Unequal') {
        h = sizeNum;
        b = (sizeNum * 0.65).clamp(30, 150);
        tw = thickNum;
        tf = thickNum;
        w = ((h + b - thickNum) * thickNum * 0.00785).clamp(1.5, 45.0);
        area = w * 1.27;
      } else {
        h = sizeNum;
        b = sizeNum;
        tw = thickNum;
        tf = thickNum;
        w = ((h + b - thickNum) * thickNum * 0.00785).clamp(0.88, 50.0);
        area = w * 1.27;
      }
    } else if (shapeType.contains('Beams') ||
        shapeType.contains('UB') ||
        shapeType.contains('UC') ||
        shapeType.contains('HEA') ||
        shapeType.contains('HEB') ||
        shapeType.contains('JIS') ||
        shapeType.contains('W Beam')) {
      category = 'BEAM';
      dispName = variant.isNotEmpty ? variant : 'BEAM';
      if (dispName.contains('HEA')) {
        title = 'HEA PROFILE';
      } else if (dispName.contains('HEB')) {
        title = 'HEB PROFILE';
      } else {
        title = 'BEAM PROFILE';
      }

      String lookupKey = '$dispName ${sizeStr.replaceAll(RegExp(r'[^0-9.]'), '')}';
      if (kStandardProfilesMap.containsKey(lookupKey)) {
        final spec = kStandardProfilesMap[lookupKey]!;
        h = spec.h;
        b = spec.b;
        tw = spec.tw;
        tf = spec.tf;
        w = spec.weight;
        area = spec.area;
      } else {
        h = sizeNum;
        if (variant.contains('HEB') || variant.contains('UC')) {
          b = sizeNum;
          tw = (sizeNum * 0.06).clamp(6.0, 14.0);
          tf = (sizeNum * 0.10).clamp(10.0, 22.0);
          w = (sizeNum * 0.204).clamp(20.4, 150.0);
        } else {
          b = (sizeNum * 0.55).clamp(55, 200);
          tw = (sizeNum * 0.045).clamp(4.1, 10.0);
          tf = (sizeNum * 0.075).clamp(5.7, 16.0);
          w = (sizeNum * 0.167).clamp(16.7, 120.0);
        }
        area = w * 1.27;
      }
    } else if (shapeType.contains('Bar') || shapeType == 'Bars') {
      category = 'BAR';
      title = 'ROUND & SQUARE BAR';
      dispName = variant.contains('Square') ? 'SQUARE BAR' : 'ROUND BAR';
      d = sizeNum;
      h = sizeNum;
      b = sizeNum;
      if (variant.contains('Square')) {
        w = (sizeNum * sizeNum * 0.00785).clamp(0.2, 80.0);
        area = (sizeNum * sizeNum / 100.0);
      } else {
        w = (math.pi * (sizeNum / 2) * (sizeNum / 2) * 0.00785).clamp(0.22, 60.0);
        area = (math.pi * (sizeNum / 2) * (sizeNum / 2) / 100.0);
      }
    } else if (shapeType.contains('Sheet') || shapeType.contains('Sheets')) {
      category = 'SHEET';
      title = 'STEEL SHEET / PLATE';
      dispName = 'SHEET';
      tw = thickNum > 0 ? thickNum : sizeNum;
      h = tw;
      b = 1000;
      w = (tw * 7.85).clamp(7.85, 120.0);
      area = (tw * 10.0);
    } else if (shapeType.contains('Flats')) {
      category = 'FLAT';
      title = 'FLAT BAR';
      dispName = 'FLAT';
      b = sizeNum;
      h = thickNum;
      tw = thickNum;
      w = (b * h * 0.00785).clamp(0.47, 50.0);
      area = (b * h / 100.0);
    } else if (shapeType.contains('Tube') || shapeType.contains('Pipe')) {
      category = 'TUBE';
      title = 'TUBE & PIPE';
      dispName = variant.contains('Square') ? 'SQUARE TUBE' : 'ROUND TUBE';
      d = sizeNum;
      h = sizeNum;
      b = sizeNum;
      tw = thickNum;
      w = (math.pi * (sizeNum - thickNum) * thickNum * 0.00785).clamp(0.5, 60.0);
      area = (math.pi * (sizeNum - thickNum) * thickNum / 100.0);
    }

    return DiagramData(
      headerTitle: title,
      shapeCategory: category,
      displayName: dispName,
      heightVal: h,
      widthVal: b,
      webThickVal: tw,
      flangeThickVal: tf,
      diameterVal: d,
      weightVal: (overrideWeight != null && overrideWeight > 0) ? overrideWeight : w,
      sectionAreaVal: (overrideSectionArea != null && overrideSectionArea > 0) ? overrideSectionArea : area,
      lengthMeters: lengthMeters,
    );
  }

  static DiagramData lerp(DiagramData a, DiagramData b, double t) {
    return DiagramData(
      headerTitle: b.headerTitle,
      shapeCategory: b.shapeCategory,
      displayName: b.displayName,
      heightVal: lerpDouble(a.heightVal, b.heightVal, t),
      widthVal: lerpDouble(a.widthVal, b.widthVal, t),
      webThickVal: lerpDouble(a.webThickVal, b.webThickVal, t),
      flangeThickVal: lerpDouble(a.flangeThickVal, b.flangeThickVal, t),
      diameterVal: lerpDouble(a.diameterVal, b.diameterVal, t),
      weightVal: lerpDouble(a.weightVal, b.weightVal, t),
      sectionAreaVal: lerpDouble(a.sectionAreaVal, b.sectionAreaVal, t),
      lengthMeters: lerpDouble(a.lengthMeters, b.lengthMeters, t),
    );
  }

  static double lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}

class DiagramDataTween extends Tween<DiagramData> {
  DiagramDataTween({super.begin, super.end});

  @override
  DiagramData lerp(double t) {
    return DiagramData.lerp(begin!, end!, t);
  }
}

/// Custom 2D Blueprint Painter matching Alnafie Steel reference screenshot
class Section2DPainter extends CustomPainter {
  final DiagramData data;

  Section2DPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Background - crisp white blueprint canvas
    final Paint bgPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), bgPaint);

    // Left side info labels (Title, Weight, Section)
    _drawLeftSideInfo(canvas, size);

    // Right side profile section & technical dimensions
    switch (data.shapeCategory) {
      case 'U_CHANNEL':
        _drawUChannel2D(canvas, size);
        break;
      case 'ANGLE':
        _drawAngle2D(canvas, size);
        break;
      case 'BEAM':
        _drawBeam2D(canvas, size);
        break;
      case 'BAR':
        _drawBar2D(canvas, size);
        break;
      case 'SHEET':
      case 'FLAT':
        _drawSheetOrFlat2D(canvas, size);
        break;
      case 'TUBE':
        _drawTube2D(canvas, size);
        break;
      default:
        _drawUChannel2D(canvas, size);
        break;
    }
  }

  void _drawLeftSideInfo(Canvas canvas, Size size) {
    const double leftX = 14.0;
    const double startY = 32.0;

    // 1. Weight Row
    final TextPainter wLabelPainter = TextPainter(
      text: const TextSpan(
        text: 'weight',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C3E50),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    wLabelPainter.layout();
    wLabelPainter.paint(canvas, const Offset(leftX, startY + 2));

    // weight box value [ 7.1 ] Kg/m
    _drawBoxedValue(
      canvas,
      const Offset(leftX + 58, startY),
      data.weightVal.toStringAsFixed(1),
      'Kg/m',
    );

    // 2. Section Row
    const double sectionY = startY + 36.0;
    final TextPainter sLabelPainter = TextPainter(
      text: const TextSpan(
        text: 'section',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C3E50),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    sLabelPainter.layout();
    sLabelPainter.paint(canvas, const Offset(leftX, sectionY + 2));

    // section box value [ 8.98 ] cm2
    _drawBoxedValue(
      canvas,
      const Offset(leftX + 58, sectionY),
      data.sectionAreaVal.toStringAsFixed(2),
      'cm2',
    );
  }

  void _drawBoxedValue(Canvas canvas, Offset pos, String valText, String unitText) {
    final TextPainter vp = TextPainter(
      text: TextSpan(
        text: valText,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C3E50),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    vp.layout();

    final double boxWidth = (vp.width + 14).clamp(36.0, 90.0);
    const double boxHeight = 20.0;
    final Rect boxRect = Rect.fromLTWH(pos.dx, pos.dy, boxWidth, boxHeight);

    // White box fill with dark thin border matching reference image
    final Paint fillP = Paint()..color = Colors.white;
    final Paint borderP = Paint()
      ..color = const Color(0xFF0A58A5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawRect(boxRect, fillP);
    canvas.drawRect(boxRect, borderP);

    vp.paint(canvas, Offset(pos.dx + (boxWidth - vp.width) / 2, pos.dy + (boxHeight - vp.height) / 2));

    // Unit text next to box
    final TextPainter up = TextPainter(
      text: TextSpan(
        text: unitText,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2C3E50),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    up.layout();
    up.paint(canvas, Offset(pos.dx + boxWidth + 8, pos.dy + (boxHeight - up.height) / 2));
  }

  /// 2D U-Channel (C-Shape) matching exact reference image layout
  void _drawUChannel2D(Canvas canvas, Size size) {
    final double centerRightX = size.width * 0.58;
    const double topY = 22.0;
    const double profileH = 135.0;
    const double profileW = 60.0;
    const double flangeThick = 14.0;
    const double webThick = 12.0;

    final Path profilePath = Path();
    profilePath.moveTo(centerRightX + profileW, topY);
    profilePath.lineTo(centerRightX, topY);
    profilePath.lineTo(centerRightX, topY + profileH);
    profilePath.lineTo(centerRightX + profileW, topY + profileH);
    profilePath.lineTo(centerRightX + profileW, topY + profileH - flangeThick);
    profilePath.lineTo(centerRightX + webThick, topY + profileH - flangeThick);
    profilePath.lineTo(centerRightX + webThick, topY + flangeThick);
    profilePath.lineTo(centerRightX + profileW, topY + flangeThick);
    profilePath.close();

    // Solid Royal Blue Fill (#0A58A5)
    final Paint fillPaint = Paint()
      ..color = const Color(0xFF0A58A5)
      ..style = PaintingStyle.fill;
    canvas.drawPath(profilePath, fillPaint);

    // Dimension Extension Lines & Arrows

    // 1. Overall Height (H) - Vertical right dimension line (80)
    final double hDimX = centerRightX + profileW + 28;
    _drawExtensionLine(canvas, Offset(centerRightX + profileW, topY), Offset(hDimX + 12, topY));
    _drawExtensionLine(
        canvas, Offset(centerRightX + profileW, topY + profileH), Offset(hDimX + 12, topY + profileH));
    _drawDoubleArrowLine(
        canvas, Offset(hDimX, topY), Offset(hDimX, topY + profileH), data.heightVal.toStringAsFixed(0));

    // 2. Base Width (B) - Horizontal bottom dimension line (40)
    const double bDimY = topY + profileH + 26;
    _drawExtensionLine(
        canvas, Offset(centerRightX, topY + profileH), Offset(centerRightX, bDimY + 12));
    _drawExtensionLine(canvas, Offset(centerRightX + profileW, topY + profileH),
        Offset(centerRightX + profileW, bDimY + 12));
    _drawDoubleArrowLine(
        canvas, Offset(centerRightX, bDimY), Offset(centerRightX + profileW, bDimY), data.widthVal.toStringAsFixed(0));

    // 3. Flange Thickness Callout (tf = 7.4)
    final Offset tfArrowTarget = Offset(centerRightX + profileW * 0.6, topY + flangeThick * 0.5);
    _drawCalloutArrow(
      canvas,
      tfArrowTarget,
      Offset(centerRightX + profileW * 0.3, topY + flangeThick + 22),
      data.flangeThickVal.toStringAsFixed(1),
    );

    // 4. Web Thickness Callout (tw = 4.5)
    final Offset twArrowTarget = Offset(centerRightX + webThick * 0.5, topY + profileH * 0.5);
    _drawCalloutArrow(
      canvas,
      twArrowTarget,
      Offset(centerRightX + webThick + 26, topY + profileH * 0.5),
      data.webThickVal.toStringAsFixed(1),
    );
  }

  /// 2D Angle Profile (L-Shape)
  void _drawAngle2D(Canvas canvas, Size size) {
    final double startX = size.width * 0.55;
    const double topY = 25.0;
    const double legH = 130.0;
    const double legW = 100.0;
    const double thick = 16.0;

    final Path path = Path();
    path.moveTo(startX, topY);
    path.lineTo(startX + thick, topY);
    path.lineTo(startX + thick, topY + legH - thick);
    path.lineTo(startX + legW, topY + legH - thick);
    path.lineTo(startX + legW, topY + legH);
    path.lineTo(startX, topY + legH);
    path.close();

    canvas.drawPath(path, Paint()..color = const Color(0xFF0A58A5));

    // Height Dimension H
    final double hDimX = startX + legW + 20;
    _drawExtensionLine(canvas, Offset(startX, topY), Offset(hDimX + 10, topY));
    _drawExtensionLine(canvas, Offset(startX, topY + legH), Offset(hDimX + 10, topY + legH));
    _drawDoubleArrowLine(
        canvas, Offset(hDimX, topY), Offset(hDimX, topY + legH), data.heightVal.toStringAsFixed(0));

    // Width Dimension B
    const double bDimY = topY + legH + 24;
    _drawExtensionLine(canvas, Offset(startX, topY + legH), Offset(startX, bDimY + 10));
    _drawExtensionLine(canvas, Offset(startX + legW, topY + legH), Offset(startX + legW, bDimY + 10));
    _drawDoubleArrowLine(
        canvas, Offset(startX, bDimY), Offset(startX + legW, bDimY), data.widthVal.toStringAsFixed(0));

    // Thickness callout
    _drawCalloutArrow(
      canvas,
      Offset(startX + thick * 0.5, topY + 30),
      Offset(startX + thick + 30, topY + 30),
      data.webThickVal.toStringAsFixed(1),
    );
  }

  /// 2D I-Beam / H-Beam Profile
  void _drawBeam2D(Canvas canvas, Size size) {
    final double centerX = size.width * 0.65;
    const double topY = 22.0;
    const double h = 135.0;
    const double b = 80.0;
    const double tf = 14.0;
    const double tw = 12.0;

    final Path path = Path();
    path.moveTo(centerX - b / 2, topY);
    path.lineTo(centerX + b / 2, topY);
    path.lineTo(centerX + b / 2, topY + tf);
    path.lineTo(centerX + tw / 2, topY + tf);
    path.lineTo(centerX + tw / 2, topY + h - tf);
    path.lineTo(centerX + b / 2, topY + h - tf);
    path.lineTo(centerX + b / 2, topY + h);
    path.lineTo(centerX - b / 2, topY + h);
    path.lineTo(centerX - b / 2, topY + h - tf);
    path.lineTo(centerX - tw / 2, topY + h - tf);
    path.lineTo(centerX - tw / 2, topY + tf);
    path.lineTo(centerX - b / 2, topY + tf);
    path.close();

    canvas.drawPath(path, Paint()..color = const Color(0xFF0A58A5));

    // Height H
    final double hDimX = centerX + b / 2 + 20;
    _drawExtensionLine(canvas, Offset(centerX + b / 2, topY), Offset(hDimX + 10, topY));
    _drawExtensionLine(canvas, Offset(centerX + b / 2, topY + h), Offset(hDimX + 10, topY + h));
    _drawDoubleArrowLine(canvas, Offset(hDimX, topY), Offset(hDimX, topY + h), data.heightVal.toStringAsFixed(0));

    // Width B
    const double bDimY = topY + h + 24;
    _drawExtensionLine(canvas, Offset(centerX - b / 2, topY + h), Offset(centerX - b / 2, bDimY + 10));
    _drawExtensionLine(canvas, Offset(centerX + b / 2, topY + h), Offset(centerX + b / 2, bDimY + 10));
    _drawDoubleArrowLine(
        canvas, Offset(centerX - b / 2, bDimY), Offset(centerX + b / 2, bDimY), data.widthVal.toStringAsFixed(0));

    // Web thick tw
    _drawCalloutArrow(
      canvas,
      Offset(centerX, topY + h * 0.5),
      Offset(centerX + tw / 2 + 30, topY + h * 0.5),
      data.webThickVal.toStringAsFixed(1),
    );

    // Flange thick tf
    _drawCalloutArrow(
      canvas,
      Offset(centerX + b * 0.3, topY + tf * 0.5),
      Offset(centerX + b * 0.3 + 25, topY - 12),
      data.flangeThickVal.toStringAsFixed(1),
    );
  }

  /// 2D Round / Square Bar Section
  void _drawBar2D(Canvas canvas, Size size) {
    final Offset center = Offset(size.width * 0.65, size.height * 0.45);
    const double radius = 55.0;

    if (data.displayName.contains('SQUARE')) {
      final Rect rect = Rect.fromCenter(center: center, width: radius * 1.8, height: radius * 1.8);
      canvas.drawRect(rect, Paint()..color = const Color(0xFF0A58A5));

      // Side Dimension
      final double dimY = center.dy + radius + 22;
      _drawDoubleArrowLine(
        canvas,
        Offset(center.dx - radius, dimY),
        Offset(center.dx + radius, dimY),
        data.diameterVal.toStringAsFixed(0),
      );
    } else {
      canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF0A58A5));

      // Center crosshairs (blueprint style)
      final Paint crossPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.6)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(center.dx - radius - 10, center.dy), Offset(center.dx + radius + 10, center.dy), crossPaint);
      canvas.drawLine(Offset(center.dx, center.dy - radius - 10), Offset(center.dx, center.dy + radius + 10), crossPaint);

      // Diameter Callout
      _drawDoubleArrowLine(
        canvas,
        Offset(center.dx - radius, center.dy + radius + 22),
        Offset(center.dx + radius, center.dy + radius + 22),
        'Ø ${data.diameterVal.toStringAsFixed(0)}',
      );
    }
  }

  /// 2D Sheet / Flat Bar Slab Section
  void _drawSheetOrFlat2D(Canvas canvas, Size size) {
    final double startX = size.width * 0.52;
    final double topY = size.height * 0.35;
    const double slabW = 145.0;
    const double slabH = 38.0;

    final Rect rect = Rect.fromLTWH(startX, topY, slabW, slabH);
    canvas.drawRect(rect, Paint()..color = const Color(0xFF0A58A5));
    canvas.drawRect(
      rect,
      Paint()
        ..color = const Color(0xFF002855)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Hatching lines strictly clipped inside section rect (Texture Alignment)
    canvas.save();
    canvas.clipRect(rect);
    final Paint hatchPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 1.5;
    for (double x = startX - slabH; x < startX + slabW + slabH; x += 14) {
      canvas.drawLine(Offset(x, topY + slabH), Offset(x + slabH, topY), hatchPaint);
    }
    canvas.restore();

    // Thickness dimension (t)
    final double hDimX = startX + slabW + 18;
    _drawExtensionLine(canvas, Offset(startX + slabW, topY), Offset(hDimX + 10, topY));
    _drawExtensionLine(canvas, Offset(startX + slabW, topY + slabH), Offset(hDimX + 10, topY + slabH));
    _drawDoubleArrowLine(
      canvas,
      Offset(hDimX, topY),
      Offset(hDimX, topY + slabH),
      't=${data.webThickVal.toStringAsFixed(1)}',
    );

    // Width dimension (W)
    final double bDimY = topY + slabH + 22;
    _drawDoubleArrowLine(
      canvas,
      Offset(startX, bDimY),
      Offset(startX + slabW, bDimY),
      data.widthVal.toStringAsFixed(0),
    );
  }

  /// 2D Tube / Pipe Hollow Section
  void _drawTube2D(Canvas canvas, Size size) {
    final Offset center = Offset(size.width * 0.65, size.height * 0.45);
    const double outerR = 55.0;
    const double innerR = 38.0;

    if (data.displayName.contains('SQUARE')) {
      final Path path = Path()
        ..addRect(Rect.fromCenter(center: center, width: outerR * 2, height: outerR * 2))
        ..addRect(Rect.fromCenter(center: center, width: innerR * 2, height: innerR * 2));
      path.fillType = PathFillType.evenOdd;
      canvas.drawPath(path, Paint()..color = const Color(0xFF0A58A5));

      _drawDoubleArrowLine(
        canvas,
        Offset(center.dx - outerR, center.dy + outerR + 22),
        Offset(center.dx + outerR, center.dy + outerR + 22),
        data.diameterVal.toStringAsFixed(0),
      );
    } else {
      final Path path = Path()
        ..addOval(Rect.fromCircle(center: center, radius: outerR))
        ..addOval(Rect.fromCircle(center: center, radius: innerR));
      path.fillType = PathFillType.evenOdd;
      canvas.drawPath(path, Paint()..color = const Color(0xFF0A58A5));

      // Wall thickness callout
      _drawCalloutArrow(
        canvas,
        Offset(center.dx + (outerR + innerR) / 2, center.dy),
        Offset(center.dx + outerR + 25, center.dy - 20),
        't=${data.webThickVal.toStringAsFixed(1)}',
      );

      _drawDoubleArrowLine(
        canvas,
        Offset(center.dx - outerR, center.dy + outerR + 22),
        Offset(center.dx + outerR, center.dy + outerR + 22),
        'OD ${data.diameterVal.toStringAsFixed(0)}',
      );
    }
  }

  // --- Helper Methods for Blueprint Dimension Lines ---

  void _drawExtensionLine(Canvas canvas, Offset p1, Offset p2) {
    final Paint paint = Paint()
      ..color = const Color(0xFF7F8C8D)
      ..strokeWidth = 0.8;
    canvas.drawLine(p1, p2, paint);
  }

  void _drawDoubleArrowLine(Canvas canvas, Offset p1, Offset p2, String label) {
    final Paint linePaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..strokeWidth = 1.2;

    canvas.drawLine(p1, p2, linePaint);

    // Arrowheads
    const double arrowSize = 5.0;
    final double angle = math.atan2(p2.dy - p1.dy, p2.dx - p1.dx);

    _drawArrowHead(canvas, p1, angle, arrowSize);
    _drawArrowHead(canvas, p2, angle + math.pi, arrowSize);

    // Boxed numerical callout [ 80 ] centered on dimension line
    final Offset midPoint = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
    _drawBoxedText(canvas, midPoint, label);
  }

  void _drawArrowHead(Canvas canvas, Offset tip, double angle, double size) {
    final Path path = Path();
    path.moveTo(tip.dx, tip.dy);
    path.lineTo(
      tip.dx + size * math.cos(angle + math.pi / 6),
      tip.dy + size * math.sin(angle + math.pi / 6),
    );
    path.lineTo(
      tip.dx + size * math.cos(angle - math.pi / 6),
      tip.dy + size * math.sin(angle - math.pi / 6),
    );
    path.close();

    canvas.drawPath(path, Paint()..color = const Color(0xFF2C3E50));
  }

  void _drawCalloutArrow(Canvas canvas, Offset target, Offset labelPos, String label) {
    final Paint paint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..strokeWidth = 1.0;

    canvas.drawLine(target, labelPos, paint);

    final double angle = math.atan2(target.dy - labelPos.dy, target.dx - labelPos.dx);
    _drawArrowHead(canvas, target, angle + math.pi, 5.0);

    _drawBoxedText(canvas, labelPos, label);
  }

  void _drawBoxedText(Canvas canvas, Offset center, String text) {
    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C3E50),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    final Rect boxRect = Rect.fromCenter(
      center: center,
      width: tp.width + 10,
      height: tp.height + 4,
    );

    // Box fill white with dark border
    canvas.drawRect(boxRect, Paint()..color = Colors.white);
    canvas.drawRect(
      boxRect,
      Paint()
        ..color = const Color(0xFF2C3E50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9,
    );

    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant Section2DPainter oldDelegate) {
    return oldDelegate.data.heightVal != data.heightVal ||
        oldDelegate.data.widthVal != data.widthVal ||
        oldDelegate.data.webThickVal != data.webThickVal ||
        oldDelegate.data.flangeThickVal != data.flangeThickVal ||
        oldDelegate.data.diameterVal != data.diameterVal ||
        oldDelegate.data.weightVal != data.weightVal ||
        oldDelegate.data.sectionAreaVal != data.sectionAreaVal ||
        oldDelegate.data.lengthMeters != data.lengthMeters ||
        oldDelegate.data.displayName != data.displayName;
  }
}
