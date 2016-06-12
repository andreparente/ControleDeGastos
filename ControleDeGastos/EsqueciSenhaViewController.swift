//
//  EsqueciSenhaViewController.swift
//  ControleDeGastos
//
//  Created by Felipe Viberti on 6/12/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit
import MessageUI
class EsqueciSenhaViewController: UIViewController,MFMailComposeViewControllerDelegate{
    @IBOutlet weak var erromail: UILabel!
    @IBOutlet weak var mail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = corAzul
        erromail.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  /*  @IBAction func confirma(sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["\(mail.text!)"])
        mailComposerVC.setSubject("Recupere sua senha")
        mailComposerVC.setMessageBody("Sua senha é 123", isHTML: false)
        
        return mailComposerVC
    }
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }

    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
