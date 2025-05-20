//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Tristan Khieu on 5/12/25.
//

import UIKit


class FinishedViewController: UIViewController {

    var quiz: Quiz!
    var correctAnswers: Int!
    var totalQuestions: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "You got \(correctAnswers ?? 0) out of \(totalQuestions ?? 0) correct."
        scoreLabel.font = .boldSystemFont(ofSize: 24)
        scoreLabel.textAlignment = .center
        view.addSubview(scoreLabel)

        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = .systemFont(ofSize: 20)
        messageLabel.textAlignment = .center
        if correctAnswers == totalQuestions {
            messageLabel.text = "Perfect!"
        } else if correctAnswers >= (totalQuestions / 2) {
            messageLabel.text = "Almost there!"
        } else {
            messageLabel.text = "Keep practicing!"
        }
        view.addSubview(messageLabel)

        let doneButton = UIButton(type: .system)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        view.addSubview(doneButton)

        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            messageLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 40),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            doneButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 60),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshQuizzes), for: .valueChanged)
    }
    
    @objc func refreshQuizzes() {
        print("Pull-to-refresh triggered")

        let urlString = UserDefaults.standard.string(forKey: "quizURL") ?? "http://tednewardsandbox.site44.com/questions.json"
    }

    @objc func doneTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
