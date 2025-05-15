//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by Tristan Khieu on 5/14/25.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var checkNowButton: UIButton!
    @IBOutlet weak var intervalTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"

        if let savedURL = UserDefaults.standard.string(forKey: "quizURL") {
            urlTextField.text = savedURL
        }
    }

    @IBAction func checkNowTapped(_ sender: UIButton) {
        guard let urlString = urlTextField.text, !urlString.isEmpty else {
            showAlert(title: "Missing URL", message: "Please enter a URL.")
            return
        }

        UserDefaults.standard.set(urlString, forKey: "quizURL")

        fetchQuizzes(from: urlString)
        
        if let intervalText = intervalTextField.text,
           let interval = Double(intervalText) {
            UserDefaults.standard.set(interval, forKey: "refreshInterval")
        }
    }

    func fetchQuizzes(from urlString: String) {
        guard let url = URL(string: urlString) else {
            showAlert(title: "Invalid URL", message: "Check the format.")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Could not fetch quizzes.")
                }
                return
            }

            do {
                let quizzes = try JSONDecoder().decode([Quiz].self, from: data)
                DispatchQueue.main.async {
                    self.showAlert(title: "Success", message: "Fetched \(quizzes.count) quizzes.")
                }
            } catch {
                DispatchQueue.main.async {
                    self.showAlert(title: "Decode Error", message: "Could not parse JSON.")
                }
            }
        }
        task.resume()
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
