//
//  DonateScene.swift
//  GiveAndTake
//
//  Created by YOGESH SONI on 23/09/22.
//

import Foundation
import UIKit
// Firebase Libraries...
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

// ...
      

class DonateSceneController: UIViewController, UINavigationControllerDelegate {
    
    var titleField: String? = ""
    var descriptionField: String? = ""
    
    let db = Firestore.firestore()
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var titleFieldS: UITextField!
    @IBOutlet weak var descriptionfieldS: UITextView!
    @IBOutlet weak var uploadImage: UIImageView!
    
    @IBOutlet weak var testimage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
    }
    
    @IBAction func uploadButtonPressed(_ sender: Any) {
        imagePicker.modalPresentationStyle = .popover
        present(imagePicker, animated: true, completion: nil)
        }
    
    @IBAction func donatePressed(_ sender: Any) {
        titleField = titleFieldS.text ?? "Item"
        descriptionField = descriptionfieldS.text ?? "No Description from Donor"
        let tag =  UUID().uuidString
        let imageName = "\(tag).jpg"
        db.collection("Donations").document(tag).setData([
            "Item Title": titleField!,
            "Item Description": descriptionField!,
            "Image Name" : imageName
          ])
        
        uploadImage(tag: imageName)
        titleFieldS.text = ""
        descriptionfieldS.text = ""
    }
//_______________________________________________________
    func uploadImage(tag: String) {
        
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child(tag)
        let imgData = uploadImage.image?.pngData()
        
        //Upload the file to storage with name \(tag).jpg
        fileRef.putData(imgData!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                print(error!)
                return
            }
            print("image Uploaded")
            self.tabBarController?.selectedIndex = 0
            // Above line to switch to Home-Screen of tabBar when donate button is pressed and image is uploaded.
        }
    }
}

//MARK: imagePickerController Delegates methods
extension DonateSceneController : UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
            uploadImage.contentMode = .scaleAspectFit
            uploadImage.image = newImage
            dismiss(animated: true, completion: nil)
        } else {
            print("cannot fetch image")
      }
   }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


    
