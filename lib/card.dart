import 'package:flutter/material.dart';

class CreatedCard extends StatelessWidget {
  const CreatedCard({super.key});

  @override

  Widget build(BuildContext context) {
    return  Center(
              child:
                  Container(
            
                    width: 200, // Fixed width
                    height: 300, // Fixed height
                    alignment: Alignment.center, // Center child
                    padding: EdgeInsets.all(20), // Inner spacing
                    margin: EdgeInsets.symmetric(horizontal:10),
                    decoration: BoxDecoration(
                      // Styling
                      color: Colors.blue[100], // Background color
                      borderRadius: BorderRadius.circular(20), // Rounded corners
                      border: Border.all(color: Colors.blue, width: 2), // Border
                      boxShadow: [
                        // Shadow effect
                        BoxShadow(blurRadius: 5, color: Colors.grey),
                      ],
                      gradient: LinearGradient(
                        // Gradient background
                        colors: [Colors.blue, Colors.green],
                      ),
                    ),
                    transform: Matrix4.rotationZ(0.0), // 3D transform (tilt)
                    
                    child: Image.asset('Images/test.jpg' ,fit: BoxFit.fill , width: 200, height: 300),
            ),);
  }
}
