import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/services/screen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: StreamBuilder(
        stream: ScreenService().getScreens(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Cannot load screen datat!');
          }

          if (snapshot.hasData) {
            final screens = snapshot.data!.docs;
            return showScreenGrid(screens);
          }

          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
    );
  }

  GridView showScreenGrid(List<QueryDocumentSnapshot<Object?>> screens) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
      ),
      itemCount: screens.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: GridTile(
            header: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                  onPressed: () {
                    // set screen content
                    setScreenContent(screensId: screens[index].id);
                  },
                  icon: const Icon(Icons.edit_note)),
            ),
            footer: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  screens[index]['title'].toString().toUpperCase(),
                ),
              ),
            ),
            child: const Icon(
              Icons.screenshot_monitor,
              size: 32.0,
            ),
          ),
        );
      },
    );
  }

  void setScreenContent({required String screensId}) {
    TextEditingController textContentContoller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Content'),
          content: TextFormField(
            controller: textContentContoller,
            decoration: InputDecoration(
              hintText: 'Enter some text',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                // save
                String screenContent = textContentContoller.text.trim();
                if (screenContent.isEmpty) {
                  screenContent = "No Content";
                }
                ScreenService()
                    .setScreenContent(id: screensId, content: screenContent);
                textContentContoller.clear();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            )
          ],
        );
      },
    );
  }
}
