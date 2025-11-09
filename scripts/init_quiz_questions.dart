// Script to initialize quiz questions in Firestore
// Run with: dart scripts/init_quiz_questions.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

final quizQuestions = [
  {
    'id': '1',
    'question': 'What is the recommended percentage of income to save?',
    'options': ['5-10%', '10-20%', '20-30%', '30-40%'],
    'correctAnswerIndex': 1,
    'explanation':
        'Financial experts recommend saving at least 10-20% of your income for long-term financial security.',
    'points': 10,
  },
  {
    'id': '2',
    'question': 'What is compound interest?',
    'options': [
      'Interest on the principal only',
      'Interest on principal plus previously earned interest',
      'Interest charged on loans',
      'Interest paid monthly'
    ],
    'correctAnswerIndex': 1,
    'explanation':
        'Compound interest is interest calculated on the initial principal and also on accumulated interest from previous periods.',
    'points': 10,
  },
  {
    'id': '3',
    'question': 'What is an emergency fund?',
    'options': [
      'Money for vacations',
      'Money saved for unexpected expenses',
      'Money for investments',
      'Money for monthly bills'
    ],
    'correctAnswerIndex': 1,
    'explanation':
        'An emergency fund is money set aside to cover unexpected expenses or financial emergencies, typically 3-6 months of living expenses.',
    'points': 10,
  },
  {
    'id': '4',
    'question': 'What does APR stand for?',
    'options': [
      'Annual Percentage Rate',
      'Average Payment Rate',
      'Annual Payment Return',
      'Average Percentage Return'
    ],
    'correctAnswerIndex': 0,
    'explanation':
        'APR stands for Annual Percentage Rate, which represents the annual cost of borrowing money, including interest and fees.',
    'points': 10,
  },
  {
    'id': '5',
    'question': 'What is the 50/30/20 budget rule?',
    'options': [
      '50% needs, 30% wants, 20% savings',
      '50% savings, 30% needs, 20% wants',
      '50% wants, 30% needs, 20% savings',
      '50% needs, 30% savings, 20% wants'
    ],
    'correctAnswerIndex': 0,
    'explanation':
        'The 50/30/20 rule suggests allocating 50% of income to needs, 30% to wants, and 20% to savings and debt repayment.',
    'points': 10,
  },
  {
    'id': '6',
    'question': 'What is a credit score used for?',
    'options': [
      'To determine loan eligibility and interest rates',
      'To calculate taxes',
      'To track expenses',
      'To measure income'
    ],
    'correctAnswerIndex': 0,
    'explanation':
        'A credit score is used by lenders to assess creditworthiness and determine loan eligibility and interest rates.',
    'points': 10,
  },
  {
    'id': '7',
    'question': 'What is diversification in investing?',
    'options': [
      'Putting all money in one stock',
      'Spreading investments across different assets',
      'Investing only in bonds',
      'Avoiding investments'
    ],
    'correctAnswerIndex': 1,
    'explanation':
        'Diversification is the strategy of spreading investments across different assets to reduce risk.',
    'points': 10,
  },
  {
    'id': '8',
    'question': 'What is the difference between a debit card and a credit card?',
    'options': [
      'Debit cards use your money, credit cards borrow money',
      'They are the same thing',
      'Credit cards use your money, debit cards borrow money',
      'Debit cards have higher limits'
    ],
    'correctAnswerIndex': 0,
    'explanation':
        'Debit cards withdraw money directly from your bank account, while credit cards allow you to borrow money that you must repay.',
    'points': 10,
  },
  {
    'id': '9',
    'question': 'What is inflation?',
    'options': [
      'Decrease in prices over time',
      'Increase in prices over time',
      'Stable prices',
      'Increase in income'
    ],
    'correctAnswerIndex': 1,
    'explanation':
        'Inflation is the rate at which the general level of prices for goods and services rises, eroding purchasing power.',
    'points': 10,
  },
  {
    'id': '10',
    'question': 'What is a budget?',
    'options': [
      'A plan for spending and saving money',
      'A list of expenses',
      'A savings account',
      'A credit card statement'
    ],
    'correctAnswerIndex': 0,
    'explanation':
        'A budget is a financial plan that helps you track income and expenses to achieve financial goals.',
    'points': 10,
  },
];

Future<void> main() async {
  // Initialize Firebase
  // Note: You need to have Firebase configured before running this script
  // Run: flutterfire configure
  await Firebase.initializeApp();

  final firestore = FirebaseFirestore.instance;

  print('Initializing quiz questions...');

  for (final question in quizQuestions) {
    try {
      await firestore
          .collection('quiz_questions')
          .doc(question['id'] as String)
          .set(question);
      print('Added question ${question['id']}');
    } catch (e) {
      print('Error adding question ${question['id']}: $e');
    }
  }

  print('Done! Quiz questions initialized.');
}

