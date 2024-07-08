import 'package:dept_notebook/Pages/invoice.dart';
import 'package:dept_notebook/Shared/AppColors.dart';
import 'package:dept_notebook/Shared/CustomAppBar.dart';
import 'package:dept_notebook/Shared/Database%20Manager.dart';
import 'package:flutter/material.dart';

import '../Shared/sharedTextField.dart';

class AddInvoice extends StatefulWidget {
  String name;
  int id;

   AddInvoice({super.key , required this.name , required this.id});

  @override
  State<AddInvoice> createState() => _AddInvoiceState();
}

class _AddInvoiceState extends State<AddInvoice> {
  var formKey = GlobalKey<FormState>();

  TextEditingController purchases = TextEditingController();
  TextEditingController purchasesValue = TextEditingController();
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
  _insertPurchases(){
    DatabaseManager.insertInvoice(
        table: 'invoice',
        table_2: 'history',
        date: currentTimeAndDate(),
        purchases: purchases.text,
        price: int.parse(purchasesValue.text),
        processType: 'دين',
        re_id: widget.id
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomAppBar(height: 100,fontSize: 25.0, color: AppColors.mainColor, title: 'اضافة مشتريات\n لـ ${widget.name}' , canMove: true,destination: Invoice(id: widget.id, name: widget.name,)),
              MyTextField(title: 'المشتريات' , icon: Icons.tag_faces , maxLines: 10, useICon: false , controller: purchases , isRequired: true),
              MyTextField(title: 'قيمة المشتريات' , icon: Icons.tag_faces, useICon: false , controller: purchasesValue , isRequired: true),
              Padding(padding: const EdgeInsets.only(right: 10.0),child: MaterialButton(onPressed: (){
                if(formKey.currentState!.validate()){
                  _insertPurchases();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Invoice(name: widget.name, id: widget.id,)));
                }
              } , color: AppColors.mainColor , child: const Text("اضافة" , style: TextStyle(color: Colors.white , fontFamily: 'LTKaff'),),)),
          
            ],
          ),
        ),
      ),
    );
  }
}
