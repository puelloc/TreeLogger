//
//  Tree+CoreDataClass.swift
//  TreeLogger
//
//  Created by user180294 on 12/6/20.
//  Copyright © 2020 Aport093. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Tree)
public class Tree: NSManagedObject {
    
    func isItReady(currentTree: Tree) -> Bool {
        if currentTree.ready_date! <= Date() {
            return true
        } else {
            return false
        }
    }
    
    func newTree(species: String, newTree: Tree) -> Tree {
        return speciesDetails(specie: species, newTree: newTree)
    }
    
    func getAllSpecies()-> Array<String>{
        return ["Podocarpus", "Jatropha", "Japanese Blueberry", "Mammy Croton", "Green Island Ficus"]
    }
    
    func speciesDetails(specie: String, newTree: Tree) -> Tree {
        switch specie {
        case "Podocarpus":
            return Podocarpus(newTree: newTree)
        case "Jatropha":
            return Jatropha(newTree: newTree)
        case "Japanese Blueberry":
            return JapaneseBlueberry(newTree: newTree)
        case "Mammy Croton":
            return MammyCroton(newTree: newTree)
        case "Green Island Ficus":
            return GreenIslandFicus(newTree: newTree)
        default:
            return Podocarpus(newTree: newTree)
        }
    }
    // MARK: Podocarpus
    func Podocarpus(newTree: Tree) -> Tree {
        //let newTree = Tree()
        newTree.adult_height = "30 - 40ft"
        newTree.species = "Podocarpus"
        newTree.plant_date = Date()
        var dateComponents = DateComponents()
        let monthsToAdd = 6
        dateComponents.month = monthsToAdd
        newTree.ready_date = Calendar.current.date(byAdding: dateComponents, to: newTree.plant_date ?? Date())
        newTree.ready = false
        return newTree
    }
    // MARK: Jatropha
    func Jatropha(newTree: Tree) -> Tree {
        //let newTree = Tree()
        newTree.adult_height = "10 - 15ft"
        newTree.species = "Jatropha"
        newTree.plant_date = Date()
        var dateComponents = DateComponents()
        let monthsToAdd = 6
        dateComponents.month = monthsToAdd
        newTree.ready_date = Calendar.current.date(byAdding: dateComponents, to: newTree.plant_date ?? Date())
        newTree.ready = false
        return newTree
    }
    // MARK: Japanese Blueberry
    func JapaneseBlueberry(newTree: Tree) -> Tree {
        //let newTree = Tree()
        newTree.adult_height = "10 - 12ft"
        newTree.species = "Japanese Blueberry"
        newTree.plant_date = Date()
        var dateComponents = DateComponents()
        let monthsToAdd = 24
        dateComponents.month = monthsToAdd
        newTree.ready_date = Calendar.current.date(byAdding: dateComponents, to: newTree.plant_date ?? Date())
        newTree.ready = false
        return newTree
    }
    // MARK: Mammy Croton
    func MammyCroton(newTree: Tree) -> Tree {
        //let newTree = Tree()
        newTree.adult_height = "24 - 36in"
        newTree.species = "Mammy Croton"
        newTree.plant_date = Date()
        var dateComponents = DateComponents()
        let monthsToAdd = 9
        dateComponents.month = monthsToAdd
        newTree.ready_date = Calendar.current.date(byAdding: dateComponents, to: newTree.plant_date ?? Date())
        newTree.ready = false
        return newTree
    }
    // MARK: Green Island Ficus
    func GreenIslandFicus(newTree: Tree) -> Tree {
        //let newTree = Tree()
        newTree.adult_height = "3 - 8ft"
        newTree.species = "Green Island Ficus"
        newTree.plant_date = Date()
        var dateComponents = DateComponents()
        let monthsToAdd = 10
        dateComponents.month = monthsToAdd
        newTree.ready_date = Calendar.current.date(byAdding: dateComponents, to: newTree.plant_date ?? Date())
        newTree.ready = false
        return newTree
    }
}
