//
//  AdItem.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/05/09.
//

public struct AdItem: Decodable {
    public let id: Int
    public let clientName: String
    public let imageUrlStr: String
    public let targetUrlStr: String
    public let imageDescription: String

    public init(id: Int, clientName: String, imageUrlStr: String, targetUrlStr: String, imageDescription: String) {
        self.id = id
        self.clientName = clientName
        self.imageUrlStr = imageUrlStr
        self.targetUrlStr = targetUrlStr
        self.imageDescription = imageDescription
    }

    public enum ParsingError: Error {
        case invalidData
    }

    public init(dictionary: [String: Any]) throws {
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
