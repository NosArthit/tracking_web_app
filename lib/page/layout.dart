import 'package:flutter/material.dart';


class LayOutPage extends StatefulWidget {
  @override
  State<LayOutPage> createState() => _LayOutPageState();
}

class _LayOutPageState extends State<LayOutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Responsive Web'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Layout สำหรับหน้าจอขนาดเล็ก (มือถือ)
            return buildMobileLayout();
          } else if (constraints.maxWidth < 1200) {
            // Layout สำหรับหน้าจอขนาดกลาง (แท็บเล็ต)
            return buildTabletLayout();
          } else {
            // Layout สำหรับหน้าจอขนาดใหญ่ (เดสก์ท็อป)
            return buildDesktopLayout();
          }
        },
      ),
    );
  }

  Widget buildMobileLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome to My Web Page',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            buildContent(),
          ],
        ),
      ),
    );
  }

  Widget buildTabletLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome to My Web Page',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            buildContent(),
          ],
        ),
      ),
    );
  }

  Widget buildDesktopLayout() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome to My Web Page',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            buildContent(),
          ],
        ),
      ),
    );
  }

  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'About Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'This is a sample web page created using Flutter. Flutter is a UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.',
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Feature 1',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Description of feature 1.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Feature 2',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Description of feature 2.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Contact Us',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Email: contact@example.com',
                ),
                SizedBox(height: 5),
                Text(
                  'Phone: +123 456 7890',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
