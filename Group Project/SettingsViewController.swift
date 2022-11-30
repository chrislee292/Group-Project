//
//  SettingsViewController.swift
//  Group Project
// 
//  Created by Jayashree Ganesan on 11/17/22.
//

import UIKit
import FirebaseAuth

let textCellIdentifier = "TextCell"

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        create_header()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        create_header()
    }
    
    func create_header() {
        let headerView: UIView = UIView.init(frame: CGRect(x: self.view.frame.minX, y: self.view.frame.minY, width: self.view.frame.width, height: 40))
        headerView.backgroundColor = .lightGray
        headerView.center.x = self.view.center.x

        let label: UILabel = UILabel.init(frame: CGRect(x: 4, y: 5, width: 276, height: 24))
        label.center = headerView.center
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        label.text = "Settings"
        headerView.addSubview(label)
        
        self.tableView.tableHeaderView = headerView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == "GPSSegueIdentifier",
            //... ADD SEGUE CODE
            //let nextCacheVC = segue.destination as? MapViewController{
                //nextCacheVC.notifBool = notifTog
            //add delegate to send notification to GPS screen
            // or just send variable???
        //}
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true)
        } catch {
            print("Sign out error")
        }
    }

    @IBAction func segmentControlFont(_ sender: Any) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let notificationsCell = self.tableView.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath) as! NotificationsTableViewCell
            notificationsCell.textLabel!.text = "Notifications Distance"
            notificationsCell.slider.minimumValue = 0
            notificationsCell.slider.maximumValue = 200
            notificationsCell.slider.value = 25
            print(notificationsCell.slider.value)
            return notificationsCell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
