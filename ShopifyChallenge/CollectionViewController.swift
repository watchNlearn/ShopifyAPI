//
//  CollectionViewController.swift
//  ShopifyChallenge
//
//  Created by Caleb Lee on 1/29/19.
//  Copyright © 2019 WithoutAnyLimit. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    var cellArrayNames = [String]()
    var collectionTitle: String = ""
    var collectionID: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("~~~~ Collection View ~~~~")
        print(collectionTitle)
        print(collectionID)
        // Do JSON Call to get Cell Array List
        //Get prod Ids from https://shopicruit.myshopify.com/admin/collects.json?collection_id=68424466488&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6
        //then search the ids in https://shopicruit.myshopify.com/admin/products.json?ids=2759137027,2759143811&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6
        cellArrayNames = ["Hammer", "Brick", "Shovel"]
        // Do any additional setup after loading the view.
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as UICollectionViewCell
        var cellProdductNames = cell.viewWithTag(1) as! UILabel
        cellProdductNames.text = cellArrayNames[indexPath.row]
        
        
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
