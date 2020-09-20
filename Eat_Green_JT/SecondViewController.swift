//
//  SecoundViewController.swift
//  Eatgreen2
//
//  Created by John Tucker on 12/5/18.
//  Copyright © 2018 John Tucker. All rights reserved.
//

import UIKit

// This function searches for a substring within another string
// Citation: https://jayeshkawli.ghost.io/regular-expressions-in-swift-ios/
func matches(for regex: String, in text: String) -> [String] {
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        let finalResult = results.map {
            String(text[Range($0.range, in: text)!])
        }
        return finalResult
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}


class SecoundViewController: UIViewController {
    
    @IBAction func GoHome(_ sender: Any) {
        performSegue(withIdentifier: "GoHome", sender: self)
    }
    // The Label that will produce the grade
    @IBOutlet weak var Label: UILabel!
    
    // The Label that presents the name of the food submitted
    @IBOutlet weak var Name: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Name.text = foodname
        var url: URL!
        
        // Value of meal is set in ViewController, and it determines whether to open breakfast, lunch, or dinner link
        if meal == "Breakfast"{
            url = URL(string: "http://www.foodpro.huds.harvard.edu/foodpro/menu_items.asp?type=30&meal=0")
        }
        if meal == "Lunch"{
            url = URL(string: "http://www.foodpro.huds.harvard.edu/foodpro/menu_items.asp?type=30&meal=1")
        }
        if meal == "Dinner"{
            url = URL(string: " http://www.foodpro.huds.harvard.edu/foodpro/menu_items.asp?type=30&meal=1")
        }
        
        // Begins task to gather information from either the breakfast, lunch, or dinner menu website, using url above
        // Citation (on how to gather html from a website): https://www.youtube.com/watch?v=JFf1ufSSrrM
        
        if url == nil {
            self.Label.text = "Err"
        }
        else{
        
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                // If not able to open url properly
                if error != nil {
                    self.Label.text = "Err"
                }
                    
                    // If able to open url properly
                else{
                    // html of the website
                    let htmlContent = NSString(data: data!, encoding: String.Encoding.iso2022JP.rawValue)
                    // Regular expression for each chunk of the html pertaining to each food
                    let foodregex = "<td class=\"menu_item\">\\R.*\\R.*\\R.*\\R.*http.*\\R.*\\R"
                    // Creates array for each chunk of html pertaining to each food
                    let foodparts = matches(for: foodregex, in: htmlContent! as String)
                    // Declares coorecturloffood as a string
                    var correcturloffood = ""
                    
                    // For each chunk of food html, checks to see if it's about food inputed by the user
                    for eachfood in foodparts {
                        // If food name inputed by user is found in this chunk, it is put into array nameoffood
                        var nameoffood = matches(for: foodname, in: eachfood as String)
                        
                        // If we found the food inputed by user
                        if nameoffood.count != 0{
                            // Regx for the url for the food specific page
                            var regxurl = "http://.*"
                            // Finds the url of food specific page and puts it into array correcturloffoodarray
                            var correcturloffoodarray = matches(for: regxurl, in: eachfood as String)
                            // Makes the single item in array a string correcturloffoodstring
                            var correcturloffoodstring = String(correcturloffoodarray[0])
                            // Takes off >" from end of string becaus it is not part of actual url
                            correcturloffood = correcturloffoodstring.replacingOccurrences(of: "\">", with: "")
                        }
                    }
                    
                    if correcturloffood == ""{
                        self.performSegue(withIdentifier: "GoHome", sender: self)
                    }
                    // Opens URL of page specific to the food
                    let url2 = URL(string: correcturloffood)
                    
                    // Begins task to gather information from food specific website, using url2 above
                    let task2 = URLSession.shared.dataTask(with: url2!) { (data, response, error) in
                        // If not able to open url properly
                        if error != nil {
                            self.Label.text = "error"
                        }
                            
                        else{
                            // Sets htmlContent2 to the html of the website
                            let htmlContent2 = NSString(data: data!, encoding: String.Encoding.iso2022JP.rawValue)
                            // Regular expression for the list of ingredients
                            var ingredientsregex = "Ingredients:</b>\\s*.*"
                            // Creates an array with one item for all of the ingredients
                            var arrayofingredients = matches(for: ingredientsregex, in: htmlContent2! as String)
                            // Makes the single item in the array a string someingredients
                            var ingredients = String(arrayofingredients[0])
                            
                            // Declares counter of type Double (counter is going to reflect severity of enviornmental impact)
                            var counter: Double = 0
                            
                            // Foods extreamly bad for enviornment (rank 3)
                            let badfoods3 = ["Lamb", "Beef"]
                            // Foods bad for the enviornment (rank 2)
                            let badfoods2 = ["Cheese", "Pork", "Salmon", "Turkey"]
                            // Foods that are pretty bad for the enviornment (rank 1)
                            let badfoods1 = ["Chicken", "Tuna", "Egg"]
                            // Foods that are not great for the enviornment (rank 0)
                            let badfoods0 = ["Potatoes", "Rice", "Nut", "Yogurt", "Broccoli", "Tofu", "Bean", "Milk", "Tomato", "Lentil"]
                            
                            // For each food in the badfoods3 array
                            for food in badfoods3{
                                let foundfood = matches(for: food, in: ingredients as String)
                                if foundfood.count != 0{
                            
                                    counter = counter + 3
                                }
                            }
                            
                            // For each food in the badfoods2 array
                            for food in badfoods2{
                           
                                let foundfood = matches(for: food, in: ingredients as String)
                                if foundfood.count != 0{
                                    counter = counter + 2
                                }
                            }
                            // For each food in the badfoods1 array
                            for food in badfoods1{
                   
                                let foundfood = matches(for: food, in: ingredients as String)
                                if foundfood.count != 0{
                                
                                    counter = counter + 1
                                }
                            }
                            
                            // For each food in the badfoods0 array
                            for food in badfoods0{
                                let foundfood = matches(for: food, in: ingredients as String)
                                if foundfood.count != 0{
                                    counter = counter + 0.5
                                }
                            }
                            
             
                            var grade = ""
                            
                            // Assigns letter grade reflecting enviornmental impact based on counter
                            if counter <= 0.5{
                                grade = "A"
                            }
                        
                            else if counter <= 1{
                                grade = "B"
                            }

                            else if counter <= 2{
                                grade = "C"
                            }

                            else if counter <= 3{
                                grade = "D"
                            }

                            else if counter > 3{
                                grade = "F"
                            }
                            
                            // Sets a label in the page to the letter grade calculated above
                            self.Label.text = String(grade)
                        }
                    }
                    // Resumes task2 (which opened food specific website)
                    task2.resume()
                }
            }
            // Resumes task1 (which opened the menu page for the type of meal indicated by user)
            task.resume()
        }
 
    }
}
// Citation for image: https://www.rotary.org/en/supporting-environment-becomes-new-area-focus
