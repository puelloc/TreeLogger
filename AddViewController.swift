//
//  AddViewController.swift
//  TreeLogger
//
//  Created by user180294 on 12/7/20.
//  Copyright © 2020 Aport093. All rights reserved.
//

import UIKit
import CoreData


class AddViewController: UIViewController{
    
    // MARK: Variables
    @IBOutlet weak var plantDate: UIDatePicker!
    @IBOutlet weak var speciesP: UIPickerView!
    var newTree: Tree?
    var speciesArr: [String]?
    var selectedSpecies: String?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: Did Load 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.speciesP.dataSource = self
        self.speciesP.delegate = self
        newTree = Tree(context: context)
        speciesArr = newTree?.getAllSpecies()

    }

    // MARK: create/save new tree
    @IBAction func addNewTree(_ sender: Any) {
        //variable to store tree data from newTree fynction
        var treeData: Tree
        
        //deafault = Podocarpus when selectedSpecies == nil
        if(selectedSpecies == nil){
            treeData = newTree!.newTree(species: "" , newTree: newTree!)
        }
        else{
            treeData = newTree!.newTree(species: selectedSpecies!, newTree: newTree!)
        }
        
        //
        newTree!.species = treeData.species
        newTree!.plant_date = plantDate.date
        newTree!.ready_date = treeData.ready_date
        newTree!.adult_height = treeData.adult_height
        newTree!.ready = treeData.isItReady(currentTree: newTree!)
        
        //save data
        do{
                try self.context.save()
        }
        catch let error{
                print(error.localizedDescription)
        }
         
        //return to to root view when form is submitted
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    
    }

}
extension AddViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    //UIPicker Protocol
    
    // MARK: Number of rows in component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return speciesArr!.count
    }
    
    // MARK: number of components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // MARK: Title for row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return speciesArr![row]
    }
    
    // MARK: Did select row
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //update currently selected species
        self.selectedSpecies = speciesArr![row]
    }
    
}
