//
//  ViewController.swift
//  Note
//
//  Created by Mac on 22/04/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource , editDataDelegate,fontsizepassDelegate{
    
    var noteArray = [Note]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var isDelegateSelect = false
    var fontName = String()
    var fontSize = CGFloat()
    @IBOutlet weak var noteTableViewController: UITableView!
    
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNotes()
        
        setupUI()

        print("asmita")
        
    }
    //MARK: uisetup method
    func setupUI() {
        //set dynamic height to tableview
        noteTableViewController.rowHeight = UITableView.automaticDimension
        noteTableViewController.estimatedRowHeight = 125
        //make button circuler
        addButton.layer.masksToBounds = true
        addButton.layer.cornerRadius = addButton.frame.width/2
        isDelegateSelect = true
        self.errorLbl.isHidden = true
        //load xib cell
        let nib = UINib.init(nibName: "NoteTableViewCell", bundle: nil)
        self.noteTableViewController.register(nib, forCellReuseIdentifier: "NoteTableViewCell")
        
    }
    //settingTVC delegate
    func fontsizepass(fontName: String,fontSize:CGFloat) {
        print(fontSize)
        isDelegateSelect = false
        self.fontName = fontName
        self.fontSize = fontSize
        self.noteTableViewController.reloadData()
    }
    @IBAction func settingBTNClick(_ sender: Any) {
        let settingvc = self.storyboard?.instantiateViewController(withIdentifier: "SettingTableVC") as! SettingTableVC
        settingvc.delegate = self
        self.present(settingvc, animated: true, completion: nil)
        
    }
    //MARK: tableview datasource method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  noteTableViewController.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell
        let note = noteArray[indexPath.row]
        
        cell.topView.layer.cornerRadius = 10
        cell.topView.layer.borderWidth = 1
        cell.topView.layer.borderColor = UIColor.orange.cgColor
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if isDelegateSelect{
            cell.title.text =  note.title
            cell.descriptionLbl.text = note.descriptionLbl
            
        }else {
            cell.title.text =  note.title
            cell.title.font = UIFont(name: self.fontName, size: self.fontSize)
            cell.descriptionLbl.text = note.descriptionLbl
            cell.descriptionLbl.font = UIFont(name: self.fontName, size: self.fontSize)
        }
        
        
        return cell
        
    }
    //MARK: table view delegate method
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "editVC", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditViewController
        
        if let index =  noteTableViewController.indexPathForSelectedRow {
            destinationVC.selectedNote = [noteArray[index.row]]
            //setting delegate method
            destinationVC.delegate = self
        }
    }
    
    //MARK : editdatachange delegate method
    //save data back to coredata object
    func editdata(title: String, desc: String) {
        if let index =  noteTableViewController.indexPathForSelectedRow{
            noteArray[index.row].setValue(title, forKey: "title")
            noteArray[index.row].setValue(desc, forKey: "descriptionLbl")
            saveitems()
        }
    }
    
    //on editstyle delete cell we delete coredata data
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(noteArray[indexPath.row])
            noteArray.remove(at: indexPath.row)
            saveitems()
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        var textfieldOne = UITextField()
        self.errorLbl.isHidden = true
        let alert = UIAlertController(title: "Add new note", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            //getting coredata persistent context
            
            let newNote = Note(context: self.context)
            if !textField.text!.isEmpty && !textfieldOne.text!.isEmpty{
                newNote.title = textField.text!
                newNote.descriptionLbl = textfieldOne.text!
                
                //append textfield data in array
                self.noteArray.append(newNote)
                //save data in coredata conext
                self.saveitems()
            }else {
                self.errorLbl.isHidden = false
            }
            
            
        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Add new note.."
            textField = alertTextfield
        }
        alert.addTextField { (textfield) in
            textfield.placeholder = "Add Description"
            textfieldOne = textfield
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: data manupulation method
    //save data to context
    func saveitems(){
        do{
            try context.save()
        }catch{
            print("error saving context \(error)")
        }
        self.noteTableViewController.reloadData()
    }
    
    //read data from coredata
    func loadNotes(){
        
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        
        do{
            noteArray =  try context.fetch(request)
        }
        catch{
            print("error while fetching data from context \(error)")
        }
        self.noteTableViewController.reloadData()
    }
    
}

