import 'package:flutter/material.dart';
import 'dart:math';

// No provision for user to choose colors
List<Color> tileColors = [Colors.amber, Colors.blue, Colors.black];
Color evenColor = Colors.amber;
Color oddColor = Colors.blue;
Color blankColor = Colors.black;

// User can change anytime per interface
int nbrRows = 4;
int nbrColumns = 4;
int nbrSideTiles = max(nbrRows, nbrColumns);

//Maximal Values
int maxRows = 8;
int maxCols = 8;
int maxSideTiles = 8;

// Initialization needs context,
// therefore initialized on load
double tileSize = 60;

// Flag set while shuffling to prevent init
bool shuffleFlag = false;
