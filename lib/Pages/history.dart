import 'package:dept_notebook/Pages/Home.dart';
import 'package:dept_notebook/Shared/AppButton.dart';
import 'package:dept_notebook/Shared/AppColors.dart';
import 'package:dept_notebook/Shared/Database%20Manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../Shared/BottomStack.dart';
import '../Shared/CustomAppBar.dart';
import '../Shared/sharedTextField.dart';

class history extends StatefulWidget {
  history({super.key});

  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {

  int index = 0;
  List<Map> Data = [];

  TextEditingController searchController = TextEditingController();
 bool isSearch = false;
 _showSearch(){
   setState(() {
     isSearch = !isSearch;
   });
 }
   String searchName = '';
  _getData()async{
    var response = await DatabaseManager.displayCreditHistory(searchName , index);
  Data = response;


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomAppBar(height: 100,title: 'السجل',fontSize: 35.0, color: AppColors.mainColor ,canMove: true , destination:  Home()),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(flex: 2,child: SizedBox()),
              myButton(function: (){setState(() {
                print(Data);
                index = 2;
              });},text: 'عمليات اخرى' , icon: Icons.pin_rounded , color: AppColors.mainColor),
              Expanded(child: SizedBox()),
              myButton( function: (){
                setState(() {
                  index = 1;
                });
              },text: 'سجل السداد' , icon: Icons.credit_score_rounded , color: AppColors.mainColor),
              Expanded(child: SizedBox()),
              myButton(function: (){setState(() {
                index = 0;
              });},text: 'سجل الدين' , icon: Icons.credit_card , color: AppColors.mainColor),
              Expanded(flex: 2,child: SizedBox()),
            ],
          ),
          isSearch? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5 , horizontal: 25.0),
                    child: TextFormField(
                       style: TextStyle(fontWeight: FontWeight.bold , fontFamily: 'LTKaff'),
                      controller: searchController,
                      textDirection: TextDirection.rtl,
                      onChanged: (value){
                        setState(() {
                          searchName = value;
                        });
                      },
                      decoration: InputDecoration(
                        
                        hintStyle: TextStyle(fontSize: 15.0 , fontFamily: 'LTKaff' , fontWeight: FontWeight.bold),
                        hintTextDirection: TextDirection.rtl,
                        hintText: 'البحث بالاسم',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
              ),
            ],
          ):SizedBox(),
          Expanded(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                FutureBuilder(
                  future: _getData(),
                    builder: (context, snapshot) {

                     if(Data.isEmpty){
                       return Center(child: Text("لا يوجد سجل" , style: TextStyle(fontFamily: 'LTkaff' , fontWeight: FontWeight.bold),));
                     }
                     else if(snapshot.connectionState == ConnectionState.waiting){
                       return Center(child: CircularProgressIndicator());
                     }
                     else{
                       return SingleChildScrollView(child: Directionality(textDirection: TextDirection.rtl,child: processTableType(index: index , Data: Data , length: Data.length)));
                     }
                    },
                ),
                Align(alignment: Alignment.bottomRight,child: BottomStack(
                    function: (){
                      _showSearch();
                },
                    icon: Icons.search)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget processTableType({required int index , required List <Map> Data , required int length}){
  if(index == 0){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        dataTextStyle: TextStyle(fontFamily: 'LTKaff'),
        headingTextStyle: TextStyle(fontFamily: 'LTKaff'),
        columns: const[
          DataColumn(label: Text('الرقم')),
          DataColumn(label: Text('التاريخ والوقت')),
          DataColumn(label: Text('نوع العملية')),
          DataColumn(label: Text('لصالح')),
          DataColumn(label: Text('مبلغ الدين')),
          DataColumn(label: Text('المشتريات')),


        ],
        rows: List.generate(
          length,
              (index) {
            return DataRow(
                cells: [
                  DataCell(Text('${index + 1}')),
                  DataCell(Text( Data[index]['date'] , textDirection:TextDirection.rtl, style: TextStyle(fontFamily: 'arial' , fontWeight: FontWeight.bold),)),
                  DataCell(Text(Data[index]['type'])),
                  DataCell(Text(Data[index]['name'])),
                  DataCell(Text(Data[index]['cash'].toString())),
                  DataCell(Text(Data[index]['purchases'])),


                ]
            );
          },
        ),
      ),
    );
  }
  else if(index == 1){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        dataTextStyle: TextStyle(fontFamily: 'LTKaff'),
        headingTextStyle: TextStyle(fontFamily: 'LTKaff'),
        columns: const[
          DataColumn(label: Text('الرقم')),
          DataColumn(label: Text('التاريخ والوقت')),
          DataColumn(label: Text('نوع العملية')),
          DataColumn(label: Text('لصالح حساب')),
          DataColumn(label: Text('مبلغ السداد')),

        ],
        rows: List.generate(
          Data.length,
              (index) {
            return DataRow(
                cells: [
                  DataCell(Text('${index + 1}')),
                  DataCell(Text(Data[index]['date'])),
                  DataCell(Text(Data[index]['type'])),
                  DataCell(Text(Data[index]['name'])),
                  DataCell(Text(Data[index]['cash'].toString())),
                ]
            );
          },
        ),
      ),
    );
  }
  else{
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        dataTextStyle: TextStyle(fontFamily: 'LTKaff'),
        headingTextStyle: TextStyle(fontFamily: 'LTKaff'),
        columns: const[
          DataColumn(label: Text('الرقم')),
          DataColumn(label: Text('نوع العملية')),
          DataColumn(label: Text('لصالح حساب')),
          DataColumn(label: Text('تاريخ العملية')),
          DataColumn(label: Text('مبلغ السداد')),
          DataColumn(label: Text('مبلغ الدين')),
          DataColumn(label: Text('تفصيل اخرى')),
        ],
        rows: List.generate(
          20,
              (index) {
            return DataRow(
                cells: [
                  DataCell(Text('${index + 1}')),
                  DataCell(Text('test')),
                  DataCell(Text('test')),
                  DataCell(Text('test')),
                  DataCell(Text('test')),
                  DataCell(Text('test')),
                  DataCell(Text('test')),

                ]
            );
          },
        ),
      ),
    );
  }
}