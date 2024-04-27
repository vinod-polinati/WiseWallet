import 'package:flutter/material.dart';
import 'package:walletwise/datetime/date_time_helper.dart';
import 'package:walletwise/models/expense_item.dart';

class ExpenseData extends ChangeNotifier   {
  
  //list of all expenses
  List<ExpenseItem> overallExpenseList = [];

  //get expense list
  List<ExpenseItem> getExpenseList(){
    return overallExpenseList;
  } 
  //add expense
  void addNewExpense(ExpenseItem newExpense){
    overallExpenseList.add(newExpense);

    notifyListeners();
  }

  //delete expense
  void deleteExpense(ExpenseItem expense){
    overallExpenseList.remove(expense);

    notifyListeners();
  }

  //get weekday ( Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday) from  dateTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  //get the date for the start of the week
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    //get todays date
    DateTime today = DateTime.now();

    //go backwards from today to find sunday
    for (int i = 0; i < 7; i++)
    {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sunday') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }
    return startOfWeek!;
  }

  /*

    convert the list of expenses into daily expense summary

    e.g :
    overallExpenseList = 
    [
      [food, 2024/04/28 , ₹1000],
      [ hat, 2024/04/28 , ₹200],
      [drinks, 2024/04/28 , ₹300],
      [food, 2024/04/29 , ₹1000],
      [ hat, 2024/04/29 , ₹200],
      [drinks, 2024/04/29 , ₹300],
      [food, 2024/04/30 , ₹1000],
      [ hat, 2024/04/30 , ₹200],
      [drinks, 2024/04/30 , ₹300], 
    ]

    ->

    DailyExpenseSummary = 
    [
      [20240428, ₹1500],
      [20240429, ₹1500],
      [20240430, ₹1500],
      [20240501, ₹1500],
      [20240502, ₹1500],
      [20240503, ₹1500],
      [20240504, ₹1500],
    ]

  */

  Map<String,double> calculateDailyExpenseSummary() {
    Map<String,double> dailyExpenseSummary = {
      //date (yyyy/mm//dd) : Totalforthatday
    };
    
    for ( var expense in overallExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if(dailyExpenseSummary.containsKey(date)){
        double currentAmount = dailyExpenseSummary[date]!;
        currentAmount += amount;
        dailyExpenseSummary[date] = currentAmount;
    } else{
      dailyExpenseSummary.addAll({date: amount});
    }
  }
    return dailyExpenseSummary;
  }
}