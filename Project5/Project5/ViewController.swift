
import UIKit

class ViewController: UITableViewController {
  private var allWords = [String]()
  private var usedWords = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(startGame))
    if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
      if let startWords = try? String(contentsOf: startWordsURL) {
        allWords = startWords.components(separatedBy: "\n")
      }
    }
    
    if allWords.isEmpty {
      allWords = ["silkworm"]
    }
    
    startGame()
  }
  
  @objc private func promptForAnswer() {
    let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
    ac.addTextField()
    
    let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
      guard let answer = ac?.textFields?[0].text else { return }
      self?.submit(answer)
    }
    
    ac.addAction(submitAction)
    present(ac, animated: true)
  }
  
  @objc private func startGame() {
    title = allWords.randomElement()
    usedWords.removeAll(keepingCapacity: true)
    tableView.reloadData()
  }
  
  private func submit(_ answer: String) {
    let lowerAnswer = answer.lowercased()
    
    if isPossible(word: lowerAnswer) {
      if isOriginal(word: lowerAnswer) {
        if isReal(word: lowerAnswer) {
          usedWords.insert(lowerAnswer, at: 0)
          
          let indexPath = IndexPath(row: 0, section: 0)
          tableView.insertRows(at: [indexPath], with: .automatic)
          return
        } else {
            showAlert(withTitle: "Word not recognised", andMessage: "You can't just make them up, you know!")
        }
      } else {
          showAlert(withTitle: "Word used already", andMessage: "Be more original!")
      }
    } else {
        guard let title = title?.lowercased() else { return }
        showAlert(withTitle: "Word not possible", andMessage: "You can't spell that word from \(title)")
    }
  }
  
  private func isPossible(word: String) -> Bool {
    guard var tempWord = title?.lowercased() else { return false }
    
    for letter in word {
      if let position = tempWord.firstIndex(of: letter) {
        tempWord.remove(at: position)
      } else {
        return false
      }
    }
    return true
  }

  private func isOriginal(word: String) -> Bool {
    !usedWords.contains(word)
  }

  private func isReal(word: String) -> Bool {
    if !word.isLongEnough { return false }
    if word.matches(otherWord: title) { return false }
    
    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
    
    return misspelledRange.location == NSNotFound
  }
  
  private func showAlert(withTitle errorTitle: String, andMessage errorMessage: String) {
    let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Ok", style: .default))
    present(ac, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    usedWords.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
    cell.textLabel?.text = usedWords[indexPath.row]
    return cell
  }
}

fileprivate extension String {
  var isLongEnough: Bool {
    utf16.count >= 3
  }
  
  func matches(otherWord: String?) -> Bool {
    self.lowercased() == otherWord?.lowercased()
  }
}

