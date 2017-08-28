//
//  UsersListTableViewController.swift
//
//  4VEngine
//
//  Copyright (c) 2017 Marco Santarossa (https://marcosantadev.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

class UsersListTableViewController: UITableViewController {

	// The view model used for the binding
	private unowned let viewModel: UsersListViewModel

	init(viewModel: UsersListViewModel) {
		self.viewModel = viewModel

		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let nib = UINib.init(nibName: "UsersListTableViewCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: "Cell")

		// Binds View and View Model
		viewModel.bind(self)
	}

	// MARK: - Table view data source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// Asks the View Model how many users are available
		return viewModel.usersCount
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

		// If it's the custom cell, configure it
		if let usersListCell = cell as? UsersListTableViewCell {
			// Asks the View Model the user name for a specific index path
			let userName = viewModel.userName(at: indexPath)
			// Sets the user name
			usersListCell.configure(userName: userName)
		}

		return cell
	}

	override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
		// Notifies the View Model that a detail button has been tapped
		viewModel.userDetailsSelected(at: indexPath)
	}
}

extension UsersListTableViewController: UsersListViewModelDelegate {
	// Method called by View Model when the user data is changed
	func usersListUpdated() {
		tableView.reloadData()
	}
}
