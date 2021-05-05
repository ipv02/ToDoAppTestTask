
import UIKit

class TaskViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Private properties
    private let calendarHelper = CalendarHelper()
    private let hours = Hours.getHours()
    private let dateConverter = DateConverter.shared
    private var task = Bundle.main.decode(Task.self, from: "TaskData.json")
    
    private var selectedDate = Date()
    private var totalSquares: [String] = []
    private var fetchDataTask: Task?
    private var theRightDay: String?
    private var tasks: [Task] = []
    
    //MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = #colorLiteral(red: 0.953376208, green: 0.953353822, blue: 0.953353822, alpha: 1)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setCellsView()
        setMonthView()
        
        tasks.append(task)
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let hour = hours[indexPath.row]
        
        guard let detailsVC = segue.destination as? DetailsViewController else { return }
        let timeStart = dateConverter.getTaskHour(unixCode: Double(task.dateStart) ?? 0.0)
        
        if hour == timeStart {
            detailsVC.detailsTask = task
        } else {
            detailsVC.tableViewHour = hour
        }
    }
    
    private func setCellsView() {
        
        let columnLayout = ColumnFlowLayout(cellsPerRow: 7)
        
        collectionView?.collectionViewLayout = columnLayout
        collectionView?.contentInsetAdjustmentBehavior = .always
    }
    
    private func setMonthView() {
        totalSquares.removeAll()
        let daysInMonth = calendarHelper.daysInMonth(date: selectedDate)
        let firstDayOfMonth = calendarHelper.firstOfMonth(date: selectedDate)
        let startingSpaces = calendarHelper.weekDay(date: firstDayOfMonth)
        
        var count = 1
        
        while(count <= 42) {
            if (count <= startingSpaces || count - startingSpaces > daysInMonth) {
                totalSquares.append("")
            } else {
                totalSquares.append(String(count - startingSpaces))
            }
            count += 1
        }
        
        monthLabel.text = calendarHelper.monthString(date: selectedDate) + " " + calendarHelper.yearsString(date: selectedDate)
        collectionView.reloadData()
    }
    
    //MARK: - IBAction
    @IBAction func previousMonthButton(_ sender: Any) {
        selectedDate = calendarHelper.minusMonth(date: selectedDate)
        setMonthView()
    }
    
    @IBAction func nextMonthButton(_ sender: Any) {
        selectedDate = calendarHelper.plusMonth(date: selectedDate)
        setMonthView()
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let newTaskVC = NewTaskViewController()
        let newTaskNavController = UINavigationController(rootViewController: newTaskVC)
        
        newTaskVC.delegate = self
        
        present(newTaskNavController, animated: true)
    }
}

//MARK: - UICollectionView DataSource & Delegate
extension TaskViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! CalendarCollectionViewCell
        
        cell.dayOfMonth.text = totalSquares[indexPath.item]
        
        return cell
    }
}

extension TaskViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath)
        selectedCell?.contentView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        let dateDay = totalSquares[indexPath.item]
        
        let dayTask = dateConverter.getTaskDay(unixCode: Double(task.dateStart) ?? 0.0)
        
        if dateDay == dayTask {
            theRightDay = dateDay
            tableView.reloadData()
        } else {
            print("Empty")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cellToDeselect = collectionView.cellForItem(at: indexPath)
        cellToDeselect?.contentView.backgroundColor = UIColor.clear
    }
}

//MARK: - UITableView DataSource & Delegate
extension TaskViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        hours.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        
        let hour = hours[indexPath.row]
        let timeStart = dateConverter.getTaskHour(unixCode: Double(tasks[0].dateStart) ?? 0.0)
        let timeFinish = dateConverter.getTaskHour(unixCode: Double(tasks[0].dateFinish ?? "") ?? 0.0)
        let dayTask = dateConverter.getTaskDay(unixCode: Double(tasks[0].dateStart) ?? 0.0)
        
        if theRightDay == dayTask && hour == timeStart {
            cell.textLabel?.text = tasks[0].name
            cell.detailTextLabel?.text = timeStart + "-" + timeFinish
        } else {
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = hour
        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

extension TaskViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - NewTaskProtocol
extension TaskViewController: NewTaskDelegateProtocol {
    
    func saveTask(_ task: Task) {
        tasks.append(task)
        tableView.reloadData()
    }
}
