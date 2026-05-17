import 'package:flutter/material.dart';

class CustomNewRow {
  DataRow newRow(bool isEditing, Function() onUpdate) {
    return DataRow(
      cells: [
        DataCell(Center(child: isEditing ? Text('') : Text('new'))),
        DataCell(
          Center(
            child: isEditing
                ? TextField(
                  textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'nome',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                : Text('new'),
          ),
        ),
        DataCell(Center(child: isEditing ? TextField() : Text('new'))),
        DataCell(Center(child: isEditing ? TextField() : Text('new'))),
        DataCell(Center(child: isEditing ? TextField() : Text('new'))),
        DataCell(Center(child: isEditing ? TextField() : Text('new'))),
        DataCell(Center(child: isEditing ? TextField() : Text('new'))),
        DataCell(Center(child: isEditing ? TextField() : Text('new'))),
        DataCell(Center(child: isEditing ? TextField() : Text('new'))),
        DataCell(
          Center(
            child: IconButton(
              onPressed: () {
                onUpdate();
              },
              icon: isEditing ? Icon(Icons.save) : Icon(Icons.add),
            ),
          ),
        ),
        DataCell(
          Center(
            child: isEditing
                ? IconButton(onPressed: () {
                  onUpdate();
                }, icon: Icon(Icons.delete))
                : Text(''),
          ),
        ),
      ],
    );
  }
}
