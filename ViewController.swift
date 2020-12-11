//
//  ViewController.swift
//  TreeLogger
//
//  Created by user180294 on 12/1/20.
//  Copyright © 2020 Aport093. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    // MARK: Variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var trees:[Tree]?
    var species: [String] = ["Podocarpus", "Jatropha", "Japanese Blueberry", "Mammy Croton", "Green Island Ficus"]
    
    // MARK: Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // this generates trees for initial run
//        for x in species {
//            var newTrees = Tree(context: self.context)
//            newTrees = newTrees.newTree(species: x, newTree: newTrees)
//            trees?.append(newTrees)
//            do {
//                try context.save()
//            } catch {
//                print(error)
//            }
//        }
        
        fetchTrees()
    }
    
    // MARK: Fetch Trees
    func fetchTrees()
    {
        do { // retrieves the updated list from core data
            self.trees = try context.fetch(Tree.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            
        }
    }
    
    // MARK: Num Rows in Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.species.count // the quantity is determined by the number of species
    }
    
    // MARK: Cell for  RowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        var quantity: Int = 0 // this evaluates the quantity if trees in the inventory that belong to each species
        for x in self.trees! {
            if x.species == species[indexPath.row] {
                quantity += 1
            }
        }
        
        cell.textLabel?.text = self.species[indexPath.row]
        cell.detailTextLabel?.text = "Quantity: \(quantity)"

        return cell
    }
    
    // Mark: Editing Style Row At
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing { // disable swipe to delete for species table
            return .delete
        }
        return .none
    }
    
    // MARK: Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier
        {
        case "TreeList":
            if let row = tableView.indexPathForSelectedRow?.row
            {
                let listing = self.species[row]
                let NavViewController = segue.destination as! UINavigationController
                let TreeListViewController = NavViewController.visibleViewController as! TreeListViewController
                TreeListViewController.species = listing // pass the selected species to the tree list table
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    // MARK: Will Appear
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
}

