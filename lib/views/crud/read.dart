import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitled1/helper/util/constant.dart';
import 'package:untitled1/router/app_route.dart';
import 'package:http/http.dart' as http;

class ReadPage extends StatelessWidget {
  const ReadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Read Page"),
      ),
      body: const SafeArea(child: _ReadContent()),
      floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
          ),
          onPressed: () {
            Navigator.pushNamed(context, AppRoute.rAdd);
          },
          child: const Icon(Icons.add)),
    );
  }
}

class _ReadContent extends StatefulWidget {
  const _ReadContent({Key? key}) : super(key: key);

  @override
  State<_ReadContent> createState() => _ReadContentState();
}

class _ReadContentState extends State<_ReadContent> {
  Future<List<dynamic>> fetchData() async {
    final response = await http.get(Uri.parse(Constant.baseUrl),
        headers: {'X-SECRET-TOKEN': Constant.token});
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<http.Response> deleteData(int id) async {
    final response = await http.delete(Uri.parse('${Constant.baseUrl}/$id'),
        headers: {'X-SECRET-TOKEN': Constant.token});
    print("data berhasil dihapus ${response.body}");
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var row = snapshot.data![index];

                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  color: Colors.red,
                                  margin: EdgeInsets.zero,
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 7,
                                  child: Image.network(row?['picture'],
                                      fit: BoxFit.fill)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(row['name']),
                              Expanded(child: Container()),
                              Text.rich(TextSpan(
                                  text: 'Rp. ${row['price'] ?? '0'}',
                                  style:
                                      const TextStyle(color: Colors.blueAccent),
                                  children: <InlineSpan>[
                                    TextSpan(
                                      text: ' / porsi',
                                      style: TextStyle(
                                          color: Colors.grey.shade500),
                                    )
                                  ])),
                              Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () async {
                                          deleteData(row['id']);
                                        },
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return const Center(child: CircularProgressIndicator());
        });
  }
}
