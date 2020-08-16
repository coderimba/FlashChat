//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = K.appName //can set title in Main.storyboard instead (under Chat View Controller Scene, select 'Navigation Item' -> under Attributes, put "⚡️FlashChat" in 'Title')
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            //the 3 lines above are continuous
                
            self.messages = [] //clear dummy array
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                //tap into querySnapshot object and get hold of the data that's contained inside
                if let snapshotDocuments = querySnapshot?.documents {                    
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody) //create a new Message
                            self.messages.append(newMessage) //add new Message to array of messages
                            
                            //fetching the documents in the background (since the above chunk of code is all in a closure)
                            DispatchQueue.main.async { //when we are ready to update our Table View with the new messages, we have to fetch the main thread (which is the process happening in the foreground). It is on that thread that we update data (line of code below)
                                self.tableView.reloadData() //this taps into the tableView and triggers the data source methods again
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0) //row: get hold of last item in messages array. section: we only have one section, so set it as 0
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false) //scrolls the row of interest to the top of the visible table view without an animation (goes straight there)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if messageTextfield.text == "" { //this ensures that a blank message cannot be sent
            return
        }
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender, K.FStore.bodyField: messageBody, K.FStore.dateField: Date().timeIntervalSince1970]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data.")
                    
                    DispatchQueue.main.async {
                        self.messageTextfield.text = "" //Textfield empties when we send our message
                    }
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
          try Auth.auth().signOut()
          navigationController?.popToRootViewController(animated: true)
            //Pops all the VCs on the stack except the root VC and updates the display
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
        
    }
    
}

extension ChatViewController: UITableViewDataSource { //Data Source is responsible for populating the tableView (how many cells the tableView needs and which cells to put in the tableView)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
        //returns number of rows in Table View
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //indexPath is the position so this method is asking for a UITableViewCell to be displayed in each row of our tableView
        //this method will get called for as many rows as you have in your Table View
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell //Returns a reusable table-view cell object for the specified reuse identifier and adds it to the table
        cell.label.text = message.body
        
        //This is a message from the current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true //hide leftImageView (You)
            cell.rightImageView.isHidden = false //show rightImageView (Me)
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else {
           //This is a message from another sender
            cell.leftImageView.isHidden = false //show leftImageView (You)
            cell.rightImageView.isHidden = true //hide rightImageView (Me)
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        return cell
    }
    
}
