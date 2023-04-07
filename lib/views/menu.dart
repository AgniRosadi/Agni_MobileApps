import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/helper/util/constant.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    _getData();
    super.initState();
  }

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

  Future<void> _addData(dynamic row) async {
    const key = "listOrder";
    cart.add(row);
    String jsonList = json.encode(cart);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonList);
  }

  Future<void> _getData() async {
    const key = "listOrder";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = prefs.getString(key);
    List<dynamic> retrievedList = jsonDecode(json!);
    List<dynamic> item = retrievedList;
    List<int> prices = [];
    for (var i = 0; i < item.length; i++) {
      prices.add(int.parse(item[i]['price']));
    }
    for (int i = 0; i < prices.length; i++) {
      total += prices[i];
    }
    order.addAll(item);
    print(total);
  }

  int total = 0;
  int counter = 0;
  bool isBusy = false;
  List<dynamic> cart = [];
  List<dynamic> order = [];
  TextEditingController totalController = TextEditingController();
  TextEditingController uangController = TextEditingController();
  TextEditingController kembalianController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 10,
        title: _searchBar(),
        iconTheme: const IconThemeData(
          color: Colors.blueAccent, // warna icon
        ),
      ),
      body: SafeArea(
          child: FutureBuilder<List<dynamic>>(
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                7,
                                        child: Image.network(row['picture'],
                                            fit: BoxFit.fill)),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(row['name']),
                                    Expanded(child: Container()),
                                    Text.rich(TextSpan(
                                        text: 'Rp. ${row['price'] ?? '0'}',
                                        style: const TextStyle(
                                            color: Colors.blueAccent),
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: ' / porsi',
                                            style: TextStyle(
                                                color: Colors.grey.shade500),
                                          )
                                        ])),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            // _addData(row['name'], row['price'],
                                            //     row['picture']);
                                            _addData(row);
                                          },
                                          child: const Text(
                                            "Order",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    )
                                  ],
                                ),
                              );
                            }),
                      ),
                      Stack(children: [
                        const Divider(
                          height: 1,
                          thickness: 5,
                        ),
                        Container(
                          alignment: Alignment.center,
                          transform: Matrix4.translationValues(0.0, -25, 0.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (isBusy) {
                                setState(() {
                                  isBusy = false;
                                });
                              } else {
                                setState(() {
                                  isBusy = true;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                            ),
                            child: const FaIcon(FontAwesomeIcons.chevronUp,
                                size: 15),
                          ),
                        )
                      ]),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              const Icon(Icons.shopping_basket_outlined),
                              const SizedBox(
                                width: 10,
                              ),
                              Text('Rp. ${total ?? '0'}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ]),
                            ElevatedButton(
                                onPressed: () {
                                  _actionCharge();
                                },
                                child: const Text('Charge'))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (isBusy)
                        Expanded(
                            child: ListView.builder(
                          itemCount: order.length,
                          itemBuilder: (context, index) {
                            var row = order[index];
                            return ListTile(
                              title: Text(row['name']),
                              subtitle: Text.rich(TextSpan(
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
                              leading: Image.network(row['picture']),
                              trailing: Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (counter > 0) {
                                          setState(() {
                                            counter--;
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 0.1,
                                                color: Colors.blueAccent)),
                                        child: const FaIcon(
                                            FontAwesomeIcons.minus,
                                            color: Colors.blueAccent),
                                      ),
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          counter.toString(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          counter++;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Colors.blueAccent,
                                            border: Border.all(width: 0.1)),
                                        child: const Icon(Icons.add,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ))
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner.
                return const Center(child: CircularProgressIndicator());
              })),
    );
  }

  Widget _searchBar() {
    TextEditingController _searchController = TextEditingController();
    return TextFormField(
      onFieldSubmitted: (_) {},
      textInputAction: TextInputAction.search,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _searchController,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Cari Menu",
          filled: true,
          fillColor: Colors.grey.shade100,
          prefixIcon: const Icon(Icons.search)),
      enableSuggestions: false,
      autocorrect: false,
    );
  }

  Future<void> _actionCharge() async {
    totalController.text = total.toString();
    await showDialog<dynamic>(
        context: context,
        builder: (BuildContext addcontext) => AlertDialog(
              title: const Text('Detail Pesanan'),
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Form(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: totalController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'Total',
                            filled: true,
                            enabled: false,
                            fillColor: Colors.grey.withOpacity(.08),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(.05)),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(.05)),
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: uangController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignLabelWithHint: true,
                            labelText: 'Uang Dibayar',
                            filled: true,
                            fillColor: Colors.grey.withOpacity(.08),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(.05)),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(.05)),
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: kembalianController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignLabelWithHint: true,
                            labelText: 'Kembalian',
                            enabled: false,
                            filled: true,
                            fillColor: Colors.grey.withOpacity(.08),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(.05)),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.withOpacity(.05)),
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )),
              ),
              actions: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: Colors.blueAccent),
                    onPressed: () async {
                      kembalianController.text = '';
                      uangController.text = '';
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cetak Sturk', style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ));
  }
}
