//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

import UIKit

class ChatViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var messageTextfield: UITextField!
  
  let db = Firestore.firestore()
  
  
  //MARK: - 원천 데이터
  
  private var messages: [Message] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "FlashChat"
    self.navigationItem.hidesBackButton = true
    
    self.tableView.dataSource = self
    self.tableView.register(
      UINib(nibName: K.cellNibName, bundle: nil),
      forCellReuseIdentifier: K.cellIdentifier
    )
    self.loadMessages()
  }
  
  
  @IBAction func logout(_ sender: UIBarButtonItem) {
    do {
      try Auth.auth().signOut()
      self.navigationController?.popToRootViewController(animated: true)
    } catch let error as NSError {
      print(error)
    }
  }
  
  
  @IBAction func sendPressed(_ sender: UIButton) {
    guard let messageBody = messageTextfield.text else { return }
    guard messageBody.isEmpty == false else { return }
    guard let messageSender = Auth.auth().currentUser?.email else { return }
    
    self.db.collection(K.FStore.collectionName).addDocument(data: [
      K.FStore.senderField: messageSender,
      K.FStore.bodyField: messageBody
    ]) { error in
      guard let error else { return }
      print(error)
    }
    
    //    self.db.collection(K.FStore.collectionName).addDocument(data: [
    //      K.FStore.senderField: messageSender,
    //      K.FStore.bodyField: messageBody
    //    ])
  }
  
  private func loadMessages () {
    self.db.collection(K.FStore.collectionName).getDocuments { querySnapShot, error in
      if let snapShotDocument = querySnapShot?.documents {
        for doc in snapShotDocument {
          let data = doc.data()
          
          if let sender = data[K.FStore.senderField] as? String,
             let body = data[K.FStore.bodyField] as? String {
            let message = Message(sender: sender, body: body)
            self.messages.append(message)
          }
        }
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
  }
}


extension ChatViewController: UITableViewDataSource {
  
  //몇개의 셀을 보여줄지
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.messages.count
  }
  
  //각 셀
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //타입 캐스팅
    guard let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as? MessageCell else { return UITableViewCell() }
    //cell.textLabel?.text = "hi"
    cell.label.text = self.messages[indexPath.row].body
    return cell
  }
}
