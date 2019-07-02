//
//  SettingTableVC.swift
//  Note
//
//  Created by User on 02/07/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit


protocol fontsizepassDelegate {
    func fontsizepass(fontName:String,fontSize:CGFloat)
}
class SettingTableVC: UITableViewController {

    var settingArray = ["Font Size"]
    var delegate:fontsizepassDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    @IBAction func backClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settingArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

       cell.textLabel?.text = settingArray[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(settingArray[indexPath.row])
        
        if settingArray[indexPath.row] == "Font Size"{
            AlertWithTextField(self)
            
            
            
        }

    

}
}
extension SettingTableVC{
    
    
    func AlertWithTextField(_ view:UIViewController) -> UIAlertController{
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Font Style", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        
        actionSheetController.addAction(UIAlertAction(title: "Heavy" , style: .default , handler:{ (UIAlertAction)in
            
            
            self.delegate?.fontsizepass(fontName: "Avenir-Heavy", fontSize: 22.0)
            
        }))
        actionSheetController.addAction(UIAlertAction(title: "Medium" , style: .default , handler:{ (UIAlertAction)in
            self.delegate?.fontsizepass(fontName: "Avenir-Medium", fontSize: 18.0)
            
        }))
        actionSheetController.addAction(UIAlertAction(title: "Light" , style: .default , handler:{ (UIAlertAction)in
            self.delegate?.fontsizepass(fontName: "Avenir-Light", fontSize: 16.0)
            
        }))
        
        
        view.present(actionSheetController, animated: true, completion: {
            print("completion block")
        })
        return actionSheetController
    }
}
