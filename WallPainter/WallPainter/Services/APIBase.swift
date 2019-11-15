//
//  APIBase.swift
//  WallPainter
//
//  Created by User on 15/11/19.
//  Copyright © 2019 factweavers. All rights reserved.
//

import Foundation
import Alamofire
import AFNetworking


class apiBase {
    
    func upload(url: URL,imageToUploadURL: Data) {
        
    Alamofire.upload(
            multipartFormData: { multipartFormData in
                // On the PHP side you can retrive the image using $_FILES["image"]["tmp_name"]
               
                multipartFormData.append(imageToUploadURL, withName: "image")
//                for (key, val) in parameters {
//                    multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
//                }
        },
             to: url,
             encodingCompletion: { encodingResult in
               switch encodingResult {
                 case .success(let upload, _, _):
                     upload.responseJSON { response in
                         if let jsonResponse = response.result.value as? [String: Any] {
                             print(jsonResponse)
                       }
                    }
            case .failure(let encodingError):
                print(encodingError)
                }
        }
        )
    }
    func filePost(imageUploadUrl: String,imageFile: AnyObject,mimeType: String,success: @escaping () -> Void,
                  failure: @escaping (Error) -> Void){
        let file = imageFile
        var data: Data = Data()
        // TODO : add more mime types
        switch mimeType {
        case "image/jpeg", "image/heic":
            data = (file as? UIImage)?.jpegData(compressionQuality: 0.5) ?? Data()
        case "image/png":
            data = (file as? UIImage)?.pngData() ?? Data()
        case "video/quicktime":
            data = (file as? Data)!
        case "application/pdf":
            data = (file as? Data)!
        default:
            return
        }
        let requestURL = URL(string: imageUploadUrl)
        let client = AFHTTPSessionManager(baseURL: requestURL)
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "PUT"
        request.httpBody = data
        request.setValue(mimeType, forHTTPHeaderField: "Content-Type")
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
        request.setValue("public-read", forHTTPHeaderField: "x-amz-acl")
        let task = client.dataTask(with: request,
                                   uploadProgress: nil,
                                   downloadProgress: nil,
                                   completionHandler: { (response, _, error) in
                                    if error != nil {
                                        failure(error!)
                                    }
                                    print(response)
                                    success()
        })
        task.resume();
    }
}
