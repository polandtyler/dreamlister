//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by A664291 on 6/8/17.
//  Copyright © 2017 Tyler Poland. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumbImage: UIImageView!
    
    var stores = [Store]()
    var types = [ItemType]()
    
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        storePicker.delegate = self
        storePicker.dataSource = self
        
        typePicker.delegate = self
        typePicker.dataSource = self
        
        typePicker.isHidden = true
        storePicker.isHidden = false
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
////        Populate some test data
////        TODO: Additionally, let's find a way to kill off this state dependency

//        let store = Store(context: context)
//        store.name = "Best Buy"
//        let store2 = Store(context: context)
//        store2.name = "Tesla Dealership"
//        let store3 = Store(context: context)
//        store3.name = "Fry's Electronics"
//        let store4 = Store(context: context)
//        store4.name = "Target"
//        let store5 = Store(context: context)
//        store5.name = "Amazon"
//        let store6 = Store(context: context)
//        store6.name = "raywenderlich.com"
//
//        ad.saveContext()
        getStores()
        
        
        // Add more test data for types
//        let type = ItemType(context: context)
//        type.type = "Car"
//        let type2 = ItemType(context: context)
//        type2.type = "Electronics"
//        let type3 = ItemType(context: context)
//        type3.type = "Home"
//        let type4 = ItemType(context: context)
//        type4.type = "Job"
//        let type5 = ItemType(context: context)
//        type5.type = "Other"
//
//        ad.saveContext()
        getTypes()
        
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @available(iOS 2.0, *)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return stores.count
        } else {
            return types.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            let store = stores[row]
            return store.name
        } else {
            let type = types[row]
            return type.type
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // when option selected
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores  = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            // handle the error
        }
    }
    
    func getTypes() {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do {
            self.types = try context.fetch(fetchRequest)
            self.typePicker.reloadAllComponents()
        } catch {
            //catch error(s)
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        var item: Item!
        let picture = Image(context: context)
        picture.image = thumbImage.image
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        
        item.toImage = picture
        
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        
        item.toItemType = types[typePicker.selectedRow(inComponent: 0)]
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        
        navigationController?.popViewController(animated: true)
        
    }
    
    func loadItemData() {
        
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            thumbImage.image = item.toImage?.image as? UIImage
            
            // set selected store = toStore
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                } while (index < stores.count)
            }
            
            // set selected type = toItemType
            if let type = item.toItemType {
                var index = 0
                repeat {
                    let t = types[index]
                    if t.type == type.type {
                        typePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                } while (index < types.count)
            }
        }
        
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func addImage(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImage.image = img
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectStorePressed(_ sender: Any) {
        typePicker.isHidden = true
        storePicker.isHidden = false
    }
    
    @IBAction func selectTypePressed(_ sender: Any) {
        storePicker.isHidden = true
        typePicker.isHidden = false
    }
    
    
}
