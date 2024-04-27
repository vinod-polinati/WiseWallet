import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:walletwise/components/expense_summary.dart';
import 'package:walletwise/components/expense_tile.dart';
import 'package:walletwise/data/expense_data.dart';
import 'package:walletwise/models/expense_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseRupeeController = TextEditingController();
  final newExpensePaisaController = TextEditingController();

  //add new expense
  void addNewExpense(){
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text('Add New Expense'),
        content: Column(
          children: [
            //expense name
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(
                hintText: 'Expense name',
              ),
            ),

            //expense amount
            Row(
              children: [
                //rupees
                Expanded(
                  child: TextField(
                    controller: newExpenseRupeeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Rupees',
              )
                  ),
                ),

                //paisa
                Expanded(
                  child: TextField(
                    controller: newExpensePaisaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Paisa',
              )
                  ),
                ),
              ],
            )
          ],

        ),
        actions: [
        //save button
        MaterialButton(
          onPressed: save,
          child: Text('Save'),
        ),
        //cancel button
        MaterialButton(
          onPressed: cancel,
          child: Text('Cancel'),
        )
        ],
      ),
    );

  }

  //save
  void save ()
  {
     //put rupees and paisa together
    String amount= '${newExpenseRupeeController.text}.${newExpensePaisaController.text}';

    //create new expense
    ExpenseItem newExpense = ExpenseItem(
      name: newExpenseNameController.text, 
      amount: amount, 
      dateTime: DateTime.now(),
    );
    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);

    Navigator.pop(context);
    clear();
  }

  //cancel
  void cancel (){
    Navigator.pop(context);
    clear();
   }

   //clear
    void clear() {
      newExpenseNameController.clear();
      newExpenseRupeeController.clear();
      newExpensePaisaController.clear();
    }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: FloatingActionButton(
        onPressed: addNewExpense,
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: [
          //weekly summary bitch
          ExpenseSummary(startOfweek: value.startOfWeekDate()),

          const SizedBox(height: 20),


          //expense list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: value.getExpenseList().length,
          itemBuilder: (context, index) => ExpenseTile(
            name: value.getExpenseList()[index].name, 
            amount: value.getExpenseList()[index].amount, 
            dateTime: value.getExpenseList()[index].dateTime,
          )
      ),
        ],
      )
    ),
    );
  }
}