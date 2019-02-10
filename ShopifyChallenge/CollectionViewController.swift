//
//  CollectionViewController.swift
//  ShopifyChallenge
//
//  Created by Caleb Lee on 1/29/19.
//  Copyright © 2019 WithoutAnyLimit. All rights reserved.
//

import UIKit

struct CollectionResponse: Decodable {
    var collects: [Collects]
}
struct Collects: Decodable {
    var product_id: Int
}
//Second Json struct
struct ProductResponse: Decodable {
    var products: [Products]
}
struct Products: Decodable {
    var id: Int
    var title: String
    var variants: [Variants]
}
struct Variants: Decodable {
    var inventory_quantity: Int
}



class CollectionViewController: UICollectionViewController {

    var cellArrayNames = [String]()
    var collectionTitle: String = ""
    var collectionID: Int!
    var productIds = [Int]()
    var actualProductIds = [Int]()
    var matchedProductIds = [Int]()
    var productTitles = [String]()
    var productIdIndexStore = [Int]()
    var productTitleStore = [String]()
    var variantInventory = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("~~~~ Collection View ~~~~")
        print(collectionTitle)
        print(collectionID)
        
        let jsonUrlString = "https://shopicruit.myshopify.com/admin/collects.json?collection_id=68424466488&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        guard let url = URL(string: jsonUrlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let shopifydata = try JSONDecoder().decode(CollectionResponse.self, from: data)
                for collect in shopifydata.collects {
                    //print(collect.product_id)
                    self.productIds.append(collect.product_id)
                
                }
            }
            catch let jsonError {
            print("JSON Error")
            }
        }.resume()
        
        
       
        //Second JSON Call
        let jsonUrlString2 = "https://shopicruit.myshopify.com/admin/products.json?ids=2759137027,2759143811&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        guard let url2 = URL(string: jsonUrlString2) else {
            return
        }
        URLSession.shared.dataTask(with: url2) {(data, response, error) in
            guard let data2 = data else {
                return
            }
            do {
                let shopifydata2 = try JSONDecoder().decode(ProductResponse.self, from: data2)
                //for each product in returned data
                for product in shopifydata2.products {
                    //Init Inventory to 0
                    var totalInv = 0
                    //Append first product Id + Title to seperate Array
                    self.actualProductIds.append(product.id)
                    self.productTitles.append(product.title)
                    //for each variant in each product
                    for variant in product.variants {
                        //Increment Total Inv by the inv_quant returned
                        totalInv = totalInv + variant.inventory_quantity
                    }
                    //Append the first iteration of Product to Inventory []
                    //Appends the second iteration of Product to Inventory []
                    //And so on
                    self.variantInventory.append(totalInv)
                    
                }
            print(self.variantInventory)

                
            }
            catch let jsonError {
                print("JSON Error")
            }
            }.resume()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            //Still need to do imageDownload
            //https://cdn.shopify.com/s/files/1/1000/7970/collections/Awesome_20Bronze_20Bag_grande_0fa20b0a-0663-44cf-81c4-2d53b83e1d65.png?v=1545072802
            //original link has weird \ backslash
            
            //Check for matched Product IDS to =
            //Initial JSON call Returned Product IDS
            print(self.productIds)
            print(self.actualProductIds)

            for i in self.actualProductIds {
                //For each ID in ActualProdID if it is in
                //second JSON Call Prod IDS -> append to matched []
                if self.productIds.contains(i){
                    self.matchedProductIds.append(i)
                }
                //Reload Data
                self.collectionView.reloadData()
            }
            
            print(self.matchedProductIds)
            print(self.matchedProductIds.count)
            print(self.productTitles)
            //Ensurance incase there are more ActualProductIds Not In Product IDs
            //same index as product id will be product title
            for i in self.matchedProductIds {
            //for each id found in matchedProductIds
            //store the index that it was found at in productIdIndexStore
            self.productIdIndexStore.append(self.matchedProductIds.firstIndex(of: i)!)
            }
            //Add the title found in the productTitles bassed on the index it is at and store at productTitleStore
            //For each index (2 in this case) store the Product Title to the Corresponding Index
            for i in self.productIdIndexStore {
                //Titles Will Be Stored In Order of index
                self.productTitleStore.append(self.productTitles[i])
            }
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.matchedProductIds.count
        
    }
    //Add info to each cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //What Cell is INIT
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        //Cell product names
        var cellProdductNames = cell.viewWithTag(1) as! UILabel
        cellProdductNames.text = productTitleStore[indexPath.row]
        //Cell collection names
        var cellCollectionName = cell.viewWithTag(2) as! UILabel
        cellCollectionName.text = collectionTitle
        //Cell collection inventory amount
        var cellCollectionInventory = cell.viewWithTag(3) as! UILabel
        cellCollectionInventory.text = "Total Inventory: " + String(variantInventory[indexPath.row])
        
        
        return cell
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
