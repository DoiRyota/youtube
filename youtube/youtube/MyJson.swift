
import Foundation
func getJson() throws -> Data?{
    guard let path = Bundle.main.path(forResource:"sampleData",ofType:"json")else {return nil}
    let url=URL(fileURLWithPath:path)
    return try Data(contentsOf:url)
}

struct MyJson:Codable{
    let className:String?
    let students:[Student]?
}
struct Student:Codable{
    let name:String?
    let number:Int?
    let subjects:[subject]?
}
struct subject:Codable{
    let name:String?
    let score:Int?
}













