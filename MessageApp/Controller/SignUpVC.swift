//
//  SignUpViewController.swift
//  MessageApp
//
//  Created by Alex Pepke on 6/29/18.
//  Copyright © 2018 Alex Pepke. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var userImagePicker: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    var userUid: String!
    var emailField: String!
    var passwordField: String!
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var username: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
    }
    override func viewDidDisappear(_ animated : Bool){
        if let _ = KeychainWrapper.standard.string(forKey: "uid"){
            performSegue(withIdentifier: "toMessages", sender:nil)
        }
    }
    func imagePickerController(_ _picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            userImagePicker.image = image
            imageSelected = true
        } else{
            print("image wasnt selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func setUser(img: String){
        
        let userData = [
            "username": username!,
            "userImg": img
        ]
        KeychainWrapper.standard.set(userUid, forKey: "uid")
        let location = Database.database().reference().child("users").child (userUid)
        location.setValue(userData)
        dismiss(animated: true, completion: nil)
    }
    
    func uploadImg(){
        if usernameField.text == nil{
            signUpBtn.isEnabled = false
        } else {
            username = usernameField.text
            
            signUpBtn.isEnabled = true
        }
        guard let img = userImagePicker.image, imageSelected == true else{
            print("image needs to be selected")
            return
        }
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let storageItem = Storage.storage().reference().child(imgUid)
            storageItem.putData(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("Couldn't Upload Image")
                } else {
                    print("Uploaded")
                    storageItem.downloadURL(completion: { (img, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        if img != nil {
                            self.setUser(img: img!.absoluteString)
                        }
                    }
                    )
                }
            }}
        
    }
    @IBAction func createAccount(_ sender: AnyObject){
        Auth.auth().createUser(withEmail: emailField, password: passwordField, completion: { (user, error) in
            if error != nil {
                print("Cant create user")
            } else{
                if let user = user {
                    self.userUid = user.user.uid
                }
            }
            self.uploadImg()
        })
    }
    @IBAction func selectedImgPicker(_ sender: AnyObject){
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func cancel(_ sender: AnyObject){
        dismiss(animated: true, completion: nil)
    }
}








