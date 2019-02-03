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
            
                print("~~~~~~")
                print(shopifydata2)
                for product in shopifydata2.products {
                    var totalInv = 0
                    print("LOLOLOLOL")
                    self.actualProductIds.append(product.id)
                    print(product.id)
                    self.productTitles.append(product.title)
                    print(product.title)
                    for variant in product.variants {
                        print("*****")
                        totalInv = totalInv + variant.inventory_quantity
                        print(variant.inventory_quantity)
                        
                    }
                    self.variantInventory.append(totalInv)
                    
                }
            print(self.variantInventory)

                
            }
            catch let jsonError {
                print("JSON Error")
            }
            }.resume()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            //Check for matched Product IDS to =
            for i in self.actualProductIds {
                if self.productIds.contains(i){
                    self.matchedProductIds.append(i)
                }
                
                
                
                self.collectionView.reloadData()
                
            }
            
            print(self.matchedProductIds)
            print(self.matchedProductIds.count)
            print(self.productTitles)
            //let myCount = self.matchedProductIds.count
            //same index as product id will be product title
            for i in self.matchedProductIds {
                //store index count of how many matched product ids are in matchedProductIds
            self.productIdIndexStore.append(self.matchedProductIds.firstIndex(of: i)!)
            }
            //Add the title found in the productTitles bassed on the index it is at and store at productTitleStore
            for i in self.productIdIndexStore {
                self.productTitleStore.append(self.productTitles[i])
            }
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return actualProductIds.count
        return self.matchedProductIds.count
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        var cellProdductNames = cell.viewWithTag(1) as! UILabel
        cellProdductNames.text = productTitleStore[indexPath.row]
        var cellCollectionName = cell.viewWithTag(2) as! UILabel
        cellCollectionName.text = collectionTitle
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
