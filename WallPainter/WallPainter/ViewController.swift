//
//  ViewController.swift
//  WallPainter
//
//  Created by User on 15/11/19.
//  Copyright © 2019 factweavers. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {
    
    var postFile: AnyObject?
    
    var imagePicker = UIImagePickerController()
    
    var mimeType: String?
    
    var imageUploadService = apiBase()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func captureButtonPressed(_ sender: Any) {
        
        onCaptureImageButtonPressed()
    }
    func onCaptureImageButtonPressed() {
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker,animated: true)
        
    }
    
    func uploadImage() {
        
        do{
            
           try imageUploadService.filePost(imageUploadUrl: "http://139.59.79.192:5000/upload",
                                        imageFile: postFile!,
                                        mimeType: mimeType!,
                                        success: {
                                            print("success")
            },
                                        failure: {(error) in
                                            print("error")
            })

        }catch{
            print("error in uploading image")
        }
            }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(
        _ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    //Picking image and its info
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController
        .InfoKey: Any]) {
        
        
            // if image is selected
            if let image = info[UIImagePickerController
                .InfoKey.originalImage] as? UIImage {
                
                postFile = image
                let refUrl = info[UIImagePickerController
                    .InfoKey.imageURL] as? URL
                let fileName =
                    refUrl?.absoluteURL.lastPathComponent ?? ""
                if let url = refUrl {
                    
                  
                        
                         mimeType =
                            mimeTypeForPath(path: url)
               
                }
                uploadImage()
                // fetching image upload url
                picker.dismiss(animated: true, completion: nil)
            }
            
            }
    
    func mimeTypeForPath(path: URL) -> String {
        var mimeType = String()
        // let url = NSURL(fileURLWithPath: path)
        let pathExtension = path.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                           pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                mimeType = mimetype as String
                return mimeType
            }
        }
        return "application/octet-stream"
    }

}
