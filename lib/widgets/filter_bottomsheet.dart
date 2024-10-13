import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import '../view_models/courses_viewmodel.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CoursesViewModel>(context);

    // Define the duration choices directly here
    final List<String> durations = ['3-8 Hours', '8-14 Hours', '14-20 Hours', '20-24 Hours', '24-30 Hours'];

    return Column(
      mainAxisSize: MainAxisSize.min, // Dynamic bottom sheet height
      children: [
        // Header Row (fixed, not scrollable)
        Padding(
          padding: const EdgeInsets.only(top: 8,left: 8,right: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                  FocusScope.of(context).unfocus();
                }
              ),
              const Text(
                'Search Filter',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 48), // Placeholder for symmetry with the close button
            ],
          ),
        ),

        // The scrollable content
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20.0,bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categories Label
                  const Text(
                    'Categories',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Limiting the width so chips can wrap into two rows
                  SizedBox(
                    height: 100, // Fixed height for two rows
                    child: Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal, // Horizontal scrolling
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 3.8, // Limit width so that chips can wrap
                              child: Wrap(
                                spacing: 8, // Space between chips horizontally
                                runSpacing: 8, // Space between chips vertically (for multi-row)
                                children: viewModel.categories.map((category) {
                                  bool isSelected = viewModel.selectedCategory == category;
                                  return ChoiceChip(
                                    label: Text(category),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      viewModel.setSelectedCategory(selected ? category : ''); // Update category selection
                                    },
                                    // Custom chip appearance
                                    selectedColor: const Color(0xFF3d5cff), // Blue background when selected
                                    backgroundColor: const Color(0xFFdce4fc), // Light grey background when unselected
                                    labelStyle: TextStyle(
                                      color: isSelected ? Colors.white : const Color(0xFF858597), // White text when selected, dark grey when unselected
                                      fontWeight: FontWeight.bold,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12), // Rounded corners for the chips
                                      side: const BorderSide(
                                        color: Colors.transparent, // No visible border
                                      ), // No border
                                    ),
                                    showCheckmark: false, // This disables the default checkmark
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price Range Label and Slider
                  const Text(
                    'Price',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  // Custom Range Slider
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: SfRangeSliderTheme(
                      data: SfRangeSliderThemeData(
                        thumbColor: Colors.white,        // White thumb color
                       thumbStrokeWidth: 2,             // Blue border width
                       thumbStrokeColor: Colors.blue,   // Blue border color
                        thumbRadius: 18, // Custom thumb size
                        overlayColor: Colors.grey.withOpacity(0.2),  // Light blue overlay
                        overlayRadius: 26,
                        activeTrackHeight: 3,
                        inactiveTrackHeight: 2,
                        tooltipBackgroundColor: Colors.transparent,
                        tooltipTextStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      child: SfRangeSlider(
                        min: 0.0,
                        max: 15000.0,
                        values: SfRangeValues(viewModel.minPrice, viewModel.maxPrice),
                        showTicks: false,
                        stepSize: 1,
                        showLabels: false,
                        inactiveColor: Colors.grey.shade400,
                        enableTooltip: false,   // Enable dynamic tooltip for price
                        // shouldAlwaysShowTooltip: true, // Tooltip always visible
                        // tooltipTextFormatterCallback: (dynamic actualValue, String formattedText) {
                        //   return '\$${actualValue.toInt()}';  // Price formatting
                        // },
                        // Using custom labels as tooltips below the thumbs
                        startThumbIcon: _buildThumbLabel(viewModel.minPrice),
                        endThumbIcon: _buildThumbLabel(viewModel.maxPrice),
                        onChanged: (SfRangeValues newValues) {
                          viewModel.setPriceRange(newValues.start, newValues.end);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Duration Label
                  const Text(
                    'Duration',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Duration Choice Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: durations.map((duration) {
                      bool isSelected = viewModel.selectedDuration == duration;
                      return ChoiceChip(
                        label: Text(duration),
                        selected: isSelected,
                        onSelected: (selected) {
                         viewModel.setSelectedDuration(selected ? duration : ''); // Update duration selection
                        },
                        // Custom chip appearance for duration
                        selectedColor: const Color(0xFF3d5cff), // Blue background when selected
                        backgroundColor: const Color(0xFFdce4fc),  // Light grey background when unselected
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF858597), // White text when selected, dark grey when unselected
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Rounded corners for the chips
                          side: const BorderSide(
                            color: Colors.transparent, // No visible border
                          ), // No border
                        ),
                        showCheckmark: false, // Disable the default checkmark
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      // Clear Button (smaller size)
                      Expanded(
                        flex: 1, // Smaller flex value for Clear button
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF3D5CFF), width: 1), // Blue border
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // Rounded corners
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16), // Vertical padding for height
                          ),
                          onPressed: () {
                            // Clear filter
                            viewModel.clearFilters();
                            Navigator.of(context).pop();
                            FocusScope.of(context).unfocus();
                          },
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              color: Color(0xFF3D5CFF), // Blue text color
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16), // Space between buttons

                      // Apply Filter Button (larger size)
                      Expanded(
                        flex: 2, // Larger flex value for Apply Filter button
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3D5CFF), // Blue background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // Rounded corners
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16), // Vertical padding for height
                          ),
                          onPressed: () {
                            // Apply filter
                            viewModel.applyFilters(); // Filter products based on selection
                            Navigator.of(context).pop();
                            FocusScope.of(context).unfocus();
                          },
                          child: const Text(
                            'Apply Filter',
                            style: TextStyle(
                              color: Colors.white, // White text color
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  // Build the custom label for thumb (like a tooltip)
  Widget _buildThumbLabel(double value) {
    return Transform.translate(
      offset: const Offset(0, 32), // Adjusts the position of the label below the thumb
      child: Center(
        child: Text(
          '\$${value.toInt()}',  // Format the value
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 10),
        ),
      ),
    );
  }
}
