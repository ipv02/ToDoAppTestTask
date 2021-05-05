
import UIKit

final class DetailsViewController: UIViewController {
    
    @IBOutlet weak var nameTaskLabel: UILabel!
    @IBOutlet weak var dateTaskLabel: UILabel!
    @IBOutlet weak var descriptionTaskLabel: UILabel!
    
    var detailsTask: Task?
    var tableViewHour: String?
    
    private let dateConverter = DateConverter.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDetails()
    }
    
    private func fetchDetails() {
        nameTaskLabel.text = detailsTask?.name
        
        if detailsTask != nil {
            dateTaskLabel.text = dateConverter.getTaskHour(unixCode: Double(detailsTask?.dateStart ?? "") ?? 0.0)
        } else {
            dateTaskLabel.text = "No tasks for this time: \(tableViewHour ?? "")"
        }
        
        descriptionTaskLabel.text = detailsTask?.description
    }
}
