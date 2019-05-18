//
//  ViewController.swift
//  seaFood
//
//  Created by ARY@N on 06/01/19.
//  Copyright © 2019 ARYAN. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[.originalImage] as? UIImage {
            
         imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {fatalError("Could not convert in CIImage")}
            
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {fatalError("Loading coreML  Model failed")}
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else {fatalError("Unable to retrieve info")}
            
            if let firstResult = results.first {
                
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "HotDog!"
                    
                }else {
                    self.navigationItem.title = "Not HotDog!"
                }
            }
            
        }
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
}

