import 'package:flutter/material.dart';
import 'package:untitled1/router/app_route.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: const SafeArea(child: _HomeContent()),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent({Key? key}) : super(key: key);

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.green),
              onPressed: () {
                Navigator.pushNamed(context, AppRoute.rMenu);
              },
              child: const Text("Pesan")),
          ElevatedButton(onPressed: () {
            Navigator.pushNamed(context, AppRoute.rRead);
          }, child: const Text("CRUD")),
          ElevatedButton(onPressed: () {}, child: const Text("Keluar")),
        ],
      ),
    );
  }
}
