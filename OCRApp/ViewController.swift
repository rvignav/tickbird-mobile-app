import UIKit
import TesseractOCR
import AVKit
import FirebaseDatabase

class ViewController: UIViewController, G8TesseractDelegate {
    
    @IBOutlet weak var name: UITextField!
    var sendname = ""
    let synthesizer = AVSpeechSynthesizer()
    @IBOutlet weak var pastbutton: UIButton!
    
    @IBOutlet weak var password: UITextField!
    let utterance = AVSpeechUtterance(string: "Hello. This is Tickbird™, an app meant to aid visually impaired people in aurally understanding prescriptions from any doctor. Click at the very top right to access our Privacy Policy. Click near the top to Scan a Prescription. If you want to see your past prescriptions, input your name and password, and then click near the middle. Click near the bottom to Update your Profile.")

    @IBAction func scanPrescriptionClicked(_ sender: Any) {
         synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        let vc = storyboard?.instantiateViewController(identifier: "scan" ) as! ScanViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    @IBAction func updateProfileClicked(_ sender: Any) {
         synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        let vc = storyboard?.instantiateViewController(identifier: "profile" ) as! ProfileViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    @IBAction func privacyPolicyClicked(_ sender: Any) {
         synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        let vc = storyboard?.instantiateViewController(identifier: "privacy" ) as! PrivacyViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    @IBAction func clicked(_ sender: Any) {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        if (name.text == "" || password.text == "") {
            let alert = UIAlertController(title: "Error", message: "Please fill out all fields.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let ref = Database.database().reference()
            let pass = password.text
            var firpass = ""
            var bool = false;
            ref.child(name.text as! String).child("password").observeSingleEvent(of: .value, with: { dataSnapshot in
              firpass = dataSnapshot.value as? String ?? ""
                if firpass == pass {
                    bool = true
                }
                if bool {
                    self.sendname = self.name.text!
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "database") as! DatabaseTableViewController
                    vc.modalPresentationStyle = .fullScreen
                    print("sending: \(self.sendname)")
                    vc.finalName = self.sendname
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.present(vc, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Incorrect username or password", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let next = segue.destination as? DatabaseTableViewController {
            next.finalName = sendname
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.speak(utterance)
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolbar.setItems([doneButton], animated: false)
        
        name.inputAccessoryView = toolbar
        password.inputAccessoryView = toolbar
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
