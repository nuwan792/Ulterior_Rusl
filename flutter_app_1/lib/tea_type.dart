import 'package:flutter/material.dart';
import 'identify_t_cultivar_page.dart';

class TeaTypePage extends StatelessWidget {
  final String username;

  TeaTypePage({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tea Type'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IdentifyTCultivarPage(
                      username: username,
                    ),
                  ),
                );
              },
              child: Text(
                'For Nursery',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.green, padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Use onPrimary for text color
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IdentifyTCultivarPage(
                      username: username,
                    ),
                  ),
                );
              },
              child: Text(
                'For Field',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.orange, padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Use onPrimary for text color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
