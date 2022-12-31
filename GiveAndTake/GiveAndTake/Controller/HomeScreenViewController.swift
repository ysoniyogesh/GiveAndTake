
import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    var donationCellArray : [DonationData] = []
    var complete: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DonationCell", bundle: nil), forCellReuseIdentifier: "ReuseableCell")
        fetchDataFromDatabase()

    } // viewDidLoad ends here
    
    @IBAction func refreshpPessed(_ sender: Any) {
        print("refreshpPressed")
        reloadData()
    }
    
    func fetchDataFromDatabase() {
        donationCellArray = []
        db.collection("Donations").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    
                    for doc in snapshotDocuments { // iterate through each document in snapshotDocuments
                        let Data = doc.data()
                        
                        if let itemTitle = Data["Item Title"] as? String,
                           let itemDescription = Data["Item Description"] as? String,
                           let imageName = Data["Image Name"] as? String {
                            let newDonationCell = DonationData(donationTitle: itemTitle, donationDescription: itemDescription, ImageName: imageName)
                            
                                self.donationCellArray.append(newDonationCell)
                                print(self.donationCellArray)
                               
                        }
                    }
                    var j = 0
                    for i in self.donationCellArray {
                        self.downloadImage(name: i.ImageName, position: j)
                        j += 1
                    }
                }
            }
        }
    }
    
//MARK: downloadImage
    func downloadImage(name: String, position: Int) {
        // Create a reference to the file we want to download
        let storageRef = Storage.storage().reference()
            let imageRef = storageRef.child(name)
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error)
                } else {
                    // Data for images is returned
                    if let image = UIImage(data: data!) {
                        DispatchQueue.main.async {
                            // attach image at position provided during calling of function
                            self.donationCellArray[position].donationImage = image
                        }
                    }
                } // else block ends here.
        } // for loop ends here.
      
    }
    
//___________
    
    func reloadData() {
        
        for i in 0 ..< self.donationCellArray.count {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: i, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        
        return
    }
//___________
 } // Main class ends here

//MARK: UITableViewDataSource
extension HomeScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donationCellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseableCell", for: indexPath) as! DonationCell
        print("reload is called ")
        print(indexPath.row)
        cell.itemTitle.text = donationCellArray[indexPath.row].donationTitle
        cell.descriptionLabel.text = donationCellArray[indexPath.row].donationDescription
        cell.itemImage.image = donationCellArray[indexPath.row].donationImage
        
        return cell
    }
}
