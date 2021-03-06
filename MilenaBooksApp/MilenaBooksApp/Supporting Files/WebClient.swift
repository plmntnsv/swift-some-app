//
//  ApiRequester.swift
//  MilenaBooksApp
//
//  Created by Plamen on 5.12.18.
//  Copyright © 2018 Plamen. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

final class WebClient {
//    private var baseUrl: String
//    
//    init(baseUrl: String) {
//        self.baseUrl = baseUrl
//    }
    
    func getAllBooks(completion: @escaping (_ resultArray: [Book]?) -> () ) {
        Alamofire.request(ApiEndPoints.Books.getAll.fullUrl)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseArray { (response: DataResponse<[Book]>) in
                let booksArray = response.result.value
                
                if let booksArray = booksArray {
                    completion(booksArray)
                }
        }
    }
    
    func getBook(url: String, completion: @escaping (_ result: Book?) -> () ) {
        Alamofire.request(url)
            .responseObject {(response: DataResponse<Book>) in
                let bookResponse = response.result.value
                completion(bookResponse)
        }
    }
    
    func deleteBook(url: String, completion: @escaping (_ error: Error?) -> () ) {
        Alamofire.request(url, method: .delete)
            .responseObject { (response: DataResponse<Book>) in
                
                if response.error == nil {
                    completion(nil)
                } else {
                    completion(response.error)
                }
        }
    }
    
    func addOrUpdateBook(_ book: Book, to urlString: String, with method: HTTPMethod, completion: @escaping (_ result: Book?, _ error: Error?) -> ()) {
        Alamofire.request(urlString,
                          method: method,
                          parameters: book.toJSON(),
                          encoding: JSONEncoding.default)
            .responseObject { (response: DataResponse<Book>) in
                switch response.result {
                case .success:
                    let resultBook = response.result.value
                    completion(resultBook, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    func uploadCoverImage(_ image: UIImage, to url: String, completion: @escaping(_ url: String?, _ error: Error?) -> ()) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer 4becd99646668cba54a50dd249ff6304e7a2440b"
        ]
        
        // Client-ID 8b4ba36502b847a
        
        Alamofire.upload(multipartFormData: { multipart in
            multipart.append(image.pngData()!, withName: "image")
        }, to: url, method: .post, headers: headers) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseObject(keyPath: "data") { (response: DataResponse<ImgurCoverImage>) in
                    switch response.result {
                    case .success:
                        completion(response.result.value?.link!, nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
                }
            case .failure(let encodingError):
                print("multipart upload encodingError: \(encodingError)")
            }
        }
    }
}
