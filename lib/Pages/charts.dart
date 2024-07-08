


import 'package:dept_notebook/Pages/Home.dart';
import 'package:dept_notebook/Shared/CustomAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pie_chart/pie_chart.dart';

import '../Shared/AppColors.dart';
import '../Shared/Database Manager.dart';
class charts extends StatefulWidget {
  const charts({super.key});

  @override
  State<charts> createState() => _chartsState();
}

class _chartsState extends State<charts> {
  bool IsSwitched = false;
  List Data = [];
  Map<String , double> Data_2 = {};
 late int total;
 late int paid;
 late int rest;

  _getData() async {
    var response = await DatabaseManager.selectAll();
    Data = response;
  total = 0;
  paid = 0;
  rest = 0;
    for(int i=0; i<Data.length; i++){
      total += int.parse(Data[i]['total_amount'].toString());

      paid += int.parse(Data[i]['R'].toString());
    }
    rest = total - paid;
    _temp();
  }
 _temp(){
   for (var item in Data) {
    if(item['total_amount'] - item['R'] != 0){
      Map<String, double> mapWithoutAge = {
        item['name']: double.parse((item['total_amount'] - item['R']).toString()),
      };
      Data_2.addAll(mapWithoutAge);
    }


   }
   if(Data_2.length >= 10){
     Data_2.clear();
   }
 }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
      child:Column(
        children: [
          CustomAppBar(height: 100, color: AppColors.mainColor, title: 'احصائيات' , canMove: true,destination: const Home()),
          FutureBuilder(
            future: _getData(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if(Data.isEmpty){
                return const Center(child: Text("لا توجد احصائيات بعد" , style: TextStyle(fontWeight: FontWeight.bold , fontFamily: 'LTKAFF'),));
              }
              else{
                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 10.0),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Row(
                            children: [
                              Expanded(child: Switch(value: IsSwitched, onChanged:  (bool switchMe){
                                setState(() {
                                  IsSwitched = switchMe;
                                });
                              })),
                              const Expanded(child: SizedBox()),
                              const Expanded(child: Text('%' , style: TextStyle(fontFamily: 'LTKAFF' , fontSize: 20.0)))
                    
                            ],
                          ),
                        ),
                        chartContainer(title: 'نسبة الديون',paid: paid , isSwitched: IsSwitched, total: total,rest: rest,  context: context),
                        Divider(
                          height: 50,
                          thickness: 5,
                          color: Colors.greenAccent.shade100,
                        ).animate().slideX(duration: const Duration(milliseconds: 1200)),
                        chartContainerTwo(Data_2: Data_2 , context: context , IsSwitched: IsSwitched),
                    
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ],
      )
      )
    );
  }
}

Widget chartContainer({required String title,required int paid, required int total,required bool isSwitched,required int rest,var context}){
  return PieChart(
  chartType: ChartType.ring,
    dataMap: {
      'المدفوع': isSwitched? ((paid / total) * 100): paid.toDouble() ,
      'المتبقي':isSwitched? ((rest / total) * 100): rest.toDouble() ,
    },
    colorList: [
      Colors.green.shade300,
      Colors.redAccent.shade100,
    ],
    centerText: isSwitched? 'نسبة سداد الديون': 'معدل سداد الديون',
    centerTextStyle: const TextStyle(fontFamily: 'LTKaff', color: Colors.black , fontWeight: FontWeight.bold , fontSize: 10.0),
    chartRadius: 250,
    chartValuesOptions: ChartValuesOptions(
      decimalPlaces: 0,
      showChartValuesInPercentage: isSwitched? true: false
    ),
  );
}
Widget chartContainerTwo({required Map<String, double> Data_2, bool IsSwitched = false,var context}){
  if(Data_2.isEmpty){
    return const SizedBox();
  }
  else{
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.only(left: 10.0),
          child: PieChart(
            animationDuration: Duration(milliseconds: 1000),
            chartType: ChartType.ring,

            dataMap:
            Data_2,
            colorList: [
              Colors.green.shade300,
              Colors.redAccent.shade100,
              Colors.blue.shade200,
              Colors.orange.shade300,
              Colors.teal.shade400,
              Colors.purple.shade200,
              Colors.pink.shade300,
              Colors.cyan.shade400,
              Colors.greenAccent.shade100,
              Colors.red.shade200,
              Colors.blueAccent.shade200,
              Colors.orangeAccent.shade400,
              Colors.tealAccent.shade700,
              Colors.purpleAccent.shade100,
              Colors.pinkAccent.shade200,
              Colors.cyanAccent.shade700,
              Colors.green.shade500,
              Colors.red.shade400,
              Colors.blue.shade400,
              Colors.orange.shade700,
              Colors.teal.shade700,
              Colors.purple.shade400,
              Colors.pink.shade400,
              Colors.cyan.shade700,
              Colors.greenAccent.shade400,
              Colors.redAccent.shade400,
              Colors.blueAccent.shade400,
              Colors.orangeAccent.shade700,
              Colors.tealAccent.shade400,
              Colors.purpleAccent.shade400,
              Colors.pinkAccent.shade400,
              Colors.cyanAccent.shade400,
              Colors.green.shade700,
              Colors.red.shade700,
              Colors.blue.shade700,
              Colors.orange.shade900,
              Colors.teal.shade900,
              Colors.purple.shade700,
              Colors.pink.shade700,
              Colors.cyan.shade900,
              Colors.greenAccent.shade700,
              Colors.redAccent.shade700,
              Colors.blueAccent.shade700,
            ],
            centerText: 'المتبقي حسب الشخص',
            legendOptions: const LegendOptions(
                legendTextStyle: TextStyle(fontFamily: 'LTKaff' , fontSize: 8.0 , fontWeight: FontWeight.bold)
            ),
            centerTextStyle: const TextStyle(fontFamily: 'LTKaff', color: Colors.black , fontSize: 8.0 , fontWeight: FontWeight.bold),
            chartRadius: 250,
            chartValuesOptions:  ChartValuesOptions(
              chartValueBackgroundColor: Colors.transparent,
              decimalPlaces: 0,
              chartValueStyle: const TextStyle(fontSize: 8,fontWeight: FontWeight.bold , color: Colors.black),
           showChartValuesInPercentage: IsSwitched,
            ),
          ),
        ),
        Divider(
          height: 50,
          thickness: 5,
          color: Colors.redAccent.shade100,
        ).animate().slideX(duration: const Duration(milliseconds: 1200)),
      ],
    );
  }
}
