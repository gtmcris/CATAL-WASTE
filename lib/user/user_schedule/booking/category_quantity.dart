import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/user/user_schedule/booking/date_schedule.dart';

class CategoryQuantity extends StatefulWidget {
  final Map<String, dynamic>? addressItem;
  final List<String> selectedCategories;
  const CategoryQuantity(this.selectedCategories, this.addressItem, {Key? key});

  @override
  _WasteTypesScreenState createState() => _WasteTypesScreenState();
}

class _WasteTypesScreenState extends State<CategoryQuantity> {
  final Map<String, dynamic> wasteMap = {
    "Bio Waste": {
      "Food scraps": "20 Cr/gram",
      "Yard waste": "15 Cr/gram",
      "Paper": "10 Cr/gram",
      "Vegetable and fruit peels": "18 Cr/gram",
      "Coffee grounds": "22 Cr/gram"
    },
    "Plastic": {
      "Plastic bottles": "25 Cr/gram",
      "Containers": "30 Cr/gram",
      "Bags": "28 Cr/gram",
      "Packaging materials": "12 Cr/gram",
      "Utensils": "35 Cr/gram",
      "Toys": "40 Cr/gram"
    },
    "Degradable": {
      "Organic matter": "20 Cr/gram",
      "Compostable materials": "18 Cr/gram",
      "Plant-based plastics": "22 Cr/gram"
    },
    "Hazardous": {
      "Chemicals": "50 Cr/gram",
      "Batteries": "60 Cr/gram",
      "Fluorescent bulbs": "55 Cr/gram",
      "Paints": "45 Cr/gram",
      "Solvents": "70 Cr/gram",
      "Pesticides": "65 Cr/gram"
    }
  };

  final Map<String, IconData> subcategoryIcons = {
    "Food scraps": Icons.restaurant,
    "Yard waste": Icons.grass,
    "Paper": Icons.description,
    "Vegetable and fruit peels": Icons.eco,
    "Coffee grounds": Icons.local_cafe,
    "Plastic bottles": Icons.local_drink,
    "Containers": Icons.shopping_basket,
    "Bags": Icons.shopping_bag,
    "Packaging materials": Icons.card_giftcard,
    "Utensils": Icons.dinner_dining,
    "Toys": Icons.toys,
    "Organic matter": Icons.nature,
    "Compostable materials": Icons.eco,
    "Plant-based plastics": Icons.eco,
    "Chemicals": Icons.hourglass_bottom_sharp,
    "Batteries": Icons.battery_full,
    "Fluorescent bulbs": Icons.lightbulb,
    "Paints": Icons.brush,
    "Solvents": Icons.cleaning_services,
    "Pesticides": Icons.bug_report,
  };

  Map<String, List<String>> selectedWasteItems = {};

  void updateSelectedWasteItems(
      String wasteType, String wasteItem, bool isChecked) {
    setState(() {
      if (isChecked) {
        if (!selectedWasteItems.containsKey(wasteType)) {
          selectedWasteItems[wasteType] = [];
        }
        selectedWasteItems[wasteType]!.add(wasteItem);
      } else {
        selectedWasteItems[wasteType]!.remove(wasteItem);
        if (selectedWasteItems[wasteType]!.isEmpty) {
          selectedWasteItems.remove(wasteType);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 21, 24, 29),
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Waste Types',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 21, 24, 29),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: widget.selectedCategories.length,
        itemBuilder: (BuildContext context, int index) {
          String category = widget.selectedCategories[index];
          Map<String, String> subcategories = wasteMap[category] ?? {};

          return Card(
            color: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                ...subcategories.entries.map((entry) {
                  String subcategory = entry.key;
                  String price = entry.value;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        bool isSelected = selectedWasteItems[category]
                                ?.contains(subcategory) ??
                            false;
                        if (isSelected) {
                          selectedWasteItems[category]?.remove(subcategory);
                        } else {
                          selectedWasteItems
                              .putIfAbsent(category, () => [])
                              .add(subcategory);
                        }
                      });
                    },
                    child: Card(
                      color:
                          selectedWasteItems[category]?.contains(subcategory) ??
                                  false
                              ? Color.fromARGB(255, 15, 3, 72)
                              : Color.fromARGB(255, 59, 60, 83),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Icon(
                              subcategoryIcons[subcategory] ?? Icons.category,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                subcategory,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              price,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(selectedWasteItems);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DatePickerPage(
                  selectedCategories: selectedWasteItems,
                  addressItem: widget.addressItem),
            ),
          );
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
