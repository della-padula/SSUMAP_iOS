//
//  SurroundingViewController.swift
//  SSUMAP_iOS
//
//  Created by 김태인 on 2017. 7. 1..
//  Copyright © 2017년 Personal. All rights reserved.
//

import UIKit

class SurroundingViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(AppData.category_array[indexPath.row])
        
//        guard let nextView = self.storyboard?.instantiateViewController(withIdentifier: "NoticeVC") as? NoticeViewController else {
//            return
//        }
//        nextView.majorIndex = indexPath.row
//        nextView.majorName = self.majorList[indexPath.row].getName()
//        self.navigationController?.pushViewController(nextView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppData.category_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.categoryName.text = AppData.category_array[indexPath.row]
        cell.iconImage.image = AppData.category_image_array[indexPath.row]
        
        cell.selectionStyle = .none
        return cell
    }

}
