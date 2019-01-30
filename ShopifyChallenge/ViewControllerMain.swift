//
//  ViewController.swift
//  ShopifyChallenge
//
//  Created by Caleb Lee on 1/17/19.
//  Copyright © 2019 WithoutAnyLimit. All rights reserved.
//

import UIKit

struct ServerResponse: Decodable {
    var custom_collections: [Custom_Collections]
}

struct Custom_Collections: Decodable {
    var title: String
}
var indexCount = 0

class ViewControllerMain: UITableViewController {
    
 
    
    var tableArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let jsonUrlString = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        guard let url = URL(string: jsonUrlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let shopifydata = try JSONDecoder().decode(ServerResponse.self, from: data)
                for collection in shopifydata.custom_collections {
                    print(collection.title)
                    self.tableArray.append(collection.title)
                    
                }
                /*
                 let shopifycollection = shopifydata.custom_collections
                 shopifycollection.forEach { value in
                 print(self.title!)
                 
                 }
                 */
                //must be done on main thread
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            catch let jsonError {
                
            }
            
            }.resume()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    
    }

}
extension ViewControllerMain {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.tableArray[indexPath.row]
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableArray.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexCount = indexPath.row
        performSegue(withIdentifier: "tableToCollectionSegue", sender: self)
        
    }
    
}
