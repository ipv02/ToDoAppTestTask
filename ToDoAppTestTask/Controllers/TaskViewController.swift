
import UIKit

class TaskViewController: UIViewController {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    private let calendarHelper = CalendarHelper()
    private let hours = Hours.getHours()
    private let dateConverter = DateConverter.shared
    private let task = Bundle.main.decode(Task.self, from: "TaskData.json")
        
    private var selectedDate = Date()
    private var totalSquares: [String] = []
    private var fetchDataTask: Task?
    private var theRightDay: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        //collectionView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setCellsView()
        setMonthView()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let hour = hours[indexPath.row]
        
        guard let detailsVC = segue.destination as? DetailsViewController else { return }
        let timeStart = dateConverter.getTaskHour(unixCode: Double(task.dateStart) ?? 0.0)
        
        if hour == timeStart {
            detailsVC.detailsTask = fetchDataTask
        } else {
            detailsVC.tableViewHour = hour
        }
    }
    
    private func setCellsView() {
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.height - 2) / 8
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        flowLayout.itemSize = CGSize(width: width, height: height)
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
    
    
    @IBAction func previousMonthButton(_ sender: Any) {
        selectedDate = calendarHelper.minusMonth(date: selectedDate)
        setMonthView()
    }
    
    @IBAction func nextMonthButton(_ sender: Any) {
        selectedDate = calendarHelper.plusMonth(date: selectedDate)
        setMonthView()
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
            fetchDataTask = task
            tableView.reloadData()
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
        let timeStart = dateConverter.getTaskHour(unixCode: Double(task.dateStart) ?? 0.0)
        let timeFinish = dateConverter.getTaskHour(unixCode: Double(task.dateFinish) ?? 0.0)
        let dayTask = dateConverter.getTaskDay(unixCode: Double(task.dateStart) ?? 0.0)
        
        if theRightDay == dayTask && hour == timeStart {
            cell.textLabel?.text = fetchDataTask?.name
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
//        let hour = hours[indexPath.row]
//        performSegue(withIdentifier: "showDetails", sender: hour)
        
        
    }
}
