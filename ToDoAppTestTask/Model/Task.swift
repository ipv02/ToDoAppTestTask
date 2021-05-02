
import Foundation

struct Task: Decodable {
    let id: Int
    let dateStart: String
    let dateFinish: String
    let name: String
    let description: String
}
