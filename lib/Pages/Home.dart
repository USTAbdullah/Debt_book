
import 'package:dept_notebook/Pages/addCreditor.dart';
import 'package:dept_notebook/Pages/invoice.dart';
import 'package:dept_notebook/Shared/Database%20Manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../Shared/AppColors.dart';
import '../Shared/AppDrawer.dart';
import '../Shared/BottomStack.dart';
import '../Shared/CustomAppBar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController maxPaidController = TextEditingController();
  var keyForm = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List Data = [];
  List userData = [];
  String name = '';
  String des = '';
  bool isLoading = false;
  _getUserData() async{

    List<Map> result = await DatabaseManager.representTable('user');
    userData = result;
    name = userData[0]['businessName'];
    des = userData[0]['businessDescription'];

  }
  _getData() async {
    var response = await DatabaseManager.selectAll();
    Data = response;
  }
  _upDateMaxPaid(int id, int newMax) {
    DatabaseManager.updateData(newMax: newMax, column: 'maxPaid', id: id);
  }
  Color _deptFieldColor(int index) {
    int maxPaid = Data[index]['M'];
    int dept = Data[index]['total_amount'] - Data[index]['R'];

    if (dept >= maxPaid) {
      return Colors.redAccent;
    }
    else if(dept == 0){
      return Colors.greenAccent;
    }
    return Colors.transparent;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: FutureBuilder(
        future: _getUserData(),
        builder: (context, snapshot) {
          if(userData.isEmpty){
            return Drawer();
          }
          else if(snapshot.connectionState == ConnectionState.waiting){
            return Drawer(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          else{
            return myDrawer(name: name, des: des);
          }
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CustomAppBar(
                  height: 100, color: AppColors.mainColor, title: 'الرئيسية'),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.only(right: 30.0, bottom: 30.0),
                  child: InkWell(
                    onTap: () {
                      _getUserData();
                      scaffoldKey.currentState?.openEndDrawer();
                    },
                    child: const Icon(Icons.menu_rounded,
                        size: 38.0, color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: FutureBuilder(
                      future: _getData(),
                      builder: (context, snapshot) {
                        //snapshot = Data as AsyncSnapshot<Object?>;
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (!Data.isEmpty) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingTextStyle: const TextStyle(
                                  fontFamily: 'LTKaff',
                                  fontWeight: FontWeight.bold),
                              dataTextStyle:
                                  const TextStyle(fontFamily: 'LTKaff'),
                              columns: const [
                                DataColumn(label: Text('الأسم')),
                                DataColumn(label: Text('الرقم')),
                                DataColumn(label: Text('مبلغ الدين')),
                                DataColumn(label: Text('المدفوع')),
                                DataColumn(label: Text('الباقي')),
                                DataColumn(label: Text('سقف الدين')),
                                DataColumn(label: Text('رقم الهاتف')),
                                DataColumn(label: Text('العنوان')),
                              ],
                              rows: List.generate(
                                Data.length,
                                (index) {
                                  return DataRow(
                                    color: MaterialStatePropertyAll(
                                        _deptFieldColor(index)),
                                    cells: [
                                      DataCell(Text('${index + 1}')),
                                      DataCell(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Invoice(
                                                name: Data[index]['name'],
                                                id: Data[index]['re_id'],
                                              ),
                                            ),
                                          );
                                        },
                                        Text(
                                          Data[index]['name'],
                                        ),
                                      ),
                                      DataCell(
                                        Text('${Data[index]['total_amount']}'),
                                      ),
                                      DataCell(
                                        Text('${Data[index]['R']}'),
                                      ),
                                      DataCell(
                                        Text(
                                            '${Data[index]['total_amount'] - Data[index]['R']}'),
                                      ),
                                      DataCell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('تعديل السقف'),
                                                content: Form(
                                                  key: keyForm,
                                                  child: TextFormField(
                                                    controller:
                                                        maxPaidController,
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty ||
                                                          value == null) {
                                                        return 'اضف قيمة';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                actions: [
                                                  MaterialButton(
                                                    color: AppColors.mainColor,
                                                    child: const Text(
                                                      "تعديل",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'LTKaff'),
                                                    ),
                                                    onPressed: () {
                                                      if (keyForm.currentState!
                                                          .validate()) {
                                                        _upDateMaxPaid(
                                                            Data[index]
                                                                ['cr_id'],
                                                            int.parse(
                                                                maxPaidController
                                                                    .text));
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        Text('${Data[index]['M']}'),
                                      ),
                                      DataCell(
                                        Text('${Data[index]['phone']}'),
                                      ),
                                      DataCell(
                                        Text('${Data[index]['address']}'),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                                .animate()
                                .blurXY(end: 0, begin: 10, delay: 250.ms),
                          );
                        } else {
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            child: const Center(
                              child: Text("لا توجد ديون",
                                  style: TextStyle(fontFamily: 'LTKaff')),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: BottomStack(
                    function: () {

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddCreditor()));
                    },
                    icon: Icons.add,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
