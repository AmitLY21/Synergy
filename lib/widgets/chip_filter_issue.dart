import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
class IssueChipsRow extends StatefulWidget {
  final Function(List<String>) onChipsSelected;
  final List<String> selectedChips;

  IssueChipsRow({required this.onChipsSelected, required this.selectedChips});

  @override
  _IssueChipsRowState createState() => _IssueChipsRowState();
}

class _IssueChipsRowState extends State<IssueChipsRow> {
  List<String> allIssues = AppConstants.allIssues;
  List<bool> chipSelected = [];

  @override
  void initState() {
    super.initState();
    chipSelected = List.generate(AppConstants.allIssues.length, (index) {
      final issue = allIssues[index];
      return widget.selectedChips.contains(issue);
    });
  }

  @override
  void didUpdateWidget(IssueChipsRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the chipSelected list when the selectedChips in the widget is updated
    chipSelected = List.generate(AppConstants.allIssues.length, (index) {
      final issue = allIssues[index];
      return widget.selectedChips.contains(issue);
    });
  }

  void onChipSelected(int index, bool isSelected) {
    setState(() {
      chipSelected[index] = isSelected;
      final selectedChips = getSelectedChips();
      widget.onChipsSelected(selectedChips);
    });
  }

  List<String> getSelectedChips() {
    List<String> selectedChips = [];
    for (int i = 0; i < chipSelected.length; i++) {
      if (chipSelected[i]) {
        selectedChips.add(allIssues[i]);
      }
    }
    return selectedChips;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: allIssues.length,
        itemBuilder: (context, index) {
          final issue = allIssues[index];

          return Container(
            key: ValueKey(issue),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _buildChip(issue, index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChip(String issue, int index) {
    final isSelected = chipSelected[index];

    return FilterChip(
      label: Text(issue),
      selected: isSelected,
      onSelected: (isSelected) => onChipSelected(index, isSelected),
      shape: StadiumBorder(
        side: BorderSide(color: Colors.deepPurple),
      ),
    );
  }
}
