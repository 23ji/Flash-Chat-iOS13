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
    self.tableView.delegate = self
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
      K.FStore.bodyField: messageBody,
      K.FStore.dateField: Date().timeIntervalSince1970
    ]) { [weak self] error in
      if error == nil {
        self?.messageTextfield.text = ""
      }
      print(error)
    }
    
    //    self.db.collection(K.FStore.collectionName).addDocument(data: [
    //      K.FStore.senderField: messageSender,
    //      K.FStore.bodyField: messageBody
    //    ])
  }
  
  private func loadMessages () {
    
    self.db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { [weak self] querySnapShot, error in
      guard let self else { return }
      
      self.messages = []
      
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
          //스크롤 위로 올리기
          self.tableView.scrollToRow(
            at: .init(row: self.messages.count - 1, section: 0),
            at: .top,
            animated: true
          )
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
    guard let email = Auth.auth().currentUser?.email else { return UITableViewCell() }
    
    //prepareForReuse에서
    //    cell.leftImageView.isHidden = false
    //    cell.rightImageView.isHidden = false
    
    //    if self.messages[indexPath.row].sender == email {
    //      cell.leftImageView.isHidden = true
    //      cell.messageBubble.backgroundColor = UIColor(named: "BrandPurple")
    //      cell.label.textColor = UIColor(named: "BrandLightPurple")
    //    } else {
    //      cell.rightImageView.isHidden = true
    //      cell.messageBubble.backgroundColor = UIColor(named: "BrandLightPurple")
    //      cell.label.textColor = UIColor(named: "BrandPurple")
    //    }
    
    // 메세지 보낸 사람 == 현재 로그인 한 사람  인지
    // 메세지 보낸 사람 == 현재 로그인 한 사람이면 왼쪽 이미지 가리기
    //cell.leftImageView.isHidden = (self.messages[indexPath.row].sender == email ? true : false)
    //    cell.leftImageView.isHidden = (self.messages[indexPath.row].sender == email)
    //      ? true
    //      : false
    
    // 삼항 연산자 사용
    cell.leftImageView.isHidden = (self.messages[indexPath.row].sender == email)
    cell.rightImageView.isHidden = (self.messages[indexPath.row].sender != email)
    
    cell.messageBubble.backgroundColor = (self.messages[indexPath.row].sender == email)
      ? UIColor(named: "BrandPurple")
      : UIColor(named: "BrandLightPurple")
    
    cell.label.textColor = (self.messages[indexPath.row].sender == email)
      ? UIColor(named: "BrandLightPurple")
      : UIColor(named: "BrandPurple")
    
    
    
    cell.label.text = self.messages[indexPath.row].body
    return cell
  }
}

extension ChatViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //디버깅 검색 팁
    print("ChatViewController didSelectRowAt", indexPath)
  }
}

extension ChatViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //print("scroll")
  }
}
