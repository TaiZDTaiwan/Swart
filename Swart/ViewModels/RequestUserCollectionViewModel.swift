//
//  RequestUserCollectionViewModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 07/02/2022.
//

import SwiftUI

final class RequestUserCollectionViewModel: ObservableObject {
    
    @Published var pendingRequests: [RequestUser] = []
    @Published var comingRequests: [RequestUser] = []
    @Published var toReorderComingRequests: [RequestUser] = []
    @Published var previousRequests: [RequestUser] = []
    @Published var requestReference = ""
    @Published var dates: [String] = []

    static let collectionPath = "requestUser"
    private let requestUsertCollectionRepository = RequestUserCollectionRepository()
    private let userCollectionViewModel = UserCollectionViewModel()
    
    func addRequestToUser(request: RequestUser, completion: @escaping (() -> Void)) {
        requestUsertCollectionRepository.addRequestToUser(collectionPath: RequestUserCollectionViewModel.collectionPath, request: request) { documentId in
            self.requestReference = documentId
            completion()
        }
    }
    
    func getRequests(pendingRequest: [String], comingRequest: [String], previousRequest: [String], documentId: String, completion: @escaping (() -> Void)) {
        let group = DispatchGroup()
        self.getComingRequestToReorder(comingRequest: comingRequest) {
            self.determineComingRequestDates {
                for date in self.dates {
                    self.isRequestPassed(bookingDate: date) { passed in
                        if passed {
                            if let index = self.dates.firstIndex(of: date) {
                                group.enter()
                                self.orderRequestsInDatabase(documentId: documentId, titleFieldToInsert: "previousRequest", titleFieldToRemove: "comingRequest", element: self.toReorderComingRequests[index].requestId) {
                                    group.leave()
                                }
                            }
                        }
                    }
                }
                group.notify(queue: .main) {
                    completion()
                }
            }
        }
    }
    
    func retrieveRequests(pendingRequest: [String], comingRequest: [String], previousRequest: [String]) {
        
        for path in pendingRequest {
            self.getPendingRequest(documentId: path)
        }
        
        for path in comingRequest {
            self.getComingRequest(documentId: path)
        }

        for path in previousRequest {
            self.getPreviousRequest(documentId: path)
        }
    }
    
    private func getPendingRequest(documentId: String) {
        requestUsertCollectionRepository.getRequest(collectionPath: RequestUserCollectionViewModel.collectionPath, documentId: documentId) { request in
            self.pendingRequests.append(request)
        }
    }
    
    private func getComingRequest(documentId: String) {
        requestUsertCollectionRepository.getRequest(collectionPath: RequestUserCollectionViewModel.collectionPath, documentId: documentId) { request in
            self.comingRequests.append(request)
        }
    }
    
    private func getComingRequestToReorder(comingRequest: [String], completion: @escaping (() -> Void)) {
        let group = DispatchGroup()
        
        for path in comingRequest {
            group.enter()
            requestUsertCollectionRepository.getRequest(collectionPath: RequestUserCollectionViewModel.collectionPath, documentId: path) { request in
                self.toReorderComingRequests.append(request)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion()
        }
    }
    
    private func getPreviousRequest(documentId: String) {
        requestUsertCollectionRepository.getRequest(collectionPath: RequestUserCollectionViewModel.collectionPath, documentId: documentId) { request in
            self.previousRequests.append(request)
        }
    }
    
    private func determineComingRequestDates(completion: @escaping (() -> Void)) {
        let group = DispatchGroup()
        
        for request in self.toReorderComingRequests {
            group.enter()
            self.addDates(date: request.date) {
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            completion()
        }
    }
    
    private func addDates(date: String, completion: @escaping (() -> Void)) {
        self.dates.append(date)
        completion()
    }
    
    func orderRequestsInDatabase(documentId: String, titleFieldToInsert: String, titleFieldToRemove: String, element: String, completion: @escaping (() -> Void)) {
        self.userCollectionViewModel.insertElementInArray(documentId: documentId, titleField: titleFieldToInsert, element: element) {
            self.userCollectionViewModel.removeElementFromArray(documentId: documentId, titleField: titleFieldToRemove, element: element) {
                completion()
            }
        }
    }
    
    private func isRequestPassed(bookingDate: String, completion: @escaping (Bool) -> Void) {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let stringCurrentDate = dateFormatter.string(from: date)
        let currentDate = dateFormatter.date(from: stringCurrentDate)
        if let currentDate = currentDate {
            if let bookingDate = dateFormatter.date(from: bookingDate) {
                if currentDate > bookingDate {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func addIdToRequest() {
        requestUsertCollectionRepository.addIdToRequest(collectionPath: RequestUserCollectionViewModel.collectionPath, documentId: self.requestReference)
    }
    
    func acceptPendingRequest(documentId: String, completion: @escaping (() -> Void)) {
        requestUsertCollectionRepository.acceptPendingRequest(collectionPath: RequestUserCollectionViewModel.collectionPath, documentId: documentId)
        completion()
    }
}
