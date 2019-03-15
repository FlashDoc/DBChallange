//
// ResponseHandler.swift
// DBChallange
//
// Created by Sylvia-Kathrin Tanneberger on 2019-03-13.
// Copyright (c) 2019 ttx.WebService();. All rights reserved.
//

import Foundation

enum ResponseHandler<T, E: Error> {
	case success(T)
	case fault(E)
}
