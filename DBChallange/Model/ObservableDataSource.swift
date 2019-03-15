//
// ObservableDataSource.swift
// DBChallange
//
// Created by Sylvia-Kathrin Tanneberger on 2019-03-14.
// Copyright (c) 2019 ttx.WebService();. All rights reserved.
//

import Foundation

class ObservableDataSource<T>: NSObject {
	var data: ObservableValue<[T]> = ObservableValue([])
}
