import 'package:dept_notebook/Pages/Home.dart';
import 'package:dept_notebook/Pages/addInvoice.dart';
import 'package:dept_notebook/Shared/AppButton.dart';
import 'package:dept_notebook/Shared/AppColors.dart';
import 'package:dept_notebook/Shared/Database%20Manager.dart';
import 'package:dept_notebook/Shared/Message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../Shared/BottomStack.dart';
import '../Shared/CustomAppBar.dart';
class Invoice extends StatefulWidget {
  String name;
  int id;
   Invoice({super.key , required this.name , required this.id});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
   List Data = [];
   List userData = [];
   String months(int monthNumber) {
     List month = [
       'يناير',
       'فبراير',
       'مارس',
       'ابريل',
       'مايو',
       'يونيو',
       'يوليو',
       'أغسطس',
       'سبتمبر',
       'اكتوبر',
       'نوفمبر',
       'ديسيمبر',
     ];
     return month[monthNumber];
   }
   String currentTimeAndDate(){
     DateTime now = DateTime.now();
     int hour = now.hour;
     int minute = now.minute;
     String  textMinute = '';
     if(hour > 12){
       hour = hour - 12;

     }
     if(minute < 10){
       textMinute = '0$minute';

     }
     else{
       textMinute = '$minute';
     }

     String timeNow = '${now.day}/${months(now.month - 1)}/${now.year} - $hour:$textMinute';
     return timeNow;
   }
   _getData() async{
     var res = await DatabaseManager.selectData(tableName: 'invoice', id: widget.id);
     Data = res;
     
   }
   _getUserData()async{
     var res = await DatabaseManager.selectUser(widget.id);
     userData = res;
     print(userData);
   }
   _deleteData(int inv_id)async{
     var res = await DatabaseManager.deleteData(id: inv_id, tableName: 'invoice');
   }
   _updateData({required int id, required bool isFull}) async{
     if(isFull){
       var res = await DatabaseManager.updateData(newMax: userData[0]['total_amount'], column: 'repaid', id: id);
       var res2 = await DatabaseManager.recordHistory(processType: 'تسديد كامل', date: currentTimeAndDate(), cash: userData[0]['total_amount'], creditorId: widget.id);
       setState(() {});
       Navigator.pop(context);
     }
     else{
       int rest = userData[0]['total_amount'] - userData[0]['R'];
       int newValue = userData[0]['R'] + int.parse(partialPay.text);

       if(int.parse(partialPay.text) > rest){
         showDialog(context: context, builder: (context) => message(title: 'رسالة', content: 'المبلغ المضاف اكبر من قيمة باقي الدين', icon: Icons.message));
       }
       else{
         var res = await DatabaseManager.updateData(newMax: newValue, column: 'repaid', id: id);
         var res2 = await DatabaseManager.recordHistory(processType: 'تسديد جزئي', date: currentTimeAndDate(), cash: newValue, creditorId: widget.id);

         setState(() {

         });
         Navigator.pop(context);
       }
     }

   }
   _openSnackBar() async{
     _getUserData();
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         duration: Duration(days: 1),
         showCloseIcon: true,
         backgroundColor: AppColors.mainColor,
         content: Column(
           crossAxisAlignment: CrossAxisAlignment.end,
           children: [
             Align(alignment: Alignment.center,child: Text('تفاصيل الفاتورة' , style: TextStyle(fontFamily: 'LTKaff', fontSize: 25.0 , fontWeight: FontWeight.bold),)),
             Text(textDirection: TextDirection.rtl,'الفاتورة بأسم: ${widget.name}' , style: TextStyle(fontFamily: 'LTKaff', fontSize: 20.0),),
             Text(textDirection: TextDirection.rtl,'اجمالي الدين: ${userData[0]['total_amount']}' , style: TextStyle(fontFamily: 'LTKaff', fontSize: 20.0),),
             Text(textDirection: TextDirection.rtl,'المدفوع:${userData[0]['R']}' , style: TextStyle(fontFamily: 'LTKaff', fontSize: 20.0),),
             Text(textDirection: TextDirection.rtl,'الباقي:${userData[0]['total_amount'] - userData[0]['R']}' , style: TextStyle(fontFamily: 'LTKaff', fontSize: 20.0),),

           ],
         ),
       )
     );
   }
   bool isPaid(){
     int rest = userData[0]['total_amount'] - userData[0]['R'];
     if(rest == 0){
       return true;
     }
     return false;
   }
   _partialRepay() {
     if(isPaid()){
       showDialog(context: context, builder: (context) => message(title: 'رسالة', content: 'تم تسديد الحساب بشكل كامل', icon: Icons.message));
     }
     else{
     showDialog(
     context: context,
     builder: (context) {
     return AlertDialog(
     title: Text(
     textDirection: TextDirection.rtl,
     '''
تم من قبل تسديد:
${userData[0]['R']} ريال

'''
     , style: TextStyle(fontFamily: 'LTKaff', fontSize: 15),),
     content: Form(
     key: keyForm,
     child: TextFormField(
     controller: partialPay,

     decoration:
     const InputDecoration(
     hintText: 'ضع المبلغ المراد تسديدة  هنا',
     hintStyle: TextStyle(fontFamily: 'LTKaff'),
     hintTextDirection: TextDirection.rtl,
     border:
     OutlineInputBorder(),
     ),
     validator: (value) {
     if (value!.isEmpty || value == null) {
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
     "اضافة",
     style: TextStyle(
     color: Colors.white,
     fontFamily: 'LTKaff'),
     ),
     onPressed: () {
     if (keyForm.currentState!.validate()) {
     _updateData(id: widget.id , isFull: false);
     }
     },
     )
     ],
     );
     },
     );
     }
   }
   _fullRepay(){
      if(isPaid()){
        showDialog(context: context, builder: (context) => message(title: 'رسالة', content: 'تم تسديد الحساب بشكل كامل', icon: Icons.message));
      }
      else{
        showDialog(context: context,
          builder: (context) {
            return  AlertDialog(
              icon: Icon(Icons.message , color: AppColors.mainColor),
              title: Text("رسالة"),
              content: Text("هل تريد تسديد الحساب كاملاً؟"),
              actions: [
                MaterialButton(color: Colors.redAccent,onPressed: (){_updateData(id: widget.id, isFull: true);} , child: Text("نعم")),
                MaterialButton(color: AppColors.mainColor,onPressed: (){Navigator.pop(context);} , child: Text("لا")),
              ],
            );
          },
        );
      }
     }

   TextEditingController partialPay = TextEditingController();
   var keyForm = GlobalKey<FormState>();

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
    _getUserData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomAppBar(height: 100,title: widget.name,fontSize: 25.0, color: AppColors.mainColor ,canMove: true , destination:  Home()),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(flex: 2,child: SizedBox()),
              myButton(function: (){_fullRepay();},text: 'تسديد كامل' , icon: Icons.monetization_on_sharp),
              Expanded(child: SizedBox()),
              myButton( function: (){_partialRepay();},text: 'تسديد جزئي' , icon: Icons.density_medium_sharp , color: AppColors.mainColor),
              Expanded(child: SizedBox()),
              myButton(function: (){_openSnackBar();},text: 'تفاصيل الدين' , icon: Icons.question_mark_sharp , color: AppColors.mainColor),
              Expanded(flex: 2,child: SizedBox()),
            ],
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                SingleChildScrollView(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: FutureBuilder(future: _getData(),
                        builder:  (context, snapshot) {
                          if(Data.isEmpty){
                            return const Text('لا توجد ديون');
                          }
                          else{

                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                dataTextStyle: TextStyle(fontFamily: 'LTKaff'),
                                headingTextStyle: TextStyle(fontFamily: 'LTKaff'),
                                columns: const[
                                  DataColumn(label: Text('الرقم')),
                                  DataColumn(label: Text('المشتريات')),
                                  DataColumn(label: Text('القيمة')),
                                  DataColumn(label: Text(' ')),
                                  DataColumn(label: Text(' ')),
                                ],
                                rows: List.generate(
                                  Data.length,
                                  (index) {
                                    return DataRow(
                                        cells: [
                                          DataCell(Text('${index + 1}')),
                                          DataCell(Text(Data[index]['purchases'])),
                                          DataCell(Text(Data[index]['price'].toString())),
                                          DataCell(InkWell(
                                    onTap: (){
                                      showDialog(context: context, builder: (context) {
                                        return message(title: 'تنبية', content: 'هل تريد الحذف؟', icon: Icons.warning , areActions: true ,
                                            function: (){
                                          _deleteData(Data[index]['inv_id']);
                                          Navigator.pop(context);
                                        setState(() {});});

                                      },);

                                    }
                                    ,child: Icon(Icons.delete , color: AppColors.mainColor))),
                                          DataCell(Icon(Icons.edit , color: AppColors.mainColor)),
                                    ]
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        },
                    ),
                  ),
                ),
                Align(alignment: Alignment.bottomRight,child: BottomStack(function: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AddInvoice(name: widget.name , id: widget.id)));
                },icon: Icons.add)),
              ],
            ),
          ),

        ],
      ),
    );
  }
}