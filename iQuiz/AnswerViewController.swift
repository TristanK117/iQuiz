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
        correctAnswerLabel.text = "Correct answer: \(question.answer)"
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFinished",
           let destination = segue.destination as? FinishedViewController {
            destination.correctAnswers = correctAnswersCount
            destination.totalQuestions = quiz.questions.count
            destination.quiz = quiz
        }
    }
}
