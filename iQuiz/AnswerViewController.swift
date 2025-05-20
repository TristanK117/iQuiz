//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Tristan Khieu on 5/12/25.
//


import UIKit

class AnswerViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!

    var quiz: Quiz!
    var question: Question!
    var userAnswerIndex: Int!
    var isCorrect: Bool!
    var currentQuestionIndex: Int!
    var correctAnswersCount: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        questionLabel.text = question.text

        if let correctIndex = Int(question.answer).map({ $0 - 1 }),
           correctIndex >= 0,
           correctIndex < question.answers.count {
            correctAnswerLabel.text = "Correct answer: \(question.answers[correctIndex])"
        } else {
            correctAnswerLabel.text = "Correct answer: Unknown"
        }

        resultLabel.text = isCorrect ? "You got it right!" : "That was incorrect."

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(nextTapped(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(abandonQuiz))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }

    @IBAction func nextTapped(_ sender: Any) {
        if currentQuestionIndex + 1 < quiz.questions.count {
            if let questionVC = storyboard?.instantiateViewController(withIdentifier: "QuestionViewController") as? QuestionViewController {
                questionVC.quiz = quiz
                questionVC.currentQuestionIndex = currentQuestionIndex + 1
                questionVC.correctAnswersCount = correctAnswersCount
                navigationController?.pushViewController(questionVC, animated: true)
            }
        } else {
            let finishedVC = FinishedViewController()
            finishedVC.quiz = quiz
            finishedVC.correctAnswers = correctAnswersCount
            finishedVC.totalQuestions = quiz.questions.count
            navigationController?.pushViewController(finishedVC, animated: true)
        }
    }

    @objc func abandonQuiz() {
        navigationController?.popToRootViewController(animated: true)
    }
}
