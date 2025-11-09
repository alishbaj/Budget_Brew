const express = require('express');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = process.env.PORT || 3000;

// Serve static files from public directory
app.use(express.static('public'));

// Serve images from public/images
app.use('/images', express.static(path.join(__dirname, 'public', 'images')));

// Parse JSON bodies
app.use(express.json());

// Root route - serve index.html
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// API Routes
// Get user data
app.get('/api/user/:id', (req, res) => {
    const userId = req.params.id;
    
    // Mock user data
    const mockUsers = {
        '1': {
            id: 1,
            name: 'Alice Johnson',
            finScore: 75.5,
            budgetAdherence: 82,
            savingProgress: 68,
            investmentPerformance: 71,
            quizScore: 85
        },
        '2': {
            id: 2,
            name: 'Bob Smith',
            finScore: 68.2,
            budgetAdherence: 75,
            savingProgress: 62,
            investmentPerformance: 65,
            quizScore: 78
        },
        '3': {
            id: 3,
            name: 'Carol Williams',
            finScore: 82.1,
            budgetAdherence: 88,
            savingProgress: 79,
            investmentPerformance: 76,
            quizScore: 92
        },
        '4': {
            id: 4,
            name: 'David Brown',
            finScore: 59.8,
            budgetAdherence: 65,
            savingProgress: 55,
            investmentPerformance: 58,
            quizScore: 70
        },
        '5': {
            id: 5,
            name: 'Emma Davis',
            finScore: 91.3,
            budgetAdherence: 95,
            savingProgress: 88,
            investmentPerformance: 89,
            quizScore: 96
        }
    };
    
    const user = mockUsers[userId] || mockUsers['1'];
    res.json(user);
});

// Get all users (for leaderboard)
app.get('/api/users', (req, res) => {
    const users = [
        {
            id: 1,
            name: 'Alice Johnson',
            finScore: 75.5,
            budgetAdherence: 82,
            savingProgress: 68,
            investmentPerformance: 71,
            quizScore: 85
        },
        {
            id: 2,
            name: 'Bob Smith',
            finScore: 68.2,
            budgetAdherence: 75,
            savingProgress: 62,
            investmentPerformance: 65,
            quizScore: 78
        },
        {
            id: 3,
            name: 'Carol Williams',
            finScore: 82.1,
            budgetAdherence: 88,
            savingProgress: 79,
            investmentPerformance: 76,
            quizScore: 92
        },
        {
            id: 4,
            name: 'David Brown',
            finScore: 59.8,
            budgetAdherence: 65,
            savingProgress: 55,
            investmentPerformance: 58,
            quizScore: 70
        },
        {
            id: 5,
            name: 'Emma Davis',
            finScore: 91.3,
            budgetAdherence: 95,
            savingProgress: 88,
            investmentPerformance: 89,
            quizScore: 96
        }
    ];
    
    res.json(users);
});

// Get quiz questions
app.get('/api/quiz/questions', (req, res) => {
    const questions = [
        {
            id: 1,
            question: 'What is the recommended percentage of your income to save?',
            options: ['5-10%', '10-20%', '20-30%', '30-40%'],
            correctAnswer: 1
        },
        {
            id: 2,
            question: 'What is compound interest?',
            options: [
                'Interest calculated only on the principal',
                'Interest calculated on principal and previously earned interest',
                'A type of loan',
                'A savings account type'
            ],
            correctAnswer: 1
        },
        {
            id: 3,
            question: 'What is an emergency fund?',
            options: [
                'Money for vacations',
                'Money set aside for unexpected expenses',
                'Investment account',
                'Credit card limit'
            ],
            correctAnswer: 1
        },
        {
            id: 4,
            question: 'What does APR stand for?',
            options: [
                'Annual Payment Rate',
                'Annual Percentage Rate',
                'Average Payment Rate',
                'Applied Percentage Rate'
            ],
            correctAnswer: 1
        },
        {
            id: 5,
            question: 'What is the 50/30/20 budget rule?',
            options: [
                '50% needs, 30% wants, 20% savings',
                '50% savings, 30% needs, 20% wants',
                '50% wants, 30% needs, 20% savings',
                '50% needs, 30% savings, 20% wants'
            ],
            correctAnswer: 0
        }
    ];
    
    res.json(questions);
});

// Start server
app.listen(PORT, () => {
    console.log(`🚀 BudgetBrew server running on http://localhost:${PORT}`);
    console.log(`📁 Serving static files from: ${path.join(__dirname, 'public')}`);
});

