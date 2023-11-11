//
//  Network.swift
//  Memoji
//
//  Created by Luiz Vasconcellos on 05/11/23.
//

import Foundation
import Alamofire

protocol NetworkDelegate {
    func baseRequest<T: Decodable>(request: NetworkRequest, type: T.Type, completion: @escaping (T?, String?) -> ())
}

final class Network: NetworkDelegate {
    
    func baseRequest<T: Decodable>(request: NetworkRequest, type: T.Type, completion: @escaping (T?, String?) -> Void) {
        
        let request = convertToAFRequest(request: request)
        AF.request(request)
            .responseDecodable(of: type) { response in
                switch response.result {
                case .success:
                    guard let response = response.value else { return }
                    completion(response, nil)
                case .failure:
                    completion(nil, response.error?.errorDescription)
                }
            }
    }
    
    private func convertToAFRequest(request: NetworkRequest) -> URLRequest {
        
        var afRequest = URLRequest(url: request.url as URL)
        afRequest.httpMethod = request.method.rawValue
        afRequest.headers = HTTPHeaders(request.headers ?? [:])
        if let parameters = request.parameters {
            let data = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions.prettyPrinted)
            afRequest.httpBody = data
        } else if let bodyParameters = request.bodyParameters {
            afRequest.httpBody = bodyParameters
        }
        
        return afRequest
    }
}
