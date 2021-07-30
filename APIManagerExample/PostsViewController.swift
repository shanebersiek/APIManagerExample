//
//  PostsViewController.swift
//  APIManagerExample
//
//  Created by Shane Bersiek on 7/29/21.
//

import UIKit

class PostsViewController: UIViewController {
    
    var cellIndex = 0
    var posts = [Post]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllPosts()
    }
    
    //MARK: functions
    func getAllPosts() {
        APIManager().fetchAllPosts { (result) in
            switch result {
            case .success(let posts):
                self.posts = posts
                self.reloadTableView()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createPost(title: String, body: String) {
        let post = Post(id: nil, title: title, body: body, userId: 69)
        APIManager().createPost(with: post) { (result) in
            switch result {
            case .success(let post):
                self.posts.append(post)
                self.reloadTableView()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    fileprivate func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addNewPost(_ sender: Any) {
        let alert = UIAlertController(title: "new post", message: "please fill out post", preferredStyle: .alert)
        ///add text fields
        alert.addTextField { (textFeild) in
            textFeild.placeholder = "Title"
            textFeild.returnKeyType = .next        }
        alert.addTextField { (textFeild) in
            textFeild.placeholder = "Body"
            textFeild.returnKeyType = .next        }
        ///add buttons
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (_) in
            guard let txtFields  = alert.textFields, txtFields.count == 2 else {
                return
            }
           guard let title = txtFields[0].text, !txtFields.isEmpty, let body = txtFields[1].text, !txtFields.isEmpty else {
                return
            }
            self.createPost(title: title, body: body)
        }))
        present(alert, animated: true, completion: nil)
    }
    
}


extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        cell.titleTxtLabel.text = self.posts[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.row]
        self.cellIndex = indexPath.row
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let postDetailVC = storyBoard.instantiateViewController(withIdentifier: "PostDetailViewController") as! PostDetailViewController
        postDetailVC.post = selectedPost
        postDetailVC.delegate = self
        self.present(postDetailVC, animated:true, completion:nil)
    }
}

extension PostsViewController: PostDetailViewControllerDelegate {
    
    func editedPost(post: Post) {
        self.posts[cellIndex] = post
        self.tableView.reloadData()
    }
    
}
