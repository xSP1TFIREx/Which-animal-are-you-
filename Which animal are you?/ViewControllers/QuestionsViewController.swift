import UIKit

class QuestionsViewController: UIViewController {
    
    //    MARK: - IBOutlets
    //    Лейбл с вопросами и шкала прогресса
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionProgressView: UIProgressView!
    
    //    Стак с кнопками
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet var singleButtons: [UIButton]!
    
    //    Стак со свичами
    @IBOutlet weak var switchStack: UIStackView!
    @IBOutlet var multipleLabels: [UILabel]!
    @IBOutlet var multipleSwitches: [UISwitch]!
    
    //    Стак со слайдером
    @IBOutlet weak var rangedStack: UIStackView!
    @IBOutlet var rangedLabels: [UILabel]!
    @IBOutlet weak var rangedSlider: UISlider! {
//        didSet - это метод/свойство или наблюдатель(до конца не разобрался с этим), который исполняет код при изменении какого-то свойства или установлении/появления у него значения
        didSet {
            let answerCount = Float(currentAnswers.count - 1)
            rangedSlider.maximumValue = answerCount
            rangedSlider.value = answerCount / 2
        }
    }
    
    //    MARK: - Private properties
    private let questions = Question.getQuestions()
    private var questionIndex = 0
    private var currentAnswers: [Answer] { questions[questionIndex].answers }
    private var answersChosen: [Answer] = []
    private var resultAnimalAnswers: [Character] = []



    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        
    }


    
//    MARK: - IBActions
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        guard let buttonIndex = singleButtons.firstIndex(of: sender) else {return}
        let currentAnswer = currentAnswers[buttonIndex]
        answersChosen.append(currentAnswer)

        goToNextQuestion()
    }
    
    @IBAction func multipleAnswerButtonPressed() {
        for (switches, answer) in zip(multipleSwitches, currentAnswers) {
            if switches.isOn {
                answersChosen.append(answer)
            }
        }

        goToNextQuestion()
    }
    
    
    @IBAction func rangedAnswerButtonPressed() {
        let index = lrintf(rangedSlider.value)
        answersChosen.append(currentAnswers[index])
        
        goToNextQuestion()
    }
}

//MARK: - Extention for QuestionViewController
extension QuestionsViewController {
    
    private func updateUI() {
        
        //    Скрыть стеки
        for stackView in [switchStack, rangedStack, buttonStack] {
            stackView?.isHidden = true
        }
        
        //    Получаем текущий вопрос
        let currentQuestion = questions[questionIndex]
        
        //    Отобразить актуальный вопрос в лейбле
        questionLabel.text = currentQuestion.title
        
        //    Подсчёт прогресса для шкалы
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        //    Установка прогресса для шкалы
        questionProgressView.setProgress(totalProgress, animated: true)
        
        //    Установка навигационного заголовка
        title = "Вопрос № \(questionIndex + 1) из \(questions.count)"
        
        //         Показывать стак для текущего вопроса
        showCurrentAnswers(for: currentQuestion.responsetype)
        
    }
    
        //    Функция для отображения текущих ответов
    private func showCurrentAnswers(for type: ResponseType) {
        switch type {
        case .single: showSingleStack(with: currentAnswers)
        case .multiple: showMultipleStack(with: currentAnswers)
        case .ranged: showRangedStack(with: currentAnswers)
        }
    }
    
        //    Функция для отображения стека с кнопками на экране
    private func showSingleStack(with answers: [Answer]) {
        buttonStack.isHidden = false
        
        for (button, answer) in zip(singleButtons, answers) {
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    //    Функция для отображения стека со свичами на экране
    private func showMultipleStack(with answers: [Answer]) {
        switchStack.isHidden = false
        
        for (label, answer) in zip(multipleLabels, answers){
            label.text = answer.title
            
        }
    }
    
//    Функция для отображения стека со слайдером на экране
    private func showRangedStack(with answers: [Answer]) {
        rangedStack.isHidden = false
        rangedLabels.first?.text = answers.first?.title
        rangedLabels.last?.text = answers.last?.title
        
    }
    
//    MARK: - Functions for calculations text for answer screeen
        
//    Функция для получения смайлика и его описания
    func getCalculatedDataForResult() -> (description: String, emoji: Character){
        
        for title in answersChosen {
            switch title.animal{
            case .dog: resultAnimalAnswers.append(Animal.dog.rawValue)
            case .cat: resultAnimalAnswers.append(Animal.cat.rawValue)
            case .rabbit: resultAnimalAnswers.append(Animal.rabbit.rawValue)
                case .turtle: resultAnimalAnswers.append(Animal.turtle.rawValue)}
        }
        
//        Функция, которая сортирует массив смайликов и оставляет там только самый часто встречаемый
        let mostFrequent = Dictionary(grouping: resultAnimalAnswers, by: {$0})
            .max(by: {$0.value.count < $1.value.count})?.value ?? []
        
//        Присваиваем переменной значение массива
        let test5 = mostFrequent[0]
        
//        Проверяем её значение
        switch test5 {
        case Character("🐶"):
            return (Animal.dog.definition, Animal.dog.rawValue)
        case Character("🐱"):
            return (Animal.cat.definition, Animal.cat.rawValue)
        case Character("🐰"):
            return (Animal.rabbit.definition, Animal.rabbit.rawValue)
        case Character("🐢"):
            return (Animal.turtle.definition, Animal.turtle.rawValue)
        default:
            return ("", "a")
        }

    }
    
}

//MARK: - Extension for navigation
extension QuestionsViewController {
    private func goToNextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
            return
        }
        
        performSegue(withIdentifier: "showResult", sender: nil)
    }

//    Подготовка данных для переноса
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultVC = segue.destination as? ResultViewController else {return}
        resultVC.animalIcon = "Вы - \(getCalculatedDataForResult().emoji)"
        resultVC.resultText = getCalculatedDataForResult().description
    }
    
}
