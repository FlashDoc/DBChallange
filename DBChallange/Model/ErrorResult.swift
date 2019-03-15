//
// ErrorResult.swift
// DBChallange
//
// Created by Sylvia-Kathrin Tanneberger on 2019-03-13.
// Copyright (c) 2019 ttx.WebService();. All rights reserved.
//

import Foundation

enum ErrorResult: Error {
	case network(code: Int, description: String)
	case data(code: Int, description: String)
	case json(code: Int, description: String)
}
