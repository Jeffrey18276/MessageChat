import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  // Constructor with named parameters
  const RoundedButton({
    required this.title,
    required this.colour,
    required this.onPressed,
    this.textColor = Colors.white, // Default text color is white
    this.borderColor = Colors.transparent, // Default border color is transparent
    this.borderWidth = 0.0, // No border by default
  });

  final String title;
  final Color colour;
  final Function() onPressed;
  final Color textColor; // Allow customizing text color
  final Color borderColor; // Customizable border color
  final double borderWidth; // Customizable border width

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: double.infinity, // Full-width button for responsiveness
          height: 42.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
              color: borderColor, // Set border color dynamically
              width: borderWidth, // Set border width dynamically
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: textColor, // Allow customizing text color
              fontSize: 16.0, // You can also adjust font size
            ),
          ),
        ),
      ),
    );
  }
}
