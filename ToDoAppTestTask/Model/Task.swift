
import Foundation

struct Task: Decodable {
    let id: Int?
    var dateStart: String
    let dateFinish: String?
    var name: String
    var description: String
}
