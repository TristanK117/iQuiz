//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Tristan Khieu on 5/12/25.
//
import UIKit

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!

    var quiz: Quiz!
    var currentQuestionIndex = 0
    var selectedAnswerIndex: Int?
    var correctAnswersCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        submitButton.isEnabled = false
        displayCurrentQuestion()
    }

    func displayCurrentQuestion() {
        let question = quiz.questions[currentQuestionIndex]
        questionLabel.text = question.text
        selectedAnswerIndex = nil
        submitButton.isEnabled = false
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quiz.questions[currentQuestionIndex].answers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        cell.textLabel?.text = quiz.questions[currentQuestionIndex].answers[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAnswerIndex = indexPath.row
        submitButton.isEnabled = true
    }

    @IBAction func submitTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowAnswer", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAnswer",
           let destination = segue.destination as? AnswerViewController {

            let question = quiz.questions[currentQuestionIndex]

            guard let selected = selectedAnswerIndex,
                  selected >= 0,
                  selected < question.answers.count else {
                print("❌ Invalid answer index")
                return
            }

            let selectedAnswer = question.answers[selected].trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let correctAnswer = question.answer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let isCorrect = selectedAnswer == correctAnswer
            if isCorrect { correctAnswersCount += 1 }

            destination.quiz = quiz
            destination.question = question
            destination.userAnswerIndex = selected
            destination.isCorrect = isCorrect
            destination.currentQuestionIndex = currentQuestionIndex
            destination.correctAnswersCount = correctAnswersCount
        }
    }
}
