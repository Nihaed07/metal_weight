import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metal_weight/section_diagram_2d.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _lastPressedAt;
  String _selectedShape = 'Bars';
  String _selectedSize = '100';
  final String _selectedThickness = '3';
  double _pieceLength = 6.0; // Standard bar length in meters (0.5m - 12.0m)

  void _onLengthChanged(double length) {
    setState(() {
      _pieceLength = length;
      _updateResults();
    });
  }

  // Controllers
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();

  // Shape dropdown items - Updated with all categories from image
  final List<String> _shapes = [
    // From image
    'Bars',
    'Sheets',
    'Flats',
    'Angle Equal',
    'Angle Unequal',
    'Japanese U-Channel',
    'Beams',
    'HEA/HEB',
    'JIS',
    'UPE/UPN',
    // Keeping existing for backward compatibility
    'UB',
    'UC',
    'W Beam',
    'SS ANGLE',
    'SS SHEET',
    'SS ROUND BAR',
    'ALUMINUM ANGLE',
    'ALUMINUM ROUND BAR',
    'ALUMINUM SHEET',
    'ALUMINUM CHECKERED SHEET',
    'BRASS SHEET',
    'BRASS ROUND BAR',
    'COPPER SHEET',
    'COPPER ROUND BAR',
  ];

  // Data for Bars
  final Map<String, Map<String, String>> _barsData = {
    '6': {'weight': '0.22', 'section': '0.28'},
    '8': {'weight': '0.39', 'section': '0.50'},
    '10': {'weight': '0.62', 'section': '0.79'},
    '12': {'weight': '0.89', 'section': '1.13'},
    '14': {'weight': '1.21', 'section': '1.54'},
    '16': {'weight': '1.58', 'section': '2.01'},
    '18': {'weight': '2.00', 'section': '2.54'},
    '20': {'weight': '2.47', 'section': '3.14'},
    '22': {'weight': '2.98', 'section': '3.80'},
    '25': {'weight': '3.85', 'section': '4.91'},
    '28': {'weight': '4.83', 'section': '6.16'},
    '30': {'weight': '5.55', 'section': '7.07'},
    '32': {'weight': '6.31', 'section': '8.04'},
    '36': {'weight': '7.99', 'section': '10.18'},
    '40': {'weight': '9.86', 'section': '12.57'},
  };

  // Data for Sheets
  final Map<String, Map<String, String>> _sheetsData = {
    '1.0': {'weight': '7.85', 'section': '1.00'},
    '1.2': {'weight': '9.42', 'section': '1.20'},
    '1.5': {'weight': '11.78', 'section': '1.50'},
    '2.0': {'weight': '15.70', 'section': '2.00'},
    '2.5': {'weight': '19.63', 'section': '2.50'},
    '3.0': {'weight': '23.55', 'section': '3.00'},
    '4.0': {'weight': '31.40', 'section': '4.00'},
    '5.0': {'weight': '39.25', 'section': '5.00'},
    '6.0': {'weight': '47.10', 'section': '6.00'},
    '8.0': {'weight': '62.80', 'section': '8.00'},
    '10.0': {'weight': '78.50', 'section': '10.00'},
  };

  // Data for Flats
  final Map<String, Map<String, Map<String, String>>> _flatsData = {
    '20': {
      '3': {'weight': '0.47', 'section': '0.60'},
      '4': {'weight': '0.63', 'section': '0.80'},
      '5': {'weight': '0.79', 'section': '1.00'},
    },
    '25': {
      '3': {'weight': '0.59', 'section': '0.75'},
      '4': {'weight': '0.79', 'section': '1.00'},
      '5': {'weight': '0.98', 'section': '1.25'},
      '6': {'weight': '1.18', 'section': '1.50'},
    },
    '30': {
      '3': {'weight': '0.71', 'section': '0.90'},
      '4': {'weight': '0.94', 'section': '1.20'},
      '5': {'weight': '1.18', 'section': '1.50'},
      '6': {'weight': '1.41', 'section': '1.80'},
    },
    '40': {
      '4': {'weight': '1.26', 'section': '1.60'},
      '5': {'weight': '1.57', 'section': '2.00'},
      '6': {'weight': '1.88', 'section': '2.40'},
      '8': {'weight': '2.51', 'section': '3.20'},
    },
    '50': {
      '5': {'weight': '1.96', 'section': '2.50'},
      '6': {'weight': '2.36', 'section': '3.00'},
      '8': {'weight': '3.14', 'section': '4.00'},
      '10': {'weight': '3.93', 'section': '5.00'},
    },
    '60': {
      '6': {'weight': '2.83', 'section': '3.60'},
      '8': {'weight': '3.77', 'section': '4.80'},
      '10': {'weight': '4.71', 'section': '6.00'},
      '12': {'weight': '5.65', 'section': '7.20'},
    },
    '75': {
      '8': {'weight': '4.71', 'section': '6.00'},
      '10': {'weight': '5.89', 'section': '7.50'},
      '12': {'weight': '7.07', 'section': '9.00'},
      '16': {'weight': '9.42', 'section': '12.00'},
    },
    '100': {
      '10': {'weight': '7.85', 'section': '10.00'},
      '12': {'weight': '9.42', 'section': '12.00'},
      '16': {'weight': '12.56', 'section': '16.00'},
      '20': {'weight': '15.70', 'section': '20.00'},
    },
  };

  // Data for Angle Equal
  final Map<String, Map<String, Map<String, String>>> _angleEqualData = {
    '20': {
      '3': {'weight': '0.88', 'section': '1.12'},
      '4': {'weight': '1.15', 'section': '1.46'},
    },
    '25': {
      '3': {'weight': '1.12', 'section': '1.43'},
      '4': {'weight': '1.48', 'section': '1.89'},
      '5': {'weight': '1.82', 'section': '2.32'},
    },
    '30': {
      '3': {'weight': '1.36', 'section': '1.74'},
      '4': {'weight': '1.80', 'section': '2.29'},
      '5': {'weight': '2.22', 'section': '2.83'},
    },
    '35': {
      '4': {'weight': '2.12', 'section': '2.70'},
      '5': {'weight': '2.62', 'section': '3.34'},
      '6': {'weight': '3.10', 'section': '3.95'},
    },
    '40': {
      '4': {'weight': '2.44', 'section': '3.11'},
      '5': {'weight': '3.02', 'section': '3.85'},
      '6': {'weight': '3.58', 'section': '4.56'},
    },
    '45': {
      '5': {'weight': '3.42', 'section': '4.36'},
      '6': {'weight': '4.06', 'section': '5.17'},
      '8': {'weight': '5.32', 'section': '6.78'},
    },
    '50': {
      '5': {'weight': '3.82', 'section': '4.87'},
      '6': {'weight': '4.54', 'section': '5.79'},
      '8': {'weight': '5.96', 'section': '7.59'},
      '10': {'weight': '7.34', 'section': '9.35'},
    },
    '60': {
      '6': {'weight': '5.50', 'section': '7.01'},
      '8': {'weight': '7.22', 'section': '9.20'},
      '10': {'weight': '8.92', 'section': '11.37'},
    },
    '70': {
      '6': {'weight': '6.46', 'section': '8.23'},
      '8': {'weight': '8.50', 'section': '10.83'},
      '10': {'weight': '10.52', 'section': '13.40'},
    },
    '75': {
      '6': {'weight': '6.94', 'section': '8.84'},
      '8': {'weight': '9.14', 'section': '11.64'},
      '10': {'weight': '11.32', 'section': '14.42'},
      '12': {'weight': '13.46', 'section': '17.15'},
    },
    '80': {
      '6': {'weight': '7.42', 'section': '9.45'},
      '8': {'weight': '9.78', 'section': '12.46'},
      '10': {'weight': '12.12', 'section': '15.44'},
      '12': {'weight': '14.42', 'section': '18.37'},
    },
    '90': {
      '8': {'weight': '11.06', 'section': '14.09'},
      '10': {'weight': '13.72', 'section': '17.48'},
      '12': {'weight': '16.34', 'section': '20.82'},
    },
    '100': {
      '8': {'weight': '12.34', 'section': '15.72'},
      '10': {'weight': '15.32', 'section': '19.52'},
      '12': {'weight': '18.26', 'section': '23.27'},
      '14': {'weight': '21.14', 'section': '26.93'},
      '16': {'weight': '23.98', 'section': '30.55'},
    },
    '125': {
      '10': {'weight': '19.34', 'section': '24.63'},
      '12': {'weight': '23.08', 'section': '29.40'},
      '14': {'weight': '26.78', 'section': '34.11'},
      '16': {'weight': '30.44', 'section': '38.78'},
      '18': {'weight': '34.06', 'section': '43.39'},
    },
    '150': {
      '12': {'weight': '27.90', 'section': '35.55'},
      '14': {'weight': '32.40', 'section': '41.28'},
      '16': {'weight': '36.88', 'section': '46.99'},
      '18': {'weight': '41.32', 'section': '52.64'},
      '20': {'weight': '45.72', 'section': '58.25'},
    },
    '200': {
      '16': {'weight': '49.68', 'section': '63.29'},
      '18': {'weight': '55.76', 'section': '71.03'},
      '20': {'weight': '61.82', 'section': '78.75'},
      '22': {'weight': '67.84', 'section': '86.42'},
      '24': {'weight': '73.82', 'section': '94.03'},
    },
  };

  // Data for Angle Unequal
  final Map<String, Map<String, Map<String, String>>> _angleUnequalData = {
    '50x30': {
      '4': {'weight': '1.76', 'section': '2.24'},
      '5': {'weight': '2.18', 'section': '2.78'},
      '6': {'weight': '2.59', 'section': '3.30'},
    },
    '60x40': {
      '5': {'weight': '2.82', 'section': '3.59'},
      '6': {'weight': '3.36', 'section': '4.28'},
      '8': {'weight': '4.41', 'section': '5.62'},
    },
    '70x50': {
      '5': {'weight': '3.92', 'section': '4.99'},
      '6': {'weight': '4.67', 'section': '5.95'},
      '8': {'weight': '6.16', 'section': '7.85'},
    },
    '80x60': {
      '6': {'weight': '5.21', 'section': '6.64'},
      '8': {'weight': '6.88', 'section': '8.77'},
      '10': {'weight': '8.52', 'section': '10.86'},
    },
    '100x75': {
      '6': {'weight': '6.83', 'section': '8.70'},
      '8': {'weight': '9.03', 'section': '11.50'},
      '10': {'weight': '11.20', 'section': '14.27'},
      '12': {'weight': '13.34', 'section': '17.00'},
    },
    '125x75': {
      '8': {'weight': '10.31', 'section': '13.14'},
      '10': {'weight': '12.78', 'section': '16.28'},
      '12': {'weight': '15.22', 'section': '19.39'},
    },
    '150x100': {
      '10': {'weight': '17.16', 'section': '21.86'},
      '12': {'weight': '20.48', 'section': '26.09'},
      '14': {'weight': '23.77', 'section': '30.28'},
      '16': {'weight': '27.03', 'section': '34.44'},
    },
    '200x150': {
      '12': {'weight': '30.54', 'section': '38.91'},
      '14': {'weight': '35.48', 'section': '45.20'},
      '16': {'weight': '40.40', 'section': '51.47'},
      '18': {'weight': '45.28', 'section': '57.69'},
    },
  };

  // Data for Japanese U-Channel
  final Map<String, Map<String, String>> _japaneseUChannelData = {
    '50': {'weight': '4.73', 'section': '6.03'},
    '75': {'weight': '7.03', 'section': '8.96'},
    '100': {'weight': '9.67', 'section': '12.32'},
    '125': {'weight': '12.50', 'section': '15.93'},
    '150': {'weight': '15.60', 'section': '19.88'},
    '180': {'weight': '18.80', 'section': '23.95'},
    '200': {'weight': '21.60', 'section': '27.52'},
    '220': {'weight': '24.40', 'section': '31.09'},
    '250': {'weight': '28.80', 'section': '36.70'},
    '300': {'weight': '37.70', 'section': '48.04'},
  };

  // Data for Beams
  final Map<String, Map<String, String>> _beamsData = {
    '100': {'weight': '20.4', 'section': '26.0'},
    '120': {'weight': '26.7', 'section': '34.0'},
    '140': {'weight': '33.7', 'section': '42.9'},
    '160': {'weight': '42.6', 'section': '54.3'},
    '180': {'weight': '51.2', 'section': '65.3'},
    '200': {'weight': '61.3', 'section': '78.1'},
    '220': {'weight': '71.5', 'section': '91.0'},
    '240': {'weight': '83.2', 'section': '106.0'},
    '260': {'weight': '93.0', 'section': '118.4'},
    '280': {'weight': '103.0', 'section': '131.2'},
    '300': {'weight': '117.0', 'section': '149.1'},
    '320': {'weight': '127.0', 'section': '161.3'},
    '340': {'weight': '134.0', 'section': '170.9'},
    '360': {'weight': '142.0', 'section': '180.6'},
  };

  // Data for HEA/HEB
  final Map<String, Map<String, String>> _heaHebData = {
    'HEA 100': {'weight': '16.7', 'section': '21.2'},
    'HEA 120': {'weight': '19.9', 'section': '25.3'},
    'HEA 140': {'weight': '24.7', 'section': '31.4'},
    'HEA 160': {'weight': '30.4', 'section': '38.7'},
    'HEA 180': {'weight': '35.5', 'section': '45.2'},
    'HEA 200': {'weight': '42.3', 'section': '53.8'},
    'HEA 220': {'weight': '50.5', 'section': '64.3'},
    'HEA 240': {'weight': '60.3', 'section': '76.8'},
    'HEA 260': {'weight': '68.2', 'section': '86.8'},
    'HEA 280': {'weight': '76.4', 'section': '97.3'},
    'HEA 300': {'weight': '88.3', 'section': '112.5'},
    'HEB 100': {'weight': '20.4', 'section': '26.0'},
    'HEB 120': {'weight': '26.7', 'section': '34.0'},
    'HEB 140': {'weight': '33.7', 'section': '42.9'},
    'HEB 160': {'weight': '42.6', 'section': '54.3'},
    'HEB 180': {'weight': '51.2', 'section': '65.3'},
    'HEB 200': {'weight': '61.3', 'section': '78.1'},
    'HEB 220': {'weight': '71.5', 'section': '91.0'},
    'HEB 240': {'weight': '83.2', 'section': '106.0'},
    'HEB 260': {'weight': '93.0', 'section': '118.4'},
    'HEB 280': {'weight': '103.0', 'section': '131.2'},
    'HEB 300': {'weight': '117.0', 'section': '149.1'},
  };

  // Data for JIS
  final Map<String, Map<String, String>> _jisData = {
    '100': {'weight': '17.2', 'section': '21.9'},
    '125': {'weight': '21.9', 'section': '27.9'},
    '150': {'weight': '27.0', 'section': '34.4'},
    '175': {'weight': '32.7', 'section': '41.7'},
    '200': {'weight': '38.7', 'section': '49.3'},
    '250': {'weight': '50.2', 'section': '64.0'},
    '300': {'weight': '62.6', 'section': '79.8'},
    '350': {'weight': '75.0', 'section': '95.6'},
    '400': {'weight': '88.7', 'section': '113.0'},
    '450': {'weight': '103.0', 'section': '131.2'},
    '500': {'weight': '118.0', 'section': '150.4'},
  };

  // Data for UPE/UPN (Alnafie & DIN Standards)
  final Map<String, Map<String, String>> _upeUpnData = {
    'UPE 80': {'weight': '7.1', 'section': '8.98'},
    'UPE 100': {'weight': '9.82', 'section': '12.5'},
    'UPE 120': {'weight': '12.1', 'section': '15.4'},
    'UPE 140': {'weight': '14.5', 'section': '18.4'},
    'UPE 160': {'weight': '17.0', 'section': '21.7'},
    'UPE 180': {'weight': '19.7', 'section': '25.1'},
    'UPE 200': {'weight': '22.8', 'section': '29.0'},
    'UPE 220': {'weight': '26.6', 'section': '33.9'},
    'UPE 240': {'weight': '30.2', 'section': '38.5'},
    'UPE 270': {'weight': '35.2', 'section': '44.8'},
    'UPE 300': {'weight': '44.4', 'section': '56.6'},
    'UPE 330': {'weight': '53.4', 'section': '68.0'},
    'UPE 360': {'weight': '61.2', 'section': '77.9'},
    'UPE 400': {'weight': '72.2', 'section': '91.9'},
    'UPN 80': {'weight': '8.64', 'section': '11.0'},
    'UPN 100': {'weight': '10.6', 'section': '13.5'},
    'UPN 120': {'weight': '13.4', 'section': '17.0'},
    'UPN 140': {'weight': '16.0', 'section': '20.4'},
    'UPN 160': {'weight': '18.8', 'section': '24.0'},
    'UPN 180': {'weight': '22.0', 'section': '28.0'},
    'UPN 200': {'weight': '25.3', 'section': '32.2'},
    'UPN 220': {'weight': '29.4', 'section': '37.4'},
    'UPN 240': {'weight': '33.2', 'section': '42.3'},
    'UPN 270': {'weight': '39.6', 'section': '50.4'},
    'UPN 300': {'weight': '46.2', 'section': '58.8'},
    'UPN 330': {'weight': '54.5', 'section': '69.4'},
    'UPN 360': {'weight': '63.9', 'section': '81.4'},
    'UPN 400': {'weight': '71.8', 'section': '91.5'},
  };

  // Data for UB (Universal Beams) - keeping existing
  final Map<String, Map<String, String>> _ubData = {
    '100': {'weight': '20.4', 'section': '26.0'},
    '120': {'weight': '26.7', 'section': '34.0'},
    '140': {'weight': '33.7', 'section': '42.9'},
    '160': {'weight': '42.6', 'section': '54.3'},
    '180': {'weight': '51.2', 'section': '65.3'},
    '200': {'weight': '61.3', 'section': '78.1'},
    '220': {'weight': '71.5', 'section': '91.0'},
    '240': {'weight': '83.2', 'section': '106.0'},
    '260': {'weight': '93.0', 'section': '118.4'},
    '280': {'weight': '103.0', 'section': '131.2'},
    '300': {'weight': '117.0', 'section': '149.1'},
    '320': {'weight': '127.0', 'section': '161.3'},
    '340': {'weight': '134.0', 'section': '170.9'},
    '360': {'weight': '142.0', 'section': '180.6'},
  };

  // Data for UC (Universal Columns)
  final Map<String, Map<String, String>> _ucData = {
    '100': {'weight': '24.0', 'section': '30.6'},
    '120': {'weight': '32.0', 'section': '40.8'},
    '140': {'weight': '40.0', 'section': '51.0'},
    '160': {'weight': '50.0', 'section': '63.7'},
    '180': {'weight': '60.0', 'section': '76.5'},
    '200': {'weight': '72.0', 'section': '91.8'},
    '220': {'weight': '84.0', 'section': '107.1'},
    '240': {'weight': '96.0', 'section': '122.4'},
    '260': {'weight': '108.0', 'section': '137.7'},
    '280': {'weight': '120.0', 'section': '153.0'},
    '300': {'weight': '132.0', 'section': '168.3'},
  };

  // Data for W Beams
  final Map<String, Map<String, String>> _wBeamData = {
    '100': {'weight': '19.3', 'section': '24.6'},
    '120': {'weight': '25.0', 'section': '31.9'},
    '140': {'weight': '32.0', 'section': '40.8'},
    '160': {'weight': '40.0', 'section': '51.0'},
    '180': {'weight': '48.0', 'section': '61.2'},
    '200': {'weight': '58.0', 'section': '73.9'},
    '220': {'weight': '68.0', 'section': '86.7'},
    '240': {'weight': '78.0', 'section': '99.4'},
    '260': {'weight': '88.0', 'section': '112.2'},
    '280': {'weight': '98.0', 'section': '124.9'},
    '300': {'weight': '110.0', 'section': '140.2'},
  };

  // Data for SS ANGLE - keeping existing
  final Map<String, Map<String, Map<String, String>>> _ssAngleData = {
    '20': {
      '3': {'weight': '0.88', 'section': '1.12'},
      '4': {'weight': '1.15', 'section': '1.46'},
    },
    '25': {
      '3': {'weight': '1.12', 'section': '1.43'},
      '4': {'weight': '1.48', 'section': '1.89'},
      '5': {'weight': '1.82', 'section': '2.32'},
    },
    '30': {
      '3': {'weight': '1.36', 'section': '1.74'},
      '4': {'weight': '1.80', 'section': '2.29'},
      '5': {'weight': '2.22', 'section': '2.83'},
    },
    '35': {
      '4': {'weight': '2.12', 'section': '2.70'},
      '5': {'weight': '2.62', 'section': '3.34'},
      '6': {'weight': '3.10', 'section': '3.95'},
    },
    '40': {
      '4': {'weight': '2.44', 'section': '3.11'},
      '5': {'weight': '3.02', 'section': '3.85'},
      '6': {'weight': '3.58', 'section': '4.56'},
    },
    '45': {
      '5': {'weight': '3.42', 'section': '4.36'},
      '6': {'weight': '4.06', 'section': '5.17'},
      '8': {'weight': '5.32', 'section': '6.78'},
    },
    '50': {
      '5': {'weight': '3.82', 'section': '4.87'},
      '6': {'weight': '4.54', 'section': '5.79'},
      '8': {'weight': '5.96', 'section': '7.59'},
      '10': {'weight': '7.34', 'section': '9.35'},
    },
    '60': {
      '6': {'weight': '5.50', 'section': '7.01'},
      '8': {'weight': '7.22', 'section': '9.20'},
      '10': {'weight': '8.92', 'section': '11.37'},
    },
    '70': {
      '6': {'weight': '6.46', 'section': '8.23'},
      '8': {'weight': '8.50', 'section': '10.83'},
      '10': {'weight': '10.52', 'section': '13.40'},
    },
    '75': {
      '6': {'weight': '6.94', 'section': '8.84'},
      '8': {'weight': '9.14', 'section': '11.64'},
      '10': {'weight': '11.32', 'section': '14.42'},
      '12': {'weight': '13.46', 'section': '17.15'},
    },
    '80': {
      '6': {'weight': '7.42', 'section': '9.45'},
      '8': {'weight': '9.78', 'section': '12.46'},
      '10': {'weight': '12.12', 'section': '15.44'},
      '12': {'weight': '14.42', 'section': '18.37'},
    },
    '90': {
      '8': {'weight': '11.06', 'section': '14.09'},
      '10': {'weight': '13.72', 'section': '17.48'},
      '12': {'weight': '16.34', 'section': '20.82'},
    },
    '100': {
      '8': {'weight': '12.34', 'section': '15.72'},
      '10': {'weight': '15.32', 'section': '19.52'},
      '12': {'weight': '18.26', 'section': '23.27'},
      '14': {'weight': '21.14', 'section': '26.93'},
      '16': {'weight': '23.98', 'section': '30.55'},
    },
    '125': {
      '10': {'weight': '19.34', 'section': '24.63'},
      '12': {'weight': '23.08', 'section': '29.40'},
      '14': {'weight': '26.78', 'section': '34.11'},
      '16': {'weight': '30.44', 'section': '38.78'},
      '18': {'weight': '34.06', 'section': '43.39'},
    },
    '150': {
      '12': {'weight': '27.90', 'section': '35.55'},
      '14': {'weight': '32.40', 'section': '41.28'},
      '16': {'weight': '36.88', 'section': '46.99'},
      '18': {'weight': '41.32', 'section': '52.64'},
      '20': {'weight': '45.72', 'section': '58.25'},
    },
    '200': {
      '16': {'weight': '49.68', 'section': '63.29'},
      '18': {'weight': '55.76', 'section': '71.03'},
      '20': {'weight': '61.82', 'section': '78.75'},
      '22': {'weight': '67.84', 'section': '86.42'},
      '24': {'weight': '73.82', 'section': '94.03'},
    },
  };

  // Data for SS SHEET - keeping existing
  final Map<String, Map<String, String>> _ssSheetData = {
    '1.0': {'weight': '7.85', 'section': '1.00'},
    '1.2': {'weight': '9.42', 'section': '1.20'},
    '1.5': {'weight': '11.78', 'section': '1.50'},
    '2.0': {'weight': '15.70', 'section': '2.00'},
    '2.5': {'weight': '19.63', 'section': '2.50'},
    '3.0': {'weight': '23.55', 'section': '3.00'},
    '4.0': {'weight': '31.40', 'section': '4.00'},
    '5.0': {'weight': '39.25', 'section': '5.00'},
    '6.0': {'weight': '47.10', 'section': '6.00'},
    '8.0': {'weight': '62.80', 'section': '8.00'},
    '10.0': {'weight': '78.50', 'section': '10.00'},
  };

  // Data for SS ROUND BAR - keeping existing
  final Map<String, Map<String, String>> _ssRoundBarData = {
    '6': {'weight': '0.22', 'section': '0.28'},
    '8': {'weight': '0.39', 'section': '0.50'},
    '10': {'weight': '0.62', 'section': '0.79'},
    '12': {'weight': '0.89', 'section': '1.13'},
    '14': {'weight': '1.21', 'section': '1.54'},
    '16': {'weight': '1.58', 'section': '2.01'},
    '18': {'weight': '2.00', 'section': '2.54'},
    '20': {'weight': '2.47', 'section': '3.14'},
    '22': {'weight': '2.98', 'section': '3.80'},
    '25': {'weight': '3.85', 'section': '4.91'},
    '28': {'weight': '4.83', 'section': '6.16'},
    '30': {'weight': '5.55', 'section': '7.07'},
    '32': {'weight': '6.31', 'section': '8.04'},
    '36': {'weight': '7.99', 'section': '10.18'},
    '40': {'weight': '9.86', 'section': '12.57'},
  };

  // Data for ALUMINUM ANGLE - keeping existing
  final Map<String, Map<String, Map<String, String>>> _aluminumAngleData = {
    '20': {
      '3': {'weight': '0.30', 'section': '1.12'},
      '4': {'weight': '0.40', 'section': '1.46'},
    },
    '25': {
      '3': {'weight': '0.39', 'section': '1.43'},
      '4': {'weight': '0.51', 'section': '1.89'},
      '5': {'weight': '0.63', 'section': '2.32'},
    },
    '30': {
      '3': {'weight': '0.47', 'section': '1.74'},
      '4': {'weight': '0.62', 'section': '2.29'},
      '5': {'weight': '0.76', 'section': '2.83'},
    },
    '35': {
      '4': {'weight': '0.73', 'section': '2.70'},
      '5': {'weight': '0.90', 'section': '3.34'},
      '6': {'weight': '1.07', 'section': '3.95'},
    },
    '40': {
      '4': {'weight': '0.84', 'section': '3.11'},
      '5': {'weight': '1.04', 'section': '3.85'},
      '6': {'weight': '1.23', 'section': '4.56'},
    },
    '45': {
      '5': {'weight': '1.18', 'section': '4.36'},
      '6': {'weight': '1.40', 'section': '5.17'},
      '8': {'weight': '1.83', 'section': '6.78'},
    },
    '50': {
      '5': {'weight': '1.31', 'section': '4.87'},
      '6': {'weight': '1.56', 'section': '5.79'},
      '8': {'weight': '2.05', 'section': '7.59'},
      '10': {'weight': '2.52', 'section': '9.35'},
    },
    '60': {
      '6': {'weight': '1.89', 'section': '7.01'},
      '8': {'weight': '2.48', 'section': '9.20'},
      '10': {'weight': '3.07', 'section': '11.37'},
    },
    '70': {
      '6': {'weight': '2.22', 'section': '8.23'},
      '8': {'weight': '2.92', 'section': '10.83'},
      '10': {'weight': '3.62', 'section': '13.40'},
    },
    '80': {
      '8': {'weight': '3.36', 'section': '12.46'},
      '10': {'weight': '4.17', 'section': '15.44'},
      '12': {'weight': '4.96', 'section': '18.37'},
    },
    '100': {
      '8': {'weight': '4.24', 'section': '15.72'},
      '10': {'weight': '5.27', 'section': '19.52'},
      '12': {'weight': '6.28', 'section': '23.27'},
    },
  };

  // Data for ALUMINUM ROUND BAR - keeping existing
  final Map<String, Map<String, String>> _aluminumRoundBarData = {
    '6': {'weight': '0.076', 'section': '0.28'},
    '8': {'weight': '0.136', 'section': '0.50'},
    '10': {'weight': '0.212', 'section': '0.79'},
    '12': {'weight': '0.305', 'section': '1.13'},
    '14': {'weight': '0.416', 'section': '1.54'},
    '16': {'weight': '0.543', 'section': '2.01'},
    '18': {'weight': '0.687', 'section': '2.54'},
    '20': {'weight': '0.848', 'section': '3.14'},
    '22': {'weight': '1.025', 'section': '3.80'},
    '25': {'weight': '1.325', 'section': '4.91'},
    '28': {'weight': '1.660', 'section': '6.16'},
    '30': {'weight': '1.910', 'section': '7.07'},
    '32': {'weight': '2.170', 'section': '8.04'},
    '36': {'weight': '2.750', 'section': '10.18'},
    '40': {'weight': '3.390', 'section': '12.57'},
  };

  // Data for ALUMINUM SHEET - keeping existing
  final Map<String, Map<String, String>> _aluminumSheetData = {
    '1.0': {'weight': '2.70', 'section': '1.00'},
    '1.2': {'weight': '3.24', 'section': '1.20'},
    '1.5': {'weight': '4.05', 'section': '1.50'},
    '2.0': {'weight': '5.40', 'section': '2.00'},
    '2.5': {'weight': '6.75', 'section': '2.50'},
    '3.0': {'weight': '8.10', 'section': '3.00'},
    '4.0': {'weight': '10.80', 'section': '4.00'},
    '5.0': {'weight': '13.50', 'section': '5.00'},
    '6.0': {'weight': '16.20', 'section': '6.00'},
    '8.0': {'weight': '21.60', 'section': '8.00'},
    '10.0': {'weight': '27.00', 'section': '10.00'},
  };

  // Data for ALUMINUM CHECKERED SHEET - keeping existing
  final Map<String, Map<String, String>> _aluminumCheckeredData = {
    '1.0': {'weight': '2.97', 'section': '1.00'},
    '1.2': {'weight': '3.56', 'section': '1.20'},
    '1.5': {'weight': '4.46', 'section': '1.50'},
    '2.0': {'weight': '5.94', 'section': '2.00'},
    '2.5': {'weight': '7.43', 'section': '2.50'},
    '3.0': {'weight': '8.91', 'section': '3.00'},
    '4.0': {'weight': '11.88', 'section': '4.00'},
    '5.0': {'weight': '14.85', 'section': '5.00'},
    '6.0': {'weight': '17.82', 'section': '6.00'},
  };

  // Data for BRASS SHEET - keeping existing
  final Map<String, Map<String, String>> _brassSheetData = {
    '1.0': {'weight': '8.50', 'section': '1.00'},
    '1.2': {'weight': '10.20', 'section': '1.20'},
    '1.5': {'weight': '12.75', 'section': '1.50'},
    '2.0': {'weight': '17.00', 'section': '2.00'},
    '2.5': {'weight': '21.25', 'section': '2.50'},
    '3.0': {'weight': '25.50', 'section': '3.00'},
    '4.0': {'weight': '34.00', 'section': '4.00'},
    '5.0': {'weight': '42.50', 'section': '5.00'},
    '6.0': {'weight': '51.00', 'section': '6.00'},
  };

  // Data for BRASS ROUND BAR - keeping existing
  final Map<String, Map<String, String>> _brassRoundBarData = {
    '6': {'weight': '0.24', 'section': '0.28'},
    '8': {'weight': '0.43', 'section': '0.50'},
    '10': {'weight': '0.67', 'section': '0.79'},
    '12': {'weight': '0.96', 'section': '1.13'},
    '14': {'weight': '1.31', 'section': '1.54'},
    '16': {'weight': '1.71', 'section': '2.01'},
    '18': {'weight': '2.16', 'section': '2.54'},
    '20': {'weight': '2.67', 'section': '3.14'},
    '22': {'weight': '3.23', 'section': '3.80'},
    '25': {'weight': '4.17', 'section': '4.91'},
    '28': {'weight': '5.23', 'section': '6.16'},
    '30': {'weight': '6.01', 'section': '7.07'},
    '32': {'weight': '6.84', 'section': '8.04'},
    '36': {'weight': '8.66', 'section': '10.18'},
    '40': {'weight': '10.68', 'section': '12.57'},
  };

  // Data for COPPER SHEET - keeping existing
  final Map<String, Map<String, String>> _copperSheetData = {
    '1.0': {'weight': '8.90', 'section': '1.00'},
    '1.2': {'weight': '10.68', 'section': '1.20'},
    '1.5': {'weight': '13.35', 'section': '1.50'},
    '2.0': {'weight': '17.80', 'section': '2.00'},
    '2.5': {'weight': '22.25', 'section': '2.50'},
    '3.0': {'weight': '26.70', 'section': '3.00'},
    '4.0': {'weight': '35.60', 'section': '4.00'},
    '5.0': {'weight': '44.50', 'section': '5.00'},
    '6.0': {'weight': '53.40', 'section': '6.00'},
  };

  // Data for COPPER ROUND BAR - keeping existing
  final Map<String, Map<String, String>> _copperRoundBarData = {
    '6': {'weight': '0.25', 'section': '0.28'},
    '8': {'weight': '0.45', 'section': '0.50'},
    '10': {'weight': '0.70', 'section': '0.79'},
    '12': {'weight': '1.01', 'section': '1.13'},
    '14': {'weight': '1.37', 'section': '1.54'},
    '16': {'weight': '1.79', 'section': '2.01'},
    '18': {'weight': '2.26', 'section': '2.54'},
    '20': {'weight': '2.79', 'section': '3.14'},
    '22': {'weight': '3.38', 'section': '3.80'},
    '25': {'weight': '4.36', 'section': '4.91'},
    '28': {'weight': '5.47', 'section': '6.16'},
    '30': {'weight': '6.28', 'section': '7.07'},
    '32': {'weight': '7.15', 'section': '8.04'},
    '36': {'weight': '9.06', 'section': '10.18'},
    '40': {'weight': '11.17', 'section': '12.57'},
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedSize = _getAvailableSizes().first;
    _updateResults();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _weightController.dispose();
    _sectionController.dispose();
    super.dispose();
  }

  List<String> _getAvailableSizes() {
    switch (_selectedShape) {
      case 'Bars':
        return _barsData.keys.toList();
      case 'Sheets':
        return _sheetsData.keys.toList();
      case 'Flats':
        return _flatsData.keys.toList();
      case 'Angle Equal':
        return _angleEqualData.keys.toList();
      case 'Angle Unequal':
        return _angleUnequalData.keys.toList();
      case 'Japanese U-Channel':
        return _japaneseUChannelData.keys.toList();
      case 'Beams':
        return _beamsData.keys.toList();
      case 'HEA/HEB':
        return _heaHebData.keys.toList();
      case 'JIS':
        return _jisData.keys.toList();
      case 'UPE/UPN':
        return _upeUpnData.keys.toList();
      case 'UB':
        return _ubData.keys.toList();
      case 'UC':
        return _ucData.keys.toList();
      case 'W Beam':
        return _wBeamData.keys.toList();
      case 'SS ANGLE':
        return _ssAngleData.keys.toList();
      case 'SS SHEET':
        return _ssSheetData.keys.toList();
      case 'SS ROUND BAR':
        return _ssRoundBarData.keys.toList();
      case 'ALUMINUM ANGLE':
        return _aluminumAngleData.keys.toList();
      case 'ALUMINUM ROUND BAR':
        return _aluminumRoundBarData.keys.toList();
      case 'ALUMINUM SHEET':
        return _aluminumSheetData.keys.toList();
      case 'ALUMINUM CHECKERED SHEET':
        return _aluminumCheckeredData.keys.toList();
      case 'BRASS SHEET':
        return _brassSheetData.keys.toList();
      case 'BRASS ROUND BAR':
        return _brassRoundBarData.keys.toList();
      case 'COPPER SHEET':
        return _copperSheetData.keys.toList();
      case 'COPPER ROUND BAR':
        return _copperRoundBarData.keys.toList();
      default:
        return ['100'];
    }
  }


  void _updateResults() {
    Map<String, String>? match;
    double density = 7.85; // g/cm³

    if (_selectedShape.contains('SS')) {
      density = 8.00;
    } else if (_selectedShape.contains('ALUMINUM')) {
      density = 2.70;
    } else if (_selectedShape.contains('BRASS')) {
      density = 8.73;
    } else if (_selectedShape.contains('COPPER')) {
      density = 8.96;
    }

    if (_selectedShape == 'Bars' && _barsData.containsKey(_selectedSize)) {
      match = _barsData[_selectedSize];
    } else if (_selectedShape == 'Sheets' &&
        _sheetsData.containsKey(_selectedSize)) {
      match = _sheetsData[_selectedSize];
    } else if (_selectedShape == 'Flats' &&
        _flatsData.containsKey(_selectedSize) &&
        _flatsData[_selectedSize]!.containsKey(_selectedThickness)) {
      match = _flatsData[_selectedSize]![_selectedThickness];
    } else if (_selectedShape == 'Angle Equal' &&
        _angleEqualData.containsKey(_selectedSize) &&
        _angleEqualData[_selectedSize]!.containsKey(_selectedThickness)) {
      match = _angleEqualData[_selectedSize]![_selectedThickness];
    } else if (_selectedShape == 'Angle Unequal' &&
        _angleUnequalData.containsKey(_selectedSize) &&
        _angleUnequalData[_selectedSize]!.containsKey(_selectedThickness)) {
      match = _angleUnequalData[_selectedSize]![_selectedThickness];
    } else if (_selectedShape == 'Japanese U-Channel' &&
        _japaneseUChannelData.containsKey(_selectedSize)) {
      match = _japaneseUChannelData[_selectedSize];
    } else if (_selectedShape == 'Beams' &&
        _beamsData.containsKey(_selectedSize)) {
      match = _beamsData[_selectedSize];
    } else if (_selectedShape == 'HEA/HEB' &&
        _heaHebData.containsKey(_selectedSize)) {
      match = _heaHebData[_selectedSize];
    } else if (_selectedShape == 'JIS' && _jisData.containsKey(_selectedSize)) {
      match = _jisData[_selectedSize];
    } else if (_selectedShape == 'UPE/UPN' &&
        _upeUpnData.containsKey(_selectedSize)) {
      match = _upeUpnData[_selectedSize];
    } else if (_selectedShape == 'UB' && _ubData.containsKey(_selectedSize)) {
      match = _ubData[_selectedSize];
    } else if (_selectedShape == 'UC' && _ucData.containsKey(_selectedSize)) {
      match = _ucData[_selectedSize];
    } else if (_selectedShape == 'W Beam' &&
        _wBeamData.containsKey(_selectedSize)) {
      match = _wBeamData[_selectedSize];
    } else if (_selectedShape == 'SS ANGLE' &&
        _ssAngleData.containsKey(_selectedSize) &&
        _ssAngleData[_selectedSize]!.containsKey(_selectedThickness)) {
      match = _ssAngleData[_selectedSize]![_selectedThickness];
    } else if (_selectedShape == 'SS SHEET' &&
        _ssSheetData.containsKey(_selectedSize)) {
      match = _ssSheetData[_selectedSize];
    } else if (_selectedShape == 'SS ROUND BAR' &&
        _ssRoundBarData.containsKey(_selectedSize)) {
      match = _ssRoundBarData[_selectedSize];
    } else if (_selectedShape == 'ALUMINUM ANGLE' &&
        _aluminumAngleData.containsKey(_selectedSize) &&
        _aluminumAngleData[_selectedSize]!.containsKey(_selectedThickness)) {
      match = _aluminumAngleData[_selectedSize]![_selectedThickness];
    } else if (_selectedShape == 'ALUMINUM ROUND BAR' &&
        _aluminumRoundBarData.containsKey(_selectedSize)) {
      match = _aluminumRoundBarData[_selectedSize];
    } else if (_selectedShape == 'ALUMINUM SHEET' &&
        _aluminumSheetData.containsKey(_selectedSize)) {
      match = _aluminumSheetData[_selectedSize];
    } else if (_selectedShape == 'ALUMINUM CHECKERED SHEET' &&
        _aluminumCheckeredData.containsKey(_selectedSize)) {
      match = _aluminumCheckeredData[_selectedSize];
    } else if (_selectedShape == 'BRASS SHEET' &&
        _brassSheetData.containsKey(_selectedSize)) {
      match = _brassSheetData[_selectedSize];
    } else if (_selectedShape == 'BRASS ROUND BAR' &&
        _brassRoundBarData.containsKey(_selectedSize)) {
      match = _brassRoundBarData[_selectedSize];
    } else if (_selectedShape == 'COPPER SHEET' &&
        _copperSheetData.containsKey(_selectedSize)) {
      match = _copperSheetData[_selectedSize];
    } else if (_selectedShape == 'COPPER ROUND BAR' &&
        _copperRoundBarData.containsKey(_selectedSize)) {
      match = _copperRoundBarData[_selectedSize];
    }

    if (match != null) {
      _sectionController.text = match['section']!;
      _weightController.text = match['weight']!;
      return;
    }

    // Dynamic engineering physics calculation fallback
    double sectionAreaCm2 = 0.0;
    double weightKgPerM = 0.0;

    final double sVal = double.tryParse(_selectedSize) ?? 0.0;
    final double tVal = double.tryParse(_selectedThickness) ?? 0.0;

    if (_selectedShape.contains('ROUND BAR') || _selectedShape == 'Bars') {
      sectionAreaCm2 = (3.1415926535 * sVal * sVal) / 400.0;
      weightKgPerM = (sectionAreaCm2 * 100.0 * density) / 1000.0;
    } else if (_selectedShape.contains('SHEET') ||
        _selectedShape.contains('CHECKERED') ||
        _selectedShape == 'Sheets') {
      sectionAreaCm2 = sVal;
      weightKgPerM = sVal * density;
    } else if (_selectedShape == 'Flats') {
      sectionAreaCm2 = (sVal * tVal) / 100.0;
      weightKgPerM = (sectionAreaCm2 * 100.0 * density) / 1000.0;
    } else if (_selectedShape.contains('ANGLE') ||
        _selectedShape.contains('Angle')) {
      if (_selectedSize.contains('x')) {
        final parts = _selectedSize.split('x');
        final double a = double.tryParse(parts[0]) ?? 50.0;
        final double b = double.tryParse(parts[1]) ?? 30.0;
        sectionAreaCm2 = (tVal * (a + b - tVal)) / 100.0;
      } else {
        sectionAreaCm2 = (tVal * (2 * sVal - tVal)) / 100.0;
      }
      weightKgPerM = (sectionAreaCm2 * 100.0 * density) / 1000.0;
    }

    _sectionController.text =
        sectionAreaCm2 > 0 ? sectionAreaCm2.toStringAsFixed(2) : '0.00';
    _weightController.text =
        weightKgPerM > 0 ? weightKgPerM.toStringAsFixed(2) : '0.00';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final now = DateTime.now();
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2C3E50),
          elevation: 2,
          title: const Center(
            child: Text(
              'MILEN STEEL',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shape Dropdown
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedShape,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down,
                        color: Color(0xFFE67E22)),
                    style: const TextStyle(
                      color: Color(0xFF2C3E50),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    items: _shapes.map((String shape) {
                      return DropdownMenuItem<String>(
                        value: shape,
                        child: Row(
                          children: [
                            _getShapeIcon(shape),
                            const SizedBox(width: 12),
                            Text(shape),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedShape = newValue!;
                        _selectedSize = _getAvailableSizes().first;
                        _updateResults();
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Shape-specific input section
              _buildShapeInputs(),
              const SizedBox(height: 16),

              // Shape visualization
              _buildShapeVisualization(),
              const SizedBox(height: 16),

              // Info Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2C3E50).withValues(alpha: 0.05),
                      const Color(0xFFE67E22).withValues(alpha: 0.05)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFF2C3E50).withValues(alpha: 0.1)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE67E22).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.info_outline,
                          color: Color(0xFFE67E22), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Steel Section Properties',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                          Text(
                            'Shape: $_selectedShape',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            'Weight: ${_weightController.text} Kg/m',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFE67E22),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getShapeIcon(String shape) {
    IconData iconData;
    if (shape.contains('ANGLE') || shape.contains('Angle')) {
      iconData = Icons.timeline;
    } else if (shape.contains('BEAM') ||
        shape.contains('UB') ||
        shape.contains('UC') ||
        shape.contains('W Beam') ||
        shape.contains('Beams') ||
        shape.contains('HEA') ||
        shape.contains('HEB') ||
        shape.contains('JIS')) {
      iconData = Icons.view_column;
    } else if (shape.contains('SHEET') ||
        shape.contains('CHECKERED') ||
        shape.contains('Sheets')) {
      iconData = Icons.crop_square;
    } else if (shape.contains('ROUND BAR') || shape.contains('Bars')) {
      iconData = Icons.horizontal_rule;
    } else if (shape.contains('U-Channel') ||
        shape.contains('UPE') ||
        shape.contains('UPN')) {
      iconData = Icons.view_stream;
    } else if (shape.contains('Flats')) {
      iconData = Icons.crop_original;
    } else {
      iconData = Icons.category;
    }
    return Icon(iconData, color: const Color(0xFFE67E22), size: 20);
  }

  Widget _buildShapeInputs() {
    return const SizedBox.shrink();
  }


  Widget _buildShapeVisualization() {
    double? wVal = double.tryParse(_weightController.text);
    double? sVal = double.tryParse(_sectionController.text);

    return Section2DDiagramWidget(
      shapeType: _selectedShape,
      selectedSize: _selectedSize,
      selectedThickness: _selectedThickness,
      lengthMeters: _pieceLength,
      availableSizes: _getAvailableSizes(),
      overrideWeight: wVal,
      overrideSectionArea: sVal,
      onSliderChanged: _onLengthChanged,
      onSizeChanged: (newSize) {
        final avail = _getAvailableSizes();
        if (avail.isEmpty) return;
        String validSize = newSize;
        if (!avail.contains(validSize)) {
          String cleanNum = validSize.replaceAll(RegExp(r'[^0-9.]'), '');
          validSize = avail.firstWhere(
            (s) => s.replaceAll(RegExp(r'[^0-9.]'), '') == cleanNum,
            orElse: () => avail.first,
          );
        }
        if (_selectedSize != validSize) {
          setState(() {
            _selectedSize = validSize;
            _updateResults();
          });
        }
      },
      onVariantChanged: (variant) {
        if (variant == 'UPE' || variant == 'UPN') {
          final avail = _getAvailableSizes();
          String firstForVariant = avail.firstWhere(
            (s) => s.startsWith(variant),
            orElse: () => avail.isNotEmpty ? avail.first : 'UPE 80',
          );
          if (_selectedShape != 'UPE/UPN' || _selectedSize != firstForVariant) {
            setState(() {
              _selectedShape = 'UPE/UPN';
              _selectedSize = firstForVariant;
              _updateResults();
            });
          }
        }
      },
    );
  }

}

// 3D Animated Angle Painter
class AnglePainter extends CustomPainter {
  final String sizeValue;
  final String thicknessValue;
  final double lengthMeters;
  final bool isAluminum;

  AnglePainter({
    required this.sizeValue,
    required this.thicknessValue,
    required this.lengthMeters,
    required this.isAluminum,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    double legLength = 45;
    double legThickness = 7;
    double depth = (lengthMeters / 12.0).clamp(0.25, 1.0) * 35;

    double startX = width * 0.25;
    double startY = height * 0.25;

    Path frontPath = Path();
    frontPath.moveTo(startX, startY);
    frontPath.lineTo(startX + legLength, startY);
    frontPath.lineTo(startX + legLength, startY + legThickness);
    frontPath.lineTo(startX + legThickness, startY + legThickness);
    frontPath.lineTo(startX + legThickness, startY + legLength);
    frontPath.lineTo(startX, startY + legLength);
    frontPath.close();

    Path sideExtrusion = Path();
    sideExtrusion.moveTo(startX + legLength, startY);
    sideExtrusion.lineTo(startX + legLength + depth, startY - depth * 0.6);
    sideExtrusion.lineTo(
        startX + legLength + depth, startY + legThickness - depth * 0.6);
    sideExtrusion.lineTo(startX + legLength, startY + legThickness);
    sideExtrusion.close();

    Path topFace = Path();
    topFace.moveTo(startX, startY);
    topFace.lineTo(startX + depth, startY - depth * 0.6);
    topFace.lineTo(startX + legLength + depth, startY - depth * 0.6);
    topFace.lineTo(startX + legLength, startY);
    topFace.close();

    Paint fillPaint = Paint()
      ..color = isAluminum ? const Color(0xFFE67E22) : const Color(0xFF2C3E50)
      ..style = PaintingStyle.fill;

    Paint sidePaint = Paint()
      ..color = (isAluminum ? const Color(0xFFE67E22) : const Color(0xFF2C3E50))
          .withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    Paint strokePaint = Paint()
      ..color = const Color(0xFFE67E22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(topFace, sidePaint);
    canvas.drawPath(sideExtrusion, sidePaint);
    canvas.drawPath(frontPath, fillPaint);
    canvas.drawPath(frontPath, strokePaint);
    canvas.drawPath(topFace, strokePaint);

    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.text = TextSpan(
      text: '$sizeValue | L=${lengthMeters.toStringAsFixed(1)}m',
      style: const TextStyle(
        fontSize: 10,
        color: Color(0xFFE67E22),
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(width / 2 - textPainter.width / 2, height - 16),
    );
  }

  @override
  bool shouldRepaint(covariant AnglePainter oldDelegate) {
    return oldDelegate.sizeValue != sizeValue ||
        oldDelegate.thicknessValue != thicknessValue ||
        oldDelegate.lengthMeters != lengthMeters ||
        oldDelegate.isAluminum != isAluminum;
  }
}

// 3D Animated Bar Painter
class BarPainter extends CustomPainter {
  final String sizeValue;
  final double lengthMeters;

  BarPainter({required this.sizeValue, required this.lengthMeters});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    double sVal = double.tryParse(sizeValue) ?? 20.0;
    double radius = (sVal / 100.0).clamp(0.4, 1.0) * 20 + 10;
    double depth = (lengthMeters / 12.0).clamp(0.2, 1.0) * 45;

    Offset frontCenter = Offset(width * 0.35, height * 0.45);
    Offset backCenter =
        Offset(frontCenter.dx + depth, frontCenter.dy - depth * 0.5);

    Path cylinderBody = Path();
    cylinderBody.moveTo(frontCenter.dx, frontCenter.dy - radius);
    cylinderBody.lineTo(backCenter.dx, backCenter.dy - radius);
    cylinderBody.arcToPoint(
      Offset(backCenter.dx, backCenter.dy + radius),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    cylinderBody.lineTo(frontCenter.dx, frontCenter.dy + radius);
    cylinderBody.arcToPoint(
      Offset(frontCenter.dx, frontCenter.dy - radius),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    cylinderBody.close();

    Paint bodyPaint = Paint()
      ..color = const Color(0xFF2C3E50).withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    Paint frontPaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..style = PaintingStyle.fill;

    Paint strokePaint = Paint()
      ..color = const Color(0xFFE67E22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    canvas.drawPath(cylinderBody, bodyPaint);
    canvas.drawCircle(frontCenter, radius, frontPaint);
    canvas.drawCircle(frontCenter, radius, strokePaint);

    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.text = TextSpan(
      text: 'ø$sizeValue mm | L=${lengthMeters.toStringAsFixed(1)}m',
      style: const TextStyle(
        fontSize: 10,
        color: Color(0xFFE67E22),
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(width / 2 - textPainter.width / 2, height - 16),
    );
  }

  @override
  bool shouldRepaint(covariant BarPainter oldDelegate) {
    return oldDelegate.sizeValue != sizeValue ||
        oldDelegate.lengthMeters != lengthMeters;
  }
}

// 3D Animated Sheet Painter
class SheetPainter extends CustomPainter {
  final String thicknessValue;
  final double lengthMeters;

  SheetPainter({required this.thicknessValue, required this.lengthMeters});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    double tVal = double.tryParse(thicknessValue) ?? 3.0;
    double sheetThick = (tVal / 20.0).clamp(0.2, 1.0) * 10 + 4;
    double depth = (lengthMeters / 12.0).clamp(0.25, 1.0) * 40;

    Path topFace = Path();
    topFace.moveTo(width * 0.2, height * 0.45);
    topFace.lineTo(width * 0.65, height * 0.45);
    topFace.lineTo(width * 0.65 + depth, height * 0.45 - depth * 0.5);
    topFace.lineTo(width * 0.2 + depth, height * 0.45 - depth * 0.5);
    topFace.close();

    Path frontEdge = Path();
    frontEdge.moveTo(width * 0.2, height * 0.45);
    frontEdge.lineTo(width * 0.65, height * 0.45);
    frontEdge.lineTo(width * 0.65, height * 0.45 + sheetThick);
    frontEdge.lineTo(width * 0.2, height * 0.45 + sheetThick);
    frontEdge.close();

    Paint fillPaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..style = PaintingStyle.fill;

    Paint topPaint = Paint()
      ..color = const Color(0xFF34495E)
      ..style = PaintingStyle.fill;

    Paint strokePaint = Paint()
      ..color = const Color(0xFFE67E22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(topFace, topPaint);
    canvas.drawPath(frontEdge, fillPaint);
    canvas.drawPath(topFace, strokePaint);
    canvas.drawPath(frontEdge, strokePaint);

    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.text = TextSpan(
      text: 't=$thicknessValue mm | L=${lengthMeters.toStringAsFixed(1)}m',
      style: const TextStyle(
        fontSize: 10,
        color: Color(0xFFE67E22),
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(width / 2 - textPainter.width / 2, height - 16),
    );
  }

  @override
  bool shouldRepaint(covariant SheetPainter oldDelegate) {
    return oldDelegate.thicknessValue != thicknessValue ||
        oldDelegate.lengthMeters != lengthMeters;
  }
}

// 3D Animated Flat Painter
class FlatPainter extends CustomPainter {
  final String sizeValue;
  final String thicknessValue;
  final double lengthMeters;

  FlatPainter({
    required this.sizeValue,
    required this.thicknessValue,
    required this.lengthMeters,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    double depth = (lengthMeters / 12.0).clamp(0.25, 1.0) * 40;
    double wVal = double.tryParse(sizeValue) ?? 40.0;
    double flatWidth = (wVal / 100.0).clamp(0.3, 1.0) * 40 + 15;

    Rect frontRect = Rect.fromLTWH(
      (width - flatWidth) / 2 - 10,
      height * 0.35,
      flatWidth,
      18,
    );

    Path topFace = Path();
    topFace.moveTo(frontRect.left, frontRect.top);
    topFace.lineTo(frontRect.right, frontRect.top);
    topFace.lineTo(frontRect.right + depth, frontRect.top - depth * 0.5);
    topFace.lineTo(frontRect.left + depth, frontRect.top - depth * 0.5);
    topFace.close();

    Path sideFace = Path();
    sideFace.moveTo(frontRect.right, frontRect.top);
    sideFace.lineTo(frontRect.right + depth, frontRect.top - depth * 0.5);
    sideFace.lineTo(frontRect.right + depth, frontRect.bottom - depth * 0.5);
    sideFace.lineTo(frontRect.right, frontRect.bottom);
    sideFace.close();

    Paint fillPaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..style = PaintingStyle.fill;

    Paint sidePaint = Paint()
      ..color = const Color(0xFF34495E)
      ..style = PaintingStyle.fill;

    Paint strokePaint = Paint()
      ..color = const Color(0xFFE67E22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(topFace, sidePaint);
    canvas.drawPath(sideFace, sidePaint);
    canvas.drawRect(frontRect, fillPaint);
    canvas.drawRect(frontRect, strokePaint);
    canvas.drawPath(topFace, strokePaint);

    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.text = TextSpan(
      text:
          '${sizeValue}x$thicknessValue mm | L=${lengthMeters.toStringAsFixed(1)}m',
      style: const TextStyle(
        fontSize: 10,
        color: Color(0xFFE67E22),
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(width / 2 - textPainter.width / 2, height - 16),
    );
  }

  @override
  bool shouldRepaint(covariant FlatPainter oldDelegate) {
    return oldDelegate.sizeValue != sizeValue ||
        oldDelegate.thicknessValue != thicknessValue ||
        oldDelegate.lengthMeters != lengthMeters;
  }
}

// 3D Animated U-Channel Painter
class UChannelPainter extends CustomPainter {
  final String channelType;
  final String sizeValue;
  final double lengthMeters;

  UChannelPainter({
    required this.channelType,
    required this.sizeValue,
    required this.lengthMeters,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    double depth = (lengthMeters / 12.0).clamp(0.25, 1.0) * 35;
    double centerX = width * 0.35;
    double channelWidth = 40;
    double flangeThick = 8;
    double webThick = 6;

    Path frontPath = Path();
    frontPath.moveTo(centerX - channelWidth / 2, height * 0.2);
    frontPath.lineTo(centerX + channelWidth / 2, height * 0.2);
    frontPath.lineTo(centerX + channelWidth / 2, height * 0.2 + flangeThick);
    frontPath.lineTo(centerX + webThick / 2, height * 0.2 + flangeThick);
    frontPath.lineTo(centerX + webThick / 2, height * 0.7 - flangeThick);
    frontPath.lineTo(centerX + channelWidth / 2, height * 0.7 - flangeThick);
    frontPath.lineTo(centerX + channelWidth / 2, height * 0.7);
    frontPath.lineTo(centerX - channelWidth / 2, height * 0.7);
    frontPath.close();

    Path top3d = Path();
    top3d.moveTo(centerX - channelWidth / 2, height * 0.2);
    top3d.lineTo(centerX + channelWidth / 2, height * 0.2);
    top3d.lineTo(
        centerX + channelWidth / 2 + depth, height * 0.2 - depth * 0.5);
    top3d.lineTo(
        centerX - channelWidth / 2 + depth, height * 0.2 - depth * 0.5);
    top3d.close();

    Paint fillPaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..style = PaintingStyle.fill;

    Paint sidePaint = Paint()
      ..color = const Color(0xFF34495E)
      ..style = PaintingStyle.fill;

    Paint strokePaint = Paint()
      ..color = const Color(0xFFE67E22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(top3d, sidePaint);
    canvas.drawPath(frontPath, fillPaint);
    canvas.drawPath(frontPath, strokePaint);
    canvas.drawPath(top3d, strokePaint);

    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.text = TextSpan(
      text: '$sizeValue | L=${lengthMeters.toStringAsFixed(1)}m',
      style: const TextStyle(
        fontSize: 10,
        color: Color(0xFFE67E22),
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(width / 2 - textPainter.width / 2, height - 16),
    );
  }

  @override
  bool shouldRepaint(covariant UChannelPainter oldDelegate) {
    return oldDelegate.channelType != channelType ||
        oldDelegate.sizeValue != sizeValue ||
        oldDelegate.lengthMeters != lengthMeters;
  }
}

// 3D Animated Beam Painter
class BeamPainter extends CustomPainter {
  final String beamType;
  final String sizeValue;
  final double lengthMeters;

  BeamPainter({
    required this.beamType,
    required this.sizeValue,
    required this.lengthMeters,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    double depth = (lengthMeters / 12.0).clamp(0.25, 1.0) * 35;
    double centerX = width * 0.35;
    double beamWidth = 44;
    double flangeThick = 9;
    double webThick = 6;

    Path frontPath = Path();
    frontPath.moveTo(centerX - beamWidth / 2, height * 0.15);
    frontPath.lineTo(centerX + beamWidth / 2, height * 0.15);
    frontPath.lineTo(centerX + beamWidth / 2, height * 0.15 + flangeThick);
    frontPath.lineTo(centerX + webThick / 2, height * 0.15 + flangeThick);
    frontPath.lineTo(centerX + webThick / 2, height * 0.75 - flangeThick);
    frontPath.lineTo(centerX + beamWidth / 2, height * 0.75 - flangeThick);
    frontPath.lineTo(centerX + beamWidth / 2, height * 0.75);
    frontPath.lineTo(centerX - beamWidth / 2, height * 0.75);
    frontPath.lineTo(centerX - beamWidth / 2, height * 0.75 - flangeThick);
    frontPath.lineTo(centerX - webThick / 2, height * 0.75 - flangeThick);
    frontPath.lineTo(centerX - webThick / 2, height * 0.15 + flangeThick);
    frontPath.lineTo(centerX - beamWidth / 2, height * 0.15 + flangeThick);
    frontPath.close();

    Path top3d = Path();
    top3d.moveTo(centerX - beamWidth / 2, height * 0.15);
    top3d.lineTo(centerX + beamWidth / 2, height * 0.15);
    top3d.lineTo(centerX + beamWidth / 2 + depth, height * 0.15 - depth * 0.5);
    top3d.lineTo(centerX - beamWidth / 2 + depth, height * 0.15 - depth * 0.5);
    top3d.close();

    Paint fillPaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..style = PaintingStyle.fill;

    Paint sidePaint = Paint()
      ..color = const Color(0xFF34495E)
      ..style = PaintingStyle.fill;

    Paint strokePaint = Paint()
      ..color = const Color(0xFFE67E22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(top3d, sidePaint);
    canvas.drawPath(frontPath, fillPaint);
    canvas.drawPath(frontPath, strokePaint);
    canvas.drawPath(top3d, strokePaint);

    TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    String displayText = beamType.contains('HEA') || beamType.contains('HEB')
        ? beamType
        : '$beamType $sizeValue';

    textPainter.text = TextSpan(
      text: '$displayText | L=${lengthMeters.toStringAsFixed(1)}m',
      style: const TextStyle(
        fontSize: 10,
        color: Color(0xFFE67E22),
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(width / 2 - textPainter.width / 2, height - 16),
    );
  }

  @override
  bool shouldRepaint(covariant BeamPainter oldDelegate) {
    return oldDelegate.beamType != beamType ||
        oldDelegate.sizeValue != sizeValue ||
        oldDelegate.lengthMeters != lengthMeters;
  }
}
