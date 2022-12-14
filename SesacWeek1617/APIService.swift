//
//  APIService.swift
//  SesacWeek1617
//
//  Created by HeecheolYoon on 2022/10/20.
//

import Foundation
import Alamofire

class APIService {
    
    private init() {}
    
    static func searchPhoto(query: String, completion: @escaping (SearchPhoto?, Int?, Error?) -> Void){
        let url = "\(APIKey.searchURL)\(query)"
        let header: HTTPHeaders = ["Authorization": APIKey.authorization]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: SearchPhoto.self) { response in
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let value):
                print(value)
                completion(value, statusCode, nil)
            case .failure(let error):
                print(error)
                completion(nil, statusCode, error)
            }
        }
    }
    
    static func requestRandomPhoto(completion: @escaping (RandomPhoto?) -> Void) {
        let url = APIKey.randomPhotoURL
        let header: HTTPHeaders = ["Authorization": APIKey.authorization]
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: RandomPhoto.self) { response in
            let statusCode = response.response?.statusCode
            
            switch response.result {
            case .success(let value):
                print(value)
                completion(value)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
}
