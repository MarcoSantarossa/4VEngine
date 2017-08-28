//
//  UsersListViewModel.swift
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

import Foundation

// Delegate used to bind the UI and the View Model
protocol UsersListViewModelDelegate: class {
	func usersListUpdated()
}

final class UsersListViewModel {

	// Value used in View to know how many table rows to show
	var usersCount: Int {
		return users.count
	}

	private weak var delegate: UsersListViewModelDelegate?
	private weak var navigationDelegate: UsersListNavigationDelegate?

	private let usersListInteractor: UsersListInteractor
	private var users = [User]()

	init(usersListInteractor: UsersListInteractor, navigationDelegate: UsersListNavigationDelegate) {
		self.navigationDelegate = navigationDelegate
		self.usersListInteractor = usersListInteractor

		loadUsers()
	}

	// Asks the interactor the list of users to show in the UI
	private func loadUsers() {
		usersListInteractor.fetchUsers { [unowned self] users in
			self.users = users

			DispatchQueue.main.async {
				// Method used to ask the View to update the table view with the new data
				self.delegate?.usersListUpdated()
			}
		}
	}

	private func user(at indexPath: IndexPath) -> User {
		return users[indexPath.row]
	}

	// Sets the delegate to bind the UI
	func bind(_ delegate: UsersListViewModelDelegate) {
		self.delegate = delegate
	}

	// Method used in View to know which user name to show in the cell
	func userName(at indexPath: IndexPath) -> String {
		let user = self.user(at: indexPath)
		return user.name
	}

	// Method called in View when the user taps a cell detail button
	func userDetailsSelected(at indexPath: IndexPath) {
		let user = self.user(at: indexPath)

		// Method used to notify the router that a user has been selected
		navigationDelegate?.usersListSelected(for: user)
	}
}
