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
}

let quizzes: [Quiz] = [
    Quiz(title: "Mathematics", description: "Math ew", iconName: "plus.slash.minus"),
    Quiz(title: "Marvel Super Heroes", description: "Invincible Title Card", iconName: "person.3.fill"),
    Quiz(title: "Science", description: "Scientific Topics! cool...", iconName: "atom")
]
