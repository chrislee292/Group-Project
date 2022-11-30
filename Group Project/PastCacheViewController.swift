//
//  PastCacheViewController.swift
//  Group Project
//
//  Created by Justin Vu on 11/29/22.
//

import UIKit
import CoreLocation
import FirebaseCore
import FirebaseAuth
import Firebase
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

class Cache{
    var cacheDifficulty:Int
    var cacheEmail:String
    var cacheHazards: String
    var cacheHints: String
    var cacheLatitude:Double
    var cacheLongitude:Double
    var cacheTitle:String
    
    init(cacheDifficulty: Int, cacheEmail: String, cacheHazards: String, cacheHints: String, cacheLatitude: Double, cacheLongitude: Double, cacheTitle: String) {
        self.cacheDifficulty = cacheDifficulty
        self.cacheEmail = cacheEmail
        self.cacheHazards = cacheHazards
        self.cacheHints = cacheHints
        self.cacheLatitude = cacheLatitude
        self.cacheLongitude = cacheLongitude
        self.cacheTitle = cacheTitle
    }
}

var coordArray = [[Cache]]()

class PastCacheViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let infoSegueIdentifier = "InfoSegueIdentifier"
    let textCellIdentifier = "TextCell"
    let headerTitles = [5, 4, 3, 2, 1]
    let sectionImages:[UIImage?] = [UIImage(named: "starfive"), UIImage(named: "starfour"), UIImage(named: "starthree"), UIImage(named: "startwo"), UIImage(named: "starone")]
    
    //var sections: [[Cache]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fillData()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fillData()
        
        //let cDiffs = coordArray.map { $0.cacheDifficulty}
        
        /*sections = headerTitles.map { cDiffs in
            return coordArray
                .filter { $0.cacheDifficulty == cDiffs } // only names with the same first letter in title
        }*/
        
        print(coordArray)
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        coordArray = []
    }
    
    // delegate method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // find the row numbers
        let row = indexPath.row
        let section = indexPath.section
        // create a cell when needed
        let cell  = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! PastCacheTableViewCell
        
        if Int(coordArray[section][row].cacheDifficulty) == 1{
            cell.textImageView.image = UIImage(named: "onestar")
        }
        if Int(coordArray[section][row].cacheDifficulty) == 2{
            cell.textImageView.image = UIImage(named: "twostar")
        }
        if Int(coordArray[section][row].cacheDifficulty) == 3{
            cell.textImageView.image = UIImage(named: "threestar")
        }
        if Int(coordArray[section][row].cacheDifficulty) == 4{
            cell.textImageView.image = UIImage(named: "fourstar")
        }
        if Int(coordArray[section][row].cacheDifficulty) == 5{
            cell.textImageView.image = UIImage(named: "fivestar")
        }
        
        // fill the cell name with the corresponding pizza attributes
        cell.titleLabel.text = "\(coordArray[section][row].cacheTitle)"
        // create the cell
        return cell
    }
    
    // runs when a cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        
        // make an animation that fades when cell is clicked
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // add swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // remove from the item from the data source
            coordArray.remove(at: indexPath.row)
            
            // delete the pizza from the core data at that spot
            deleteData(row: indexPath.row)
            
            // remove the row
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return coordArray.count
    }
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(headerTitles[section])
    }*/
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let imageView = UIImageView()
        //print(sectionImages[section])
        imageView.image = sectionImages[section]
        let headerView = UIView()
        //headerView.backgroundColor = .white
        headerView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true

        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(section)
        print(coordArray)
        return coordArray[section].count
    }
    
    func fillData(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CacheData")
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            // fetch the caches as an array
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            // if an error occurs display it
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        var cacheArray1:[Cache] = []
        var cacheArray2:[Cache] = []
        var cacheArray3:[Cache] = []
        var cacheArray4:[Cache] = []
        var cacheArray5:[Cache] = []
        
        // iterate through all the caches and append them to the current cache list
        for caches in fetchedResults!{
            if caches.value(forKey: "difficulty") as! Int == 1{
                cacheArray1.append(Cache(cacheDifficulty: caches.value(forKey: "difficulty") as! Int, cacheEmail: caches.value(forKey: "email") as! String, cacheHazards: caches.value(forKey: "hazards") as! String, cacheHints: caches.value(forKey: "hints") as! String, cacheLatitude: caches.value(forKey: "latitude") as! Double, cacheLongitude: caches.value(forKey: "longitude") as! Double, cacheTitle: caches.value(forKey: "title") as! String))
            }
            if caches.value(forKey: "difficulty") as! Int == 2{
                cacheArray2.append(Cache(cacheDifficulty: caches.value(forKey: "difficulty") as! Int, cacheEmail: caches.value(forKey: "email") as! String, cacheHazards: caches.value(forKey: "hazards") as! String, cacheHints: caches.value(forKey: "hints") as! String, cacheLatitude: caches.value(forKey: "latitude") as! Double, cacheLongitude: caches.value(forKey: "longitude") as! Double, cacheTitle: caches.value(forKey: "title") as! String))
            }
            if caches.value(forKey: "difficulty") as! Int == 3{
                cacheArray3.append(Cache(cacheDifficulty: caches.value(forKey: "difficulty") as! Int, cacheEmail: caches.value(forKey: "email") as! String, cacheHazards: caches.value(forKey: "hazards") as! String, cacheHints: caches.value(forKey: "hints") as! String, cacheLatitude: caches.value(forKey: "latitude") as! Double, cacheLongitude: caches.value(forKey: "longitude") as! Double, cacheTitle: caches.value(forKey: "title") as! String))
            }
            if caches.value(forKey: "difficulty") as! Int == 4{
                cacheArray4.append(Cache(cacheDifficulty: caches.value(forKey: "difficulty") as! Int, cacheEmail: caches.value(forKey: "email") as! String, cacheHazards: caches.value(forKey: "hazards") as! String, cacheHints: caches.value(forKey: "hints") as! String, cacheLatitude: caches.value(forKey: "latitude") as! Double, cacheLongitude: caches.value(forKey: "longitude") as! Double, cacheTitle: caches.value(forKey: "title") as! String))
            }
            if caches.value(forKey: "difficulty") as! Int == 5{
                cacheArray5.append(Cache(cacheDifficulty: caches.value(forKey: "difficulty") as! Int, cacheEmail: caches.value(forKey: "email") as! String, cacheHazards: caches.value(forKey: "hazards") as! String, cacheHints: caches.value(forKey: "hints") as! String, cacheLatitude: caches.value(forKey: "latitude") as! Double, cacheLongitude: caches.value(forKey: "longitude") as! Double, cacheTitle: caches.value(forKey: "title") as! String))
            }
        }
        coordArray.append(cacheArray5)
        coordArray.append(cacheArray4)
        coordArray.append(cacheArray3)
        coordArray.append(cacheArray2)
        coordArray.append(cacheArray1)
        //print("hello")
        //print(coordArray)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == infoSegueIdentifier,
           let destination = segue.destination as? PastCacheInfoViewController,
           let infoIndexRow = tableView.indexPathForSelectedRow?.row,
           let infoIndexSection = tableView.indexPathForSelectedRow?.section{
            destination.cacheRow = infoIndexRow
            destination.cacheSection = infoIndexSection
        }
    }
    
    func deleteData(row:Int){
        // fetch the pizzas from the core data
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CacheData")
        var fetchedResults:[NSManagedObject]
        
        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            print(fetchedResults[row])
            // delete the pizza at the specific row
            context.delete(fetchedResults[row])
            
            // update
            saveContext()
            
        } catch {
            // if an error occurs dislpay it
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    // save the core data changes
    func saveContext () {
        // check for changes
        if context.hasChanges {
            do {
                // save
                try context.save()
            } catch {
                // error
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
