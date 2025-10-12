import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Card(
        child: Column(
          children: [
            SizedBox(height: 4),
            Text(expense.title),
            SizedBox(height: 12),
            Row(
              children: [
                SizedBox(width: 10),
                Text('\$${expense.amount.toStringAsFixed(2)}'),
                Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(width: 8),
                    Text(expense.formattedDate),
                  ],
                ),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
