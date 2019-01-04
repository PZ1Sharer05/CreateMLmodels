//
//  ViewController.swift
//  SeeFood
//
//  Created by Jeff Sharer on 04/01/19.
//  Copyright © 2019 Sharer05. All rights reserved.
//


/* REMEMBER
 Whenever making a ML Image Recognizer App, always go to info.plist file and add Privacy - Camera Usage Description
 This prevents the app from crashing
 However, this template already includes the property so you don't have to worry of adding it again
 */
import UIKit //Basic iOS App Framework

import CoreML //CoreML Access

import Vision //Camera Access

//Class Declaration here
class ViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    
    
    //MARK: When View Loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .camera //Enables camera feature but if you want the user to pick from the photo album instead, then use .photoLibrary
        
        imagePicker.allowsEditing = false //Does not allow photo editing in app, use this when you want the app to be more powerful
        
        }
    
    
    
    //UIImageView IBOutlet
    
    @IBOutlet weak var imageView: UIImageView!
    
    // image picker object
    
    let imagePicker = UIImagePickerController()
    
    //Image Picker Controller Function
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could Not Convert to CIImage")
            }
            
            
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
    //Function that detects what image the camera has took
    
    /*NOTE: I used Inceptionv3 for this template but you can change it to what model you wish to use
     just simply remove the word Inceptionv3 but do not remove the parantheses
     This template detects hotdogs or not hotdogs but that could be changed
 */
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, Error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model Failed to Process Image")
            }
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "hotdog"
                }
               
                else {
                    self.navigationItem.title = "not hotdog"
                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        
        
        do {
            try! handler.perform([request])
        }
        
        catch {
            print (error)
        }
        
        
    }
    
    
    //IBAction of when the camera button is pressed
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

