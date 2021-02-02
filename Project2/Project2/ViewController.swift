import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var button1: UIButton!
  @IBOutlet weak var button2: UIButton!
  @IBOutlet weak var button3: UIButton!
  private var countries = [String]()
  private var score = 0
  private var tries = 0
  private var correctAnswer = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    countries.shuffle()
    buttonStyles()
    askQuestion(action: nil)
  }
  
  private func buttonStyles() {
    style(button1)
    style(button2)
    style(button3)
  }
  
  private func style(_ button: UIButton) {
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor.lightGray.cgColor
  }
  
  private func askQuestion(action: UIAlertAction!) {
    buttonImages()
    nextCorrectAnswer()
    appendToTitle(text: solution())
  }
  
  private func buttonImages() {
    setImageFor(button1, withCountryIndex: 0)
    setImageFor(button2, withCountryIndex: 1)
    setImageFor(button3, withCountryIndex: 2)
  }
  
  private func setImageFor(_ button: UIButton, withCountryIndex index: Int) {
    button.setImage(UIImage(named: countries[index]), for: .normal)
  }
  
  private func nextCorrectAnswer() {
    correctAnswer = Int.random(in: 0...2)
  }
  
  private func appendToTitle(text: String) {
    title = text + " - Score: \(score)"
  }
  
  private func solution() -> String {
    countries[correctAnswer].uppercased()
  }
  
  @IBAction func buttonTapped(_ sender: UIButton) {
    incrementTries()
    let outcome = correctButtonMatches(sender) ? answer() : wrongAnswer()
    appendToTitle(text: outcome.rawValue)
    if shouldEnd() {
      end()
      return
    }
    reportTry(outcome)
  }
  
  private func incrementTries() {
    tries += 1
  }
  
  private func correctButtonMatches(_ sender: UIButton) -> Bool {
    sender.tag == correctAnswer
  }
  
  private func answer() -> Outcome {
    incrementScore()
    return .correct
  }
  
  private func incrementScore() {
    score += 1
  }
  
  private func wrongAnswer() -> Outcome {
    decrementScore()
    return .incorrect
  }
  
  private func decrementScore() {
    score = max(0, score - 1)
  }
  
  private func shouldEnd() -> Bool {
    tries >= 10
  }
  
  private func end() {
    let ac = UIAlertController(title: "Game over", message: "Your final score is \(score).", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: quit ))
    present(ac, animated: true)
  }
  
  private func quit(_ action: UIAlertAction) {
    exit(1)
  }
  
  private func reportTry(_ outcome: Outcome) {
    let ac = UIAlertController(title: text(for: outcome), message: "Your score is \(score).", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion ))
    present(ac, animated: true)
  }
  
  private func text(for outcome: Outcome) -> String {
    return outcome == .correct ? outcome.rawValue : wrongAnswerText()
  }
  
  private func wrongAnswerText() -> String {
    "Wrong, the correct answer is \(solution())"
  }
}

private enum Outcome: String {
  case correct = "Correct"
  case incorrect = "Incorrect"
}

