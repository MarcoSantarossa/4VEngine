//
//  UsersRouter.swift
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

// Delegate used to navigate from users list to user details
protocol UsersListNavigationDelegate: class {
    func usersListSelected(for user: User)
}

// Delegate used to close the user details
protocol UserDetailsNavigationDelegate: class {
    func userDetailsCloseDidTap()
}

final class UsersRouter {

	// Parent view controller to add the components
    fileprivate let parentViewController: UIViewController

	// Dictionary of presenters used
    fileprivate var presenters = [String: ViewPresenter]()
    
    init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
    }
}

extension UsersRouter: Router {
	// Shows first component, the users list
	func showInitial() {
		let usersListPresenter = UsersListViewPresenter(navigationDelegate: self)
		usersListPresenter.present(in: parentViewController)

		presenters["UsersList"] = usersListPresenter
	}

	// Closes the router removing all its components
	func close() {
		presenters.keys.forEach { [unowned self] in
			self.removePresenter(for: $0)
		}
	}

	fileprivate func removePresenter(for key: String) {
		let userDetailsPresenter = presenters[key]
		userDetailsPresenter?.remove()

		presenters[key] = nil
	}
}

extension UsersRouter: UsersListNavigationDelegate {
    func usersListSelected(for user: User) {
        let userDetailsPresenter = UserDetailsViewPresenter(user: user, navigationDelegate: self)
        userDetailsPresenter.present(in: parentViewController)
        
        presenters["UserDetails"] = userDetailsPresenter
    }
}

extension UsersRouter: UserDetailsNavigationDelegate {
    func userDetailsCloseDidTap() {
		// Removes user details components from the parent view controller
		removePresenter(for: "UserDetails")
	}
}
