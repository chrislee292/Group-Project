//
//  SettingsViewController.swift
//  Group Project
//
//  Created by Jayashree Ganesan on 11/17/22.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBAction func notifToggle(_ sender: Any) {
        //var notifTog = false
    }
    
    @IBAction func darkModeToggle(_ sender: Any) {
    }

    @IBAction func segmentControlFont(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if segue.identifier == "GPSSegueIdentifier",
            //... ADD SEGUE CODE
           //let nextCacheVC = segue.destination as? GPSViewController{
            // add delegate to send notification to GPS screen
            // or just send variable???
        }
    
    @IBAction func logOutButton(_ sender: Any) {
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
