//
//  TreeListViewController.swift
//  TreeLogger
//
//  Created by user180294 on 12/7/20.
//  Copyright © 2020 Aport093. All rights reserved.
//

import UIKit

class TreeListViewController: UITableViewController {
    
    // MARK: Variables
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var trees:[Tree]?
    var species: String = ""
    var currentTreeList: [Tree] = []
        
    // MARK: Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTrees()
        currentList()
    }
    
    // Mark: Current List
    func currentList()
    {
        for x in self.trees! { // creates a list of trees with only trees that match the specified species value
            if x.species == self.species {
                currentTreeList.append(x)
            }
        }
    }
    
    // MARK: Fetch Trees
    func fetchTrees()
    { // retrieves an updated list of trees from core data
        do {
            self.trees = try context.fetch(Tree.fetchRequest())
                
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
        }
    }
    
    // MARK: Toggle Editing
    @IBAction func toggleEditingMode(_ sender: UIBarButtonItem) {
        if isEditing {
            sender.title = "Edit"
            setEditing(false, animated: true)
        } else {
            sender.title = "Done"
            setEditing(true, animated: true)
        }
    }
        
    // MARK: Num Rows in Section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var quantity = 0 // the quantity of rows is equivalent to the number of trees which match the selected species
        for x in self.trees! {
            if x.species == self.species{
                quantity += 1
            }
        }
        return quantity
    }
        
    // MARK: Cell for  RowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let tree = self.currentTreeList[indexPath.row]
        
        tree.ready = tree.isItReady(currentTree: tree) // checks and updates the trees ready value
        var ready = ""
        if tree.ready {
            ready = "Ready"
        } else {
            ready = "Not ready"
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
        
        cell.textLabel?.text = tree.species
        cell.detailTextLabel?.text = ready

        return cell
    }
        
    // MARK: Prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier
        {
        case "detailSegue":
            if let row = tableView.indexPathForSelectedRow?.row
            {
                let listing = self.currentTreeList[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.listing = listing // pass the selected tree
            }
        case "addSegue":
            let addViewController = segue.destination as! AddViewController
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
        
    // MARK: Will Appear
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated) // re-check the ready values for all the trees
        for tree in currentTreeList {
            tree.ready = tree.isItReady(currentTree: tree)
        }
        
        fetchTrees()
    }
    
    // MARK: Will Disappear
    override func viewWillDisappear(_ animated: Bool) {
        if let parent = self.presentingViewController as? ViewController {
            parent.fetchTrees()
        } // update the quantities for the species table view when the modal view is dismissed
    }

    // MARK: Trailing Swipe Action
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete")
        {
            (action, view, completionHandler) in

            let treeToRemove = self.currentTreeList[indexPath.row]
            self.currentTreeList.remove(at: indexPath.row)
            self.context.delete(treeToRemove)

            do {
                try self.context.save()
            } catch {
                print("failed to save")
            }

            self.fetchTrees()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
