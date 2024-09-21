//
//  AdItem.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/05/09.
//

struct AdItem: Decodable {
    let id: Int
    let clientName: String
    let imageUrlStr: String
    let targetUrlStr: String
    let imageDescription: String
    
    init(id: Int, clientName: String, imageUrlStr: String, targetUrlStr: String, imageDescription: String) {
        self.id = id
        self.clientName = clientName
        self.imageUrlStr = imageUrlStr
        self.targetUrlStr = targetUrlStr
        self.imageDescription = imageDescription
    }
    
    enum ParsingError: Error {
        case invalidData
    }
    
    init(dictionary: [String: Any]) throws {
        guard let id = dictionary["id"] as? Int,
              let clientName = dictionary["clientName"] as? String,
              let imageUrlStr = dictionary["imageUrlStr"] as? String,
              let targetUrlStr = dictionary["targetUrlStr"] as? String,
              let imageDescription = dictionary["imageDescription"] as? String else {
            throw ParsingError.invalidData
        }
        self.id = id
        self.clientName = clientName
        self.imageUrlStr = imageUrlStr
        self.targetUrlStr = targetUrlStr
        self.imageDescription = imageDescription
    }
}
