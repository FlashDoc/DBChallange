//
// ObservableValue.swift
// DBChallange
//
// Created by Sylvia-Kathrin Tanneberger on 2019-03-13.
// Copyright (c) 2019 ttx.WebService();. All rights reserved.
//

import Foundation

class ObservableValue<T> {
	typealias NotificationHandler = ((T) -> Void)

	var value: T {
		didSet {
			self.notify()
		}
	}

	private var observers = [String: NotificationHandler]()

	init(_ value: T) {
		self.value = value
	}

	deinit {
		observers.removeAll()
	}

	func addObserver(_ observer: NSObject, notificationHandler: @escaping NotificationHandler) {
		observers[observer.description] = notificationHandler
	}

	public func addAndNotify(observer: NSObject, notificationHandler: @escaping NotificationHandler) {
		self.addObserver(observer, notificationHandler: notificationHandler)
		self.notify()
	}

	private func notify() {
		observers.forEach({ $0.value(value) })
	}
}
