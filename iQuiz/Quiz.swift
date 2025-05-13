//
//  Quiz.swift
//  iQuiz
//
//  Created by Tristan Khieu on 5/5/25.
//


import Foundation


struct Quiz {
    let title: String
    let description: String
    let iconName: String
    let questions: [Question]
}

struct Question {
    let text: String
    let answers: [String]
    let correctAnswerIndex: Int
}

let quizzes: [Quiz] = [
    Quiz(title: "Mathematics", description: "ooo numbers", iconName: "plus.slash.minus", questions: [
        Question(text: "What is 2 + 2?", answers: ["3", "4", "5"], correctAnswerIndex: 1),
        Question(text: "What is 5 × 3?", answers: ["8", "15", "10"], correctAnswerIndex: 1),
        Question(text: "What is 12 ÷ 4?", answers: ["2", "4", "3"], correctAnswerIndex: 2)
    ]),
    Quiz(title: "Marvel Super Heroes", description: "Invincible Title Card", iconName: "person.3.fill", questions: [
        Question(text: "Who is Iron Man?", answers: ["Steve Rogers", "Bruce Banner", "Tony Stark"], correctAnswerIndex: 2),
        Question(text: "Who is the god of thunder?", answers: ["Loki", "Odin", "Thor"], correctAnswerIndex: 2),
        Question(text: "What is Spider-Man's real name?", answers: ["Peter Parker", "Clark Kent", "Bruce Wayne"], correctAnswerIndex: 0)
    ]),
    Quiz(title: "Science", description: "yeah science B#@!$", iconName: "atom", questions: [
        Question(text: "Which planet is known as the Red Planet?", answers: ["Earth", "Mars", "Venus"], correctAnswerIndex: 1),
        Question(text: "What gas do plants absorb?", answers: ["Oxygen", "Carbon Dioxide", "Hydrogen"], correctAnswerIndex: 1),
        Question(text: "What is H2O commonly known as?", answers: ["Salt", "Water", "Sugar"], correctAnswerIndex: 1)
    ])
]
