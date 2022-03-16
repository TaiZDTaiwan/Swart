//
//  RequestArtistCollectionViewModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 07/02/2022.
//

import SwiftUI

final class RequestArtistCollectionViewModel: ObservableObject {
    
    @Published var pendingRequests: [RequestArtist] = []
    @Published var comingRequests: [RequestArtist] = []
    @Published var toReorderComingRequests: [RequestArtist] = []
    @Published var previousRequests: [RequestArtist] = []
    @Published var requestReference = ""
    @Published var dates: [String] = []

    static let collectionPath = "requestArtist"
    private let requestArtistCollectionRepository = RequestArtistCollectionRepository()
    private let artistCollectionViewModel = ArtistCollectionViewModel()
    
    func addRequestToArtist(request: RequestArtist, completion: @escaping (() -> Void)) {
        requestArtistCollectionRepository.addRequestToArtist(collectionPath: RequestArtistCollectionViewModel.collectionPath, request: request) { documentId in
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
    
    func retrieveRequests(pendingRequest: [String], comingRequest: [String], previousRequest: [String], completion: (() -> Void)? = nil) {
        
        let group = DispatchGroup()
             
        for path in pendingRequest {
            group.enter()
            self.getPendingRequest(documentId: path) {
                group.leave()
            }
        }
        
        for path in comingRequest {
            group.enter()
            self.getComingRequest(documentId: path) {
                group.leave()
            }
        }

        for path in previousRequest {
            group.enter()
            self.getPreviousRequest(documentId: path) {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion?()
        }
    }
    
    private func getPendingRequest(documentId: String, completion: @escaping (() -> Void)) {
        requestArtistCollectionRepository.getRequest(collectionPath: RequestArtistCollectionViewModel.collectionPath, documentId: documentId) { request in
            self.pendingRequests.append(request)
            completion()
        }
    }
    
    private func getComingRequest(documentId: String, completion: @escaping (() -> Void)) {
        requestArtistCollectionRepository.getRequest(collectionPath: RequestArtistCollectionViewModel.collectionPath, documentId: documentId) { request in
            self.comingRequests.append(request)
            completion()
        }
    }
    
    private func getComingRequestToReorder(comingRequest: [String], completion: @escaping (() -> Void)) {
        let group = DispatchGroup()
        
        for path in comingRequest {
            group.enter()
            requestArtistCollectionRepository.getRequest(collectionPath: RequestArtistCollectionViewModel.collectionPath, documentId: path) { request in
                self.toReorderComingRequests.append(request)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion()
        }
    }
    
    private func getPreviousRequest(documentId: String, completion: @escaping (() -> Void)) {
        requestArtistCollectionRepository.getRequest(collectionPath: RequestArtistCollectionViewModel.collectionPath, documentId: documentId) { request in
            self.previousRequests.append(request)
            completion()
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
        self.artistCollectionViewModel.insertElementInArray(documentId: documentId, titleField: titleFieldToInsert, element: element) {
            self.artistCollectionViewModel.removeElementFromArray(documentId: documentId, titleField: titleFieldToRemove, element: element) {
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
    
    func addIdsToRequest(requestIdUser: String) {
        requestArtistCollectionRepository.addIdToRequest(collectionPath: RequestArtistCollectionViewModel.collectionPath, documentId: self.requestReference)
        requestArtistCollectionRepository.addUserIdToRequest(collectionPath: RequestArtistCollectionViewModel.collectionPath, documentId: self.requestReference, requestIdUser: requestIdUser)
    }
    
    func acceptPendingRequest(documentId: String, completion: @escaping (() -> Void)) {
        requestArtistCollectionRepository.acceptPendingRequest(collectionPath: RequestArtistCollectionViewModel.collectionPath, documentId: documentId)
        completion()
    }
}
