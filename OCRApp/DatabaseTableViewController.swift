import UIKit
import AVKit
import FirebaseDatabase

var vals = [String]()

class DatabaseTableViewController: UIViewController { // UITableViewDelegate, UITableViewDataSource

    var list = [String]()
    
    @IBOutlet var tableView: UITableView!
    
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    
    let synthesizer = AVSpeechSynthesizer()
    let utterance = AVSpeechUtterance(string: "This is all your past prescriptions. You are either here because you just scanned a prescription or you are looking for your previous ones. They will show up alphabetically. Use accessbilitty to find the buttons for each prescription. Once you click it, it will read your prescription out loud to you, so make sure you follow the instructions from your doctor. ")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       // synthesizer.speak(utterance)
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        ref = Database.database().reference()
        databaseHandle = ref?.child("Prescriptions").observe(.childAdded, with: { (snapshot) in
           let post = snapshot.key as? String
            if let actualPost = post {
                self.list.append(actualPost)
                self.tableView.reloadData()
            }
            let p = snapshot.value as? String
            if let act = p {
                vals.append(act)
                self.tableView.reloadData()
            }
            
        })
        
        print(list)
    }
    override func didReceiveMemoryWarning() {
        let synthesizer = AVSpeechSynthesizer() 
        let utterance = AVSpeechUtterance(string: "This is your profile. Please enter your name, your physician's name, your conditions, and your age in the fields. They appear in that order. If you are lost, click in the general area and Accessibility will help you find it. ")
        super.didReceiveMemoryWarning()
        
    }
    
    
    
}

extension DatabaseTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (list.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NewTableViewCell
        
        
        //  UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        //cell.backgroundColor = UIColor(red: 23, green: 22, blue: 60, alpha: 0)
        //cell?.textLabel?.font = UIFont(name: "Futura Medium", size: 20.0)
        //cell.textLabel?.textColor = UIColor(red: 244, green: 197, blue: 102, alpha: 255)
        //cell.textLabel?.backgroundColor = .none
        
        cell?.lblName.text = list[indexPath.row]
        cell?.cellDelegate = self
        cell?.index = indexPath
        
        return(cell!)
    }
}

extension DatabaseTableViewController: TableViewNew {
    func onClickCell(index: Int) {
        let synthesize = AVSpeechSynthesizer()
        let utt = AVSpeechUtterance(string: "Prescription for \(list[index]): \(vals[index])")
        synthesize.speak(utt)
    }
}

