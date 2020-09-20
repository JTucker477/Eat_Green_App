//
//  ViewController.swift
//  Eatgreen2
//
//  Created by John Tucker on 12/5/18.
//  Copyright © 2018 John Tucker. All rights reserved.
//

import UIKit
var foodname = ""
var meal = ""

class ViewController: UIViewController {
    
    @IBOutlet weak var Outlet: UITextField!
    
    // Action if user submits using Breakfast button
    @IBAction func Breakfast(_ sender: Any) {
        // If there is something in the textfield
        if (Outlet.text != ""){
            foodname = Outlet.text!
            meal = "Breakfast"
            // Redirect to the secound page
            performSegue(withIdentifier: "SegueBreakfast", sender: self)
        }
    }
    
    // Action if user submits using Lunch button
    @IBAction func Lunch(_ sender: Any) {
        // If there is something in the textfield
        if (Outlet.text != ""){
            foodname = Outlet.text!
            meal = "Lunch"
            // Redirect to the secound page
            performSegue(withIdentifier: "SegueLunch", sender: self)
        }
    }
    
    // Action if user submits using Dinner button
    @IBAction func Dinner(_ sender: Any) {
        // If there is something in the textfield
        if (Outlet.text != ""){
            foodname = Outlet.text!
            meal = "Dinner"
            // Redirect to the secound page
            performSegue(withIdentifier: "SegueDinner", sender: self)
        }
    }
    
    // Action if user clicks "Today's Menu" button
    @IBAction func MenuLink(_ sender: Any) {
        // Redirect User to the Harvard's menu website
        UIApplication.shared.openURL(URL(string: "http://www.foodpro.huds.harvard.edu/foodpro/menu_items.asp?type=30&meal=1")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
// Image Citation: https://www.apa.org/action/science/environment
