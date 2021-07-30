//
//  PostDetailViewController.swift
//  APIManagerExample
//
//  Created by Shane Bersiek on 7/29/21.
//

import UIKit

protocol PostDetailViewControllerDelegate: class {
    func editedPost(post: Post)
}

class PostDetailViewController: UIViewController {

    var post: Post!
    weak var delegate: PostDetailViewControllerDelegate?
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var bodyTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        titleTextLabel.text = post.title
        bodyTextField.text = post.body
    }
 
    @IBAction func editPostBtnTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Edit Post", message: "Please fill Out Post", preferredStyle: .alert)
        ///add text fields
        alert.addTextField { (textFeild) in
            textFeild.placeholder = "Title"
            textFeild.returnKeyType = .next        }
        alert.addTextField { (textFeild) in
            textFeild.placeholder = "Body"
            textFeild.returnKeyType = .next        }
        ///add buttons
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [self] (_) in
            guard let txtFields  = alert.textFields, txtFields.count == 2 else {
                return
            }
           guard let title = txtFields[0].text, !txtFields.isEmpty, let body = txtFields[1].text, !txtFields.isEmpty else {
                return
            }
            titleTextLabel.text = title
            bodyTextField.text = body
            self.editPost(title: title, body: body)
        }))
       
        present(alert, animated: true, completion: nil)
    }
    
    func editPost(title: String, body: String) {
        let params = ["title": title, "body": body]
        APIManager().patchPost(id: self.post.id!, params: params) { (result) in
            switch result {
            case .success(let post):
                DispatchQueue.main.async {
                    self.delegate?.editedPost(post: post)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
