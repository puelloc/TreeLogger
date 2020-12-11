//
//  DetailViewController.swift
//  TreeLogger
//
//  Created by user180294 on 12/7/20.
//  Copyright © 2020 Aport093. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: Variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var listing = Tree()
    @IBOutlet var speciesTextField: UITextField!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet var readyTextField: UITextField!
    @IBOutlet var plantDateTextField: UITextField!
    @IBOutlet var readyDateTextField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    // MARK: Will Appear
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        speciesTextField.text = listing.species
        heightTextField.text = listing.adult_height
        readyTextField.text = "\(listing.ready)"
        plantDateTextField.text = "\(formatter.string(from: listing.plant_date!))"
        readyDateTextField.text = "\(formatter.string(from: listing.ready_date!))"
        if listing.img != nil { // only display an image if the img attribute is not nil
            imageView.image = UIImage(data: listing.img!) // convert the img attribute to a uiimage and display it
        }
    }
    
    // MARK: Will Disappear
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        let formatter = DateFormatter() // format the date for the plant and ready dates
        formatter.dateFormat = "MM/dd/yyyy"
        
        listing.plant_date = formatter.date(from: plantDateTextField.text ?? "01/01/2000")
        
        var dateComponents = DateComponents() // update the ready date for the adjusted plant date
        var monthsToAdd = 0
        switch listing.species {
        case "Podocarpus":
            monthsToAdd = 6
        case "Jatropha":
            monthsToAdd = 6
        case "Japanese Blueberry":
            monthsToAdd = 24
        case "Mammy Croton":
            monthsToAdd = 9
        case "Green Island Ficus":
            monthsToAdd = 10
        default:
            monthsToAdd = 6
        }
        dateComponents.month = monthsToAdd
        listing.ready_date = Calendar.current.date(byAdding: dateComponents, to: listing.plant_date ?? Date())
    
        do {
            try context.save()
        } catch {
            print(error)
        }
        
    }
    
    // MARK: Should Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Dismiss Keyboard
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    
    // MARK: Photo Source
    @IBAction func choosePhotoSource(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.barButtonItem = sender
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in /**print("Present camera")*/
                let imagePicker = self.imagePicker(for: .camera)
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in /**print("Present photo library") */
            let imagePicker = self.imagePicker(for: .photoLibrary)
            imagePicker.modalPresentationStyle = .popover
            imagePicker.popoverPresentationController?.barButtonItem = sender
            self.present(imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(photoLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Image Picker
    func imagePicker(for sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        return imagePicker
    }
    
    // MARK: Picker Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        
        // turn the selected image into binary data if the value is not nil and assign it to the tree img value
        if image.pngData() != nil {
            listing.img = image.pngData()
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        imageView.image = image
        
        dismiss(animated: true, completion: nil)
    }
    
}
