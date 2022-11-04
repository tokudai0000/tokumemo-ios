//
//  WeatherAPI.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2022/10/14.
//

import Foundation

/*
 {
 "type": "",
 "features": [
 {
 "type": "",
 "properties": {},  　　//それぞれ違う
 "id": "",  　　　　　　//Int型やString型、存在しない場合がある
 "geometry": {}  　　　//一次元配列や三次元配列の場合がある
 },
 ],
 "crs": {
 "type": "",
 "properties": {
 "href": "",
 "type": ""
 }
 }
 }
 */
//Geometryのcoordinatesが一次元配列の時用
class TopNest1: Codable {
    var type:String?
    var features:[Feature] = []
    
    class Feature: Codable{
        var type: String?
        var properties: Properties?
        var geometry: Geometry?
        //var id: Int型とString型が混在している
        
        class Properties: Codable{
            //地図(地震計)
            var floor: Int?
        }
        class Geometry: Codable{
            var type: String?  //Point
            var coordinates: [Double] = []  //一次配列
        }
    }
}

/*
 {
     "coord": {
         "lon": 134.5616,
         "lat": 34.0779
     },
     "weather": [
         {
             "id": 801,
             "main": "Clouds",
             "description": "薄い雲",
             "icon": "02d"
         }
     ],
 */

struct Coord: Codable{
    var lon: Int?  //Point
    var lat: Int?  //一次配列
}

class TopNest: Codable {
    var coord: Coord!
    
    var weather:[Weather] = []
    
    class Weather:Codable {
        let id: Int?
        let main: String?
        let description: String?
        let icon: String?
    }
    
//    let base: String?
    
//    var main: Main?
//
//    class Main:Codable {
//        let temp: Int?
//        let feels_like: Int?
//        let temp_min: Int?
//        let temp_max: Int?
//        let pressure: Int?
//        let humidity: Int?
//    }
}


//struct Weathers:Codable {
//    let weather: [Weather]
//}
//
//struct Weather:Codable {
//    let id: String
//    let main: String
//    let description: String
//    let icon: String
//}


//struct feels_like:
/*
 {
 "coord": {
 "lon": 134.5616,
 "lat": 34.0779
 },
 "weather": [
 {
 "id": 801,
 "main": "Clouds",
 "description": "薄い雲",
 "icon": "02d"
 }
 ],
 "base": "stations",
 "main": {
 "temp": 21.97,
 "feels_like": 21.79,
 "temp_min": 21.97,
 "temp_max": 22.45,
 "pressure": 1013,
 "humidity": 60
 },
 "visibility": 10000,
 "wind": {
 "speed": 2.57,
 "deg": 60
 },
 "clouds": {
 "all": 20
 },
 "dt": 1667456496,
 "sys": {
 "type": 1,
 "id": 8027,
 "country": "JP",
 "sunrise": 1667424156,
 "sunset": 1667462876
 },
 "timezone": 32400,
 "id": 1857689,
 "name": "万代町",
 "cod": 200
 }
 */

//class TopNest: Codable {
//    class area: Codable{
//        var weatherCodes: [String]
//        var weathers: [String]
//    }
//    class tempAverage: Codable{
//        class areas: Codable{
//            var min: String
//            var max: String
//        }
//    }
//}


