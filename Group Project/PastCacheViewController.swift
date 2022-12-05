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

// core data delegate
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

// create a class cache
class Cache{
    var cacheDifficulty:Int
    var cacheEmail:String
    var cacheHazards: String
    var cacheHints: String
    var cacheLatitude:Double
    var cacheLongitude:Double
    var cacheTitle:String
    
    // initialize all values in the cache
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

class PastCacheViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var coordArray = [[Cache]]()
    
    // create an outlet to the tableView
    @IBOutlet weak var tableView: UITableView!
    
    // identifiers for segues
    let infoSegueIdentifier = "InfoSegueIdentifier"
    let textCellIdentifier = "TextCell"
    
    // set the arrays for the headers
    let headerTitles = [5, 4, 3, 2, 1]
    let sectionImages:[UIImage?] = [UIImage(named: "fiverank"), UIImage(named: "fourrank"), UIImage(named: "threerank"), UIImage(named: "tworank"), UIImage(named: "onerank")]
    
    //var sections: [[Cache]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the delegate
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // fill the array with the caches on core data
        fillData()
        
        // reload the table
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // set the array back to nothing
        coordArray = []
    }
    
    // delegate method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // find the row numbers
        let row = indexPath.row
        let section = indexPath.section
        // create a cell when needed
        let cell  = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! PastCacheTableViewCell
        
        // set the image view to according with the cache difficulty
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
        
        // fill the cell name with the corresponding cache attributes
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return coordArray.count
    }
    
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(headerTitles[section])
    }*/
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // get an image view
        let imageView = UIImageView()
        //print(sectionImages[section])
        // set the image to the images in the array
        imageView.image = sectionImages[section]
        // set the head to a view and add the imageview
        let headerView = UIView()
        //headerView.backgroundColor = .white
        headerView.addSubview(imageView)
        
        // set constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true

        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        
        // get arrays of the caches corresponding to difficulty
        var cacheArray1:[Cache] = []
        var cacheArray2:[Cache] = []
        var cacheArray3:[Cache] = []
        var cacheArray4:[Cache] = []
        var cacheArray5:[Cache] = []
        
        // iterate through all the caches and append them to the current cache list
        for caches in fetchedResults!{
            // append the cache to the array corresponding to its difficulty
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
        
        // append the arrays to another array
        coordArray.append(cacheArray5)
        coordArray.append(cacheArray4)
        coordArray.append(cacheArray3)
        coordArray.append(cacheArray2)
        coordArray.append(cacheArray1)
    }
    
    // CHANGE TO NO GLOBAL
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segue to the screen with cache information
        if segue.identifier == infoSegueIdentifier,
           let destination = segue.destination as? PastCacheInfoViewController,
           // get the row and section of the cache in the array
           let infoIndexRow = tableView.indexPathForSelectedRow?.row,
           let infoIndexSection = tableView.indexPathForSelectedRow?.section{
            
            destination.titleInfo = coordArray[infoIndexSection][infoIndexRow].cacheTitle
            destination.diffInfo = coordArray[infoIndexSection][infoIndexRow].cacheDifficulty
            destination.hintInfo = coordArray[infoIndexSection][infoIndexRow].cacheHints
            destination.hazardInfo = coordArray[infoIndexSection][infoIndexRow].cacheHazards
            destination.latInfo = coordArray[infoIndexSection][infoIndexRow].cacheLatitude
            destination.longInfo = coordArray[infoIndexSection][infoIndexRow].cacheLongitude
            
            /*// give the destination the row and section
            destination.cacheRow = infoIndexRow
            destination.cacheSection = infoIndexSection*/
        }
    }
    
    func deleteData(row:Int){
        // fetch the cache from the core data
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CacheData")
        var fetchedResults:[NSManagedObject]
        
        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            // delete the cache at the specific row
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
