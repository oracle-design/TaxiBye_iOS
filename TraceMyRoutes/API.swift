//
//  API.swift
//  TraceMyRoutes
//
//  Created by sean on 2017/1/24.
//  Copyright © 2017年 oddesign. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import iOS_KML_Framework


class API {

    let hostURL = "http://taxibye.oddesign.expert"

    var baseURL: String {
        return "\(hostURL)/api"
    }
    var termURL: String {
        return "\(hostURL)/term"
    }
    var policyURL: String {
        return "\(hostURL)/policy"
    }

    let version = "/v1"

    var headers: [String: String] {
        return [
            "Authorization": MyUser.shared.authToken
        ]
    }



}
extension API {
    // MARK: =================>

    static func authenticate(completion: @escaping (()-> Void), fail: @escaping ((_ errorMessage: String) -> Void)) {

        let url = "http://taxibye.oddesign.expert/api/v1/authenticate"

        let header: [String: String] = [
            "ApiKey": "kimura",
            "DeviceID": "kimura"
        ]

        let body: [String: String] = [
            "email": "kimura",
            "password": "kimura"
        ]
        
        print("function = \(#function)") //kimuranow
        print("url = \(url)") //kimuranow
        print("header = \(header.description)") //kimuranow
        print("body = \(body.description)") //kimuranow


        Alamofire.request( url, method: .post, parameters: body, encoding: URLEncoding.default, headers: header)
            .responseJSON { response in
                guard response.result.error == nil else {
                    fail(response.result.error.debugDescription)
                    return
                }

                if let value: AnyObject = response.result.value as AnyObject? {
                    print("value = \(value)") //kimuranow
                    MyUser.shared.authToken = JSON(value)["data", "authToken"].stringValue
                    print("authToken = \(MyUser.shared.authToken)") //kimuranow
                }
        }
        
    }
    static func fetchRankingList(completion: @escaping (()-> Void), fail: @escaping ((_ errorMessage: String) -> Void)) {

//        let url = "http://taxibye.oddesign.expert/api/v1/taxis/ranking?number="
        let url = "http://taxibye.oddesign.expert/api/v1/taxis/ranking"

//        printParams(andURL: url, andFunctionName: #function)


        print("function = \(#function)") //kimuranow
        print("url = \(url)") //kimuranow
//        print("header = \(header.description)") //kimuranow
//        print("body = \(body.description)") //kimuranow
        
        Alamofire.request( url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                guard response.result.error == nil else {
                    fail(response.result.error.debugDescription)
                    return
                }

                if let value: AnyObject = response.result.value as AnyObject? {

                    ResponseDecorator.fetchRankingList(JSON(value)) {
                        completion()
                    }
                }
        }
    }

    static func queryTaxi(by licensePlateNumber: String, completion: (()-> Void), fail: @escaping ((_ errorMessage: String) -> Void)) {

        var url = ""
        if let carPlateNumberByURLEncoded = licensePlateNumber.stringByAddingPercentEncodingForRFC3986() {
            url = "http://taxibye.oddesign.expert/api/v1/taxis/\(carPlateNumberByURLEncoded)/query"
        }
        
        Alamofire.request( url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                guard response.result.error == nil else {
                    fail(response.result.error.debugDescription)
                    return
                }

                if let value: AnyObject = response.result.value as AnyObject? {
                    print("value = \(value)") //kimuranow
//                    completion()
                }
        }
        
    }


    static func createTripRecord(completion: (()-> Void), fail: @escaping ((_ errorMessage: String) -> Void)) {

        var url = ""
        if let carPlateNumberByURLEncoded = TraceRouteMachine.shared.carPlateNumber.stringByAddingPercentEncodingForRFC3986() {
            url = "http://taxibye.oddesign.expert/api/v1/taxis/\(carPlateNumberByURLEncoded)/trips"
        }

        let header = [
//            "Authorization": "",
            "DeviceID": UIDevice.current.identifierForVendor!.uuidString
        ]
        let body = [
            "startedAt": TraceRouteMachine.shared.traceStartTime,
            "endedAt": TraceRouteMachine.shared.traceEndTime,
            "route": GPXMachine.shared.gpxString,
            "ratingAttributes": [
                "score": TraceRouteMachine.shared.ratingNumber,
                "message": TraceRouteMachine.shared.comment,
                "tripFeelingId": TraceRouteMachine.shared.traceFeelingID
            ]
        ] as [String : Any]

        print("url = \(url)") //kimuranow
        print("header = \(header.description)") //kimuranow
        print("body = \(body.description)") //kimuranow
//        printParams(
//            withParameter: body.description,
//            andHeader: "",
//            andURL: url,
//            andFunctionName: #function
//        )

        return

//        Alamofire.request( url, method: .post, parameters: body, encoding: URLEncoding.default, headers: header)
//            .responseJSON { response in
//
//                guard response.result.error == nil else {
//                    fail(response.result.error.debugDescription)
//                    return
//                }
//
//                if let value: AnyObject = response.result.value as AnyObject? {
//                    print("value = \(value)") //kimuranow
//                    //                    completion()
//                }
//        }

    }
    
//    func printParams(withParameter params: String, andHeader headers: String = "", andURL url: String, andFunctionName functionName: String) {
//        
//        guard AppConfig.isShowAPILog else {
//            return
//        }
//        
//        var content = "\n[API][\(functionName)] Parameters"
//        content += "\n - parameters = \(params != "" ? params : "no value")"
//        content += "\n - headers    = \(headers != "" ? headers : "no value")"
//        content += "\n - url        = \(url)"
//        
//        print(content)
//    }
}

extension API {

    enum APIMethod {
        case fetchRankingList
        case queryTaxiByLicensePlateNumber
        case createTripRecord
    }

    func getEndPoint(with method: APIMethod) -> String {

        var endPoint = ""

        switch method {

        case .fetchRankingList:
            endPoint = "/taxis/ranking?number="
            break
        case .queryTaxiByLicensePlateNumber:
            endPoint = "/taxis/license_plate_number"
            break
        case .createTripRecord:
            endPoint = "/taxis/license_plate_number/trips"
            break
        }
        
        return baseURL + version + endPoint
        
    }
    
    func getShareItemPhotoURL(_ hash: String) -> String {
        
        return hostURL + "/item_photos/" + hash
        
    }
}
extension API {
    
    enum APILogType: String {
        case start = "start"
        case params = "parameters"
        case header = "header"
        case url = "url"
    }
    
    
    func printResponse(withContent response: String, andFunctionName functionName: String) {
        
        guard AppConfig.isShowAPILog else {
            return
        }
        
        let content = "\n[API][\(functionName)] Response \n \(response)"
        
        print(content)
        
    }
    
    
}


struct APIActionResult {
    var errorMessage = ""
    var isSuccess = false
}



extension String {

    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }


}
