//
//  HomeEventInfos.swift
//  Entity
//
//  Created by Akihiro Matsuyama on 2023/08/29.
//

public struct HomeEventInfos: Decodable {
    public let popupItems: [PopupItem]
    public let buttonItems: [ButtonItem]

    public init(popupItems: [PopupItem], buttonItems: [ButtonItem]) {
        self.popupItems = popupItems
        self.buttonItems = buttonItems
    }

    public struct PopupItem: Decodable {
        public let id: Int
        public let clientName: String
        public let titleName: String
        public let description: String

        public init(id: Int, clientName: String, titleName: String, description: String) {
            self.id = id
            self.clientName = clientName
            self.titleName = titleName
            self.description = description
        }

        public enum ParsingError: Error {
            case invalidData
        }

        public init(dictionary: [String: Any]) throws {
            guard let id = dictionary["id"] as? Int,
                  let clientName = dictionary["clientName"] as? String,
                  let titleName = dictionary["titleName"] as? String,
                  let description = dictionary["description"] as? String else {
                throw ParsingError.invalidData
            }
            self.id = id
            self.clientName = clientName
            self.titleName = titleName
            self.description = description
        }
    }


    public struct ButtonItem: Decodable {
        public let id: Int
        public let titleName: String
        public let targetUrlStr: String

        public init(id: Int, titleName: String, targetUrlStr: String) {
            self.id = id
            self.titleName = titleName
            self.targetUrlStr = targetUrlStr
        }

        public enum ParsingError: Error {
            case invalidData
        }

        public init(dictionary: [String: Any]) throws {
            guard let id = dictionary["id"] as? Int,
                  let titleName = dictionary["titleName"] as? String,
                  let targetUrlStr = dictionary["targetUrlStr"] as? String else {
                throw ParsingError.invalidData
            }
            self.id = id
            self.titleName = titleName
            self.targetUrlStr = targetUrlStr
        }
    }

}
