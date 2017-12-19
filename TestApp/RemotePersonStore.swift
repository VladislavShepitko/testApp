//
//  RemotePersonStore.swift
//  TestApp
//
//  Created by Vladyslav Shepitko on 12/18/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import Foundation
/*

"id": "59c92a0521f2d2a3670f6c18",
"isActive": true,
"balance": "$1,677.46",
"picture": "http://lorempixel.com/200/300/",
"age": 36,
"eyeColor": "green",
"name": "Latonya Guy",
"gender": "female",
"company": "ZENTIME",
"email": "latonyaguy@zentime.com",
"phone": "+1 (868) 509-2179",
"address": "518 Herkimer Street, Brandywine, Maine, 1178",
"about": "Anim laborum deserunt occaecat ipsum est Lorem laborum anim. Excepteur deserunt magna do quis laboris quis duis ea. Ea irure magna nostrud sit labore proident proident aliqua aliquip incididunt tempor consequat sint.\r\n",
"registered": "2014-08-14T11:30:40 -03:00",
"tags": [
"aliquip",
"adipisicing",
"dolore",
"nulla",
"occaecat",
"elit",
"esse"
],
"friends": [
{
"id": 0,
"name": "Nanette Mcdaniel"
},
{
"id": 1,
"name": "Velazquez Solomon"
},
{
"id": 2,
"name": "Rios Young"
}
],
"favoriteFruit": "apple"
}

*/
import Alamofire
import SwiftyJSON

public enum RemoteSourceResult{
    case Success(data:JSON)
    case Failure(ErrorType)
}
public enum ConnectionError:ErrorType {
    case InternetIsNotAvailable
}
class RemotePersonSource: NSObject {
    
    private let url = "http://www.mocky.io/v2/59c92a123f0000780183f72d"
 
    private var debug = false
    func fetchData(completion:(RemoteSourceResult)->Void) {
        if !debug {
            //check if internet is available
            let status = Reach().connectionStatus()
            switch status {
            case .Unknown, .Offline:
                completion(RemoteSourceResult.Failure(ConnectionError.InternetIsNotAvailable))
                return
            default:
                break
            }

            Alamofire.request(.GET, url).validate().responseJSON { responce in
                switch responce.result {
                case .Success(let value):
                    let jsonData = JSON(value)
                    completion(RemoteSourceResult.Success(data: jsonData)) 
                case .Failure(let error):
                    completion(RemoteSourceResult.Failure(error))
                }
            }
        }else{
            let json = self.loadFromBundle()
            completion(RemoteSourceResult.Success(data: json))
        }
    }
    private func loadFromBundle() -> JSON{
        let path = NSBundle.mainBundle().pathForResource("persons", ofType: "json")
        let data = NSData(contentsOfFile: path!)!
        let json = JSON(data: data)
        return json
    }
     
}