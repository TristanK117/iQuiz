//
//  ViewController.swift
//  iQuiz
//
//  Created by Tristan Khieu on 5/4/25.
//

import UIKit
import Network

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    var quizzes: [Quiz] = []
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkMonitor")
    var refreshTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "iQuiz"
        let settingsButton = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(showSettings))
        navigationItem.rightBarButtonItem = settingsButton

        tableView.delegate = self
        tableView.dataSource = self

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshQuizzes), for: .valueChanged)
        tableView.refreshControl = refreshControl

        let urlString = UserDefaults.standard.string(forKey: "quizURL") ?? "https://tednewardsandbox.site44.com/questions.json"
        fetchQuizzes(from: urlString)

        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "No Internet Connection",
                                                  message: "Please check your network settings.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
        monitor.start(queue: queue)

        let interval = UserDefaults.standard.double(forKey: "refreshInterval")
        if interval > 0 {
            refreshTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                print("🔁 Timed refresh triggered")
                let urlString = UserDefaults.standard.string(forKey: "quizURL") ?? "http://tednewardsandbox.site44.com/questions.json"
                self.fetchQuizzes(from: urlString)
            }
        }
    }

    @objc func refreshQuizzes() {
        let urlString = UserDefaults.standard.string(forKey: "quizURL") ?? "http://tednewardsandbox.site44.com/questions.json"
        fetchQuizzes(from: urlString)
        tableView.refreshControl?.endRefreshing()
    }

    func fetchQuizzes(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            do {
                let quizzes = try JSONDecoder().decode([Quiz].self, from: data)
                DispatchQueue.main.async {
                    self.quizzes = quizzes
                    self.tableView.reloadData()
                }
            } catch {
                print("JSON decoding error: \(error)")
            }
        }

        task.resume()
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell", for: indexPath)
        let quiz = quizzes[indexPath.row]
        cell.textLabel?.text = quiz.title
        cell.detailTextLabel?.text = quiz.desc
        cell.imageView?.image = UIImage(systemName: "questionmark.circle")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowQuestion", sender: indexPath)
    }

    // MARK: - Navigation

    @objc func showSettings() {
        if let settingsVC = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            navigationController?.pushViewController(settingsVC, animated: true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowQuestion",
           let destination = segue.destination as? QuestionViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            destination.quiz = quizzes[indexPath.row]
        }
    }
}
