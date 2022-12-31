
import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProfileData()
        print("fetchProfileData called")
        
    }
    
    func fetchProfileData() {
        let user = Auth.auth().currentUser
         if let user = user {
          let uid = user.uid
             
    // Get document from firestore with documentID = userID. as i have save document in such a way.
             let docRef = db.collection("users").document(uid)

             docRef.getDocument { (document, error) in
                  if let document = document, document.exists {
                     let dataDescription = document.data()
                     
                     if let fname =  dataDescription!["First Name"] as? String,
                        let lname = dataDescription!["Last Name"] as? String,
                        let pin = dataDescription!["Pin Code"] as? String,
                        let state = dataDescription!["State"] as? String,
                        let email = dataDescription!["email Id"] as? String {
                         
                         self.nameLabel.text = "\(fname) \(lname)"
                         self.emailLabel.text = email
                         self.phoneNumberLabel.text = pin
                         self.stateLabel.text = state
                         
                     }
                 } else {
                     print("Document does not exist")
                 }
             }
        }
    } // fetchProfileData ends here
}  // Main class ends here
