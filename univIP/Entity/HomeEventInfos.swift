//
//  HomeEventInfos.swift
//  Entity
//
//  Created by Akihiro Matsuyama on 2023/08/29.
//

struct HomeEventInfos: Decodable {
    let popupItems: [PopupItem]
    let buttonItems: [ButtonItem]
    
    init(popupItems: [PopupItem], buttonItems: [ButtonItem]) {
        self.popupItems = popupItems
        self.buttonItems = buttonItems
    }
    
    struct PopupItem: Decodable {
        let id: Int
        let clientName: String
        let titleName: String
        let description: String
        
        init(id: Int, clientName: String, titleName: String, description: String) {
            self.id = id
            self.clientName = clientName
            self.titleName = titleName
            self.description = description
        }
        
        enum ParsingError: Error {
            case invalidData
        }
        
        init(dictionary: [String: Any]) throws {
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
    
    
    struct ButtonItem: Decodable {
        let id: Int
        let titleName: String
        let targetUrlStr: String
        
        init(id: Int, titleName: String, targetUrlStr: String) {
            self.id = id
            self.titleName = titleName
            self.targetUrlStr = targetUrlStr
        }
        
        enum ParsingError: Error {
            case invalidData
        }
        
        init(dictionary: [String: Any]) throws {
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
