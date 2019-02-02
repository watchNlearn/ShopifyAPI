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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("~~~~ Collection View ~~~~")
        print(collectionTitle)
        // Do JSON Call to get Cell Array List
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
