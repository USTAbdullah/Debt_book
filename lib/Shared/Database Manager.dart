import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {

  static Future<Database> openDataBase() async {

    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'dept_app.db');
    Database db = await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        Batch batch = db.batch();
        batch.execute('''
          CREATE TABLE creditor  (
            cr_id INTEGER PRIMARY KEY,
            name TEXT,
            address TEXT,
            phone INTEGER,
            repaid INTEGER,
            maxPaid INTEGER,
            isRepaid INTEGER NOT NULL
          );
        '''
        );
        batch.execute(
            '''
          CREATE TABLE invoice (
            inv_id INTEGER PRIMARY KEY,
            purchases TEXT,
            price TEXT,
            re_id INTEGER REFERENCES creditor(cr_id)
          );
        '''
        );
        batch.execute(
            '''
          CREATE TABLE history (
            his_id INTEGER PRIMARY KEY,
            type TEXT,
            date TEXT,
            cash INTEGER,
            cre_id INTEGER REFERENCES creditor(cr_id),
            ine_id INTEGER REFERENCES creditor(inv_id)
          );
        '''
        );
        batch.execute(
            '''
          CREATE TABLE user (
            user_id INTEGER PRIMARY KEY,
            businessName TEXT,
            businessDescription TEXT
          );
        '''
        );
        await batch.commit();

        print('Table "creditor" created!====>\n');
        print('Table "invoice" created!====>\n');
        print('Table "history" created!====>\n');

      },
    );
    print('Database opened at: $path');
    return db;
  }



  static Future<int> insertCreditor({required String table1, required String table2,
    required String table3 ,required String name,
    required String address , required int phone ,
    required String purchases , required int price,
    required String processType , required String date}
      ) async {
    Database db = await openDataBase();
    int id = await db.insert('$table1', {'name': name , 'address':address , 'phone': phone , 'maxPaid' : 10000 , 'repaid' : 0, 'isRepaid': 0 });
    int id2 = await db.insert('$table2', {'purchases': purchases , 'price': price , 're_id' : id});
    int id3 = await db.insert('$table3', {'type': processType , 'date': date, 'cash':price , 'cre_id': id,'ine_id' : id2});

    print('Creditor added with id:$id');
    print('Invoice added with id:$id2');
    print('history added with id:$id3');
    return id;
  }


  static Future<int> insertUser({required String name, required String desc}) async{
   try{
     Database db = await openDataBase();
     int id = await db.insert('user', {'businessName': name , 'businessDescription' : desc });
     print('user added with id: $id');
     return id;
   }
   catch(e){
     return 0;
   }
  }
  static Future<int> insertInvoice({required String table,required String table_2 ,required String purchases,required int price , required int re_id, required String processType , required String date}) async {
    Database db = await openDataBase();
    int id = await db.insert('$table', {'purchases': purchases , 'price': price , 're_id' : re_id});
    int id2 = await db.insert('$table_2', {'type': processType , 'date': date, 'cash':price , 'cre_id' : re_id,'ine_id' : id});
    print('Data inserted with id:$id');
    print('Data inserted with id:$id2');
    return id;
  }
  static Future<List<Map>> selectData({required String tableName , required int id}) async{
    Database db = await openDataBase();
    List<Map> values = await db.rawQuery("select *  from $tableName where re_id = $id");

    return values;
  }
  static Future<List<Map>> selectAll()async{
    Database db = await openDataBase();
    List<Map> values = await db.rawQuery(
      '''
      SELECT 
        creditor.cr_id, 
        creditor.name, 
        creditor.phone, 
        creditor.address, 
        creditor.maxPaid AS M, 
        creditor.repaid AS R, 
        invoice.re_id,
        COUNT(invoice.inv_id) AS invoice_count, 
        SUM(invoice.price) AS total_amount
        FROM creditor 
        INNER JOIN invoice 
            ON creditor.cr_id = invoice.re_id
        GROUP BY creditor.cr_id, creditor.name   
      '''
);

    return values;
  }
  static Future<List<Map>> selectUser(int id)async{
    Database db = await openDataBase();
    List<Map> values = await db.rawQuery(
        '''
      SELECT 
        creditor.cr_id, 
        creditor.repaid AS R, 
        invoice.re_id,
        COUNT(invoice.inv_id) AS invoice_count, 
        SUM(invoice.price) AS total_amount
        FROM creditor 
        INNER JOIN invoice 
            ON creditor.cr_id = invoice.re_id
        where cr_id = $id;   
      '''
    );

    return values;
  }
  static Future deleteData({required int id, required String tableName}) async{
    try{
      Database db = await openDataBase();
      var response = await db.delete('$tableName where inv_id = $id');
      return response;
    }
    catch(e){
      print(e);
      return null;
    }
  }
  static Future updateData({required int newMax, required String column,required int id}) async{
    Database db = await openDataBase();
    db.execute(
        '''
        UPDATE 'creditor'
        SET '$column' = '$newMax'
        WHERE cr_id = $id;
    '''
    );
  }
  static Future query(String sql) async{
    Database db = await openDataBase();
   var response =  db.rawQuery(sql);
   return response;
  }


  static Future<List<Map>> representTable(String table)async{
    Database db = await openDataBase();
    List<Map> values = await db.rawQuery(
        '''
      SELECT * from $table
      '''
    );
    return values;
  }


  //history functions

  static Future<List<Map>> displayCreditHistory(String name , int index)async{
    String query = '';
    if(index == 0){
      query =         '''
     SELECT 
  history.his_id, 
  history.type,
  history.cash,
  history.date,
  creditor.name, 
  invoice.purchases,
  invoice.re_id
FROM history
  INNER JOIN creditor 
  ON creditor.cr_id = history.cre_id
  INNER JOIN invoice 
  ON invoice.inv_id = history.ine_id where creditor.name like "%$name%";
  
      ''';
    }
    else if(index == 1){
      query =         '''
     SELECT 
  history.his_id,
  creditor.cr_id, 
  history.type,
  history.cash,
  history.date,
  creditor.name
  FROM history
  INNER JOIN creditor 
  ON creditor.cr_id = history.cre_id  
  where type = "تسديد كامل" OR type = "تسديد جزئي" AND creditor.name like "%$name%";
      ''';
    }
    else if(index == 2){
      query =         '''
     SELECT 
  history.his_id, 
  history.type,
  history.cash,
  history.date,
  creditor.name, 
  invoice.purchases,
  invoice.re_id
FROM history
  INNER JOIN creditor 
  ON creditor.cr_id = history.cre_id
  INNER JOIN invoice 
  ON invoice.inv_id = history.ine_id where creditor.name like "%$name%";
  

      ''';
    }
    Database db = await openDataBase();
    List<Map> values = await db.rawQuery(
      query
    );

    return values;
  }

  static Future<int> recordHistory({required String processType , required String date , required int cash , required int creditorId}) async{
    Database db = await openDataBase();
    int id = await db.insert('history', {'type': processType , 'date': date, 'cash':cash , 'cre_id': creditorId,'ine_id' : null});
   return id;
}

}
