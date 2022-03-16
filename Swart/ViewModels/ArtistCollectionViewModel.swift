//
//  ArtistCollectionViewModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 04/11/2021.
//

import SwiftUI

final class ArtistCollectionViewModel: ObservableObject {
    
    @Published var artist = Artist(id: "", art: "", place: "", address: "", department: "", headline: "", textPresentation: "", profilePhoto: "", presentationVideo: "", artContentMedia: [], blockedDates: [], pendingRequest: [], comingRequest: [], previousRequest: [])
    @Published var artistsResult: [Artist] = []
    @Published var urlArrayForArtContent: [String] = []
    
    static let storagePathArtistProfilePhoto = "artists_profile_photos"
    static let storagePathArtistPresentationVideo = "artists_presentation_videos"
    static let storagePathArtistContent = "artists_content"
    static let collectionPath = "artist"
    private let artistCollectionRepository = ArtistCollectionRepository()
    
    func setArtistCollection(documentId: String, nameDocument: String, document: String, completion: @escaping (() -> Void)) {
        artistCollectionRepository.setArtistCollection(collectionPath: ArtistCollectionViewModel.collectionPath, documentId: documentId, nameDocument: nameDocument, document: document)
        completion()
    }
    
    func addEmptyDataToArtistCollection(documentId: String) {
        self.addSingleArrayToArtistCollection(documentId: documentId, nameDocument: "blockedDates", array: [])
        self.addSingleArrayToArtistCollection(documentId: documentId, nameDocument: "pendingRequest", array: [])
        self.addSingleArrayToArtistCollection(documentId: documentId, nameDocument: "comingRequest", array: [])
        self.addSingleArrayToArtistCollection(documentId: documentId, nameDocument: "previousRequest", array: [])
    }
    
    func get(documentId: String, completion: (() -> Void)? = nil) {
        artistCollectionRepository.get(collectionPath: ArtistCollectionViewModel.collectionPath, documentId: documentId) { artist in
            self.artist = artist
            completion?()
        }
    }
    
    func removeUnfinishedArtistFromDatabase(documentId: String) {
        artistCollectionRepository.removeUnfinishedArtistFromDatabase(collectionPath: ArtistCollectionViewModel.collectionPath, documentId: documentId)
    }
    
    func isAlreadyAnArtist(documentId: String, completion: @escaping (Bool) -> Void) {
        artistCollectionRepository.isAlreadyAnArtist(collectionPath: ArtistCollectionViewModel.collectionPath, documentId: documentId, completion: completion)
    }

    func addSingleDocumentToArtistCollection(documentId: String, nameDocument: String, document: String, completion: (() -> Void)? = nil) {
        artistCollectionRepository.addSingleDocumentToArtistCollection(collectionPath: ArtistCollectionViewModel.collectionPath, documentId: documentId, nameDocument: nameDocument, document: document)
        completion?()
    }
    
    func addSingleArrayToArtistCollection(documentId: String, nameDocument: String, array: [String], completion: (() -> Void)? = nil) {
        artistCollectionRepository.addSingleArrayToArtistCollection(collectionPath: ArtistCollectionViewModel.collectionPath, documentId: documentId, nameDocument: nameDocument, array: array)
        completion?()
    }
    
    func addAddressInformationToDatabase(documentId: String, documentAddress: String, documentDepartment: String, completion: @escaping (() -> Void)) {
        self.addSingleDocumentToArtistCollection(documentId: documentId, nameDocument: "address", document: documentAddress)
        self.addSingleDocumentToArtistCollection(documentId: documentId, nameDocument: "department", document: documentDepartment)
        completion()
    }
    
    func uploadArtContentVideosToDatabase(localFile: URL, documentId: String, fileName: String, completion: @escaping (Result<String, Error>) -> Void) {
        artistCollectionRepository.uploadArtContentVideosToDatabase(storagePath: ArtistCollectionViewModel.storagePathArtistContent, documentId: documentId, localFile: localFile, fileName: fileName, completion: completion)
    }
    
    func uploadVideoPresentationToDatabase(localFile: URL, documentId: String, nameDocument: String, completion: @escaping (Result<String, Error>) -> Void) {
        artistCollectionRepository.uploadVideoPresentationToDatabase(storagePath: ArtistCollectionViewModel.storagePathArtistPresentationVideo, collectionPath: ArtistCollectionViewModel.collectionPath, documentId: documentId, localFile: localFile, nameDocument: nameDocument, completion: completion)
    }
    
    func uploadProfilePhotoToDatabase(image: UIImage, documentId: String, nameDocument: String, completion: @escaping (Result<String, Error>) -> Void) {
        artistCollectionRepository.uploadProfilePhotoToDatabase(storagePath: ArtistCollectionViewModel.storagePathArtistProfilePhoto, collectionPath: ArtistCollectionViewModel.collectionPath, documentId: documentId, image: image, nameDocument: nameDocument, completion: completion)
    }
    
    func uploadArtContentImagesToDatabase(image: UIImage, documentId: String, fileName: String, completion: @escaping (Result<String, Error>) -> Void) {
        artistCollectionRepository.uploadArtContentImagesToDatabase(storagePath: ArtistCollectionViewModel.storagePathArtistContent, documentId: documentId, fileName: fileName, image: image, completion: completion)
    }
    
    func uploadArtContentMediaUrls(documentId: String, completion: @escaping (() -> Void)) {
        obtainArtContentMediaUrls {
            self.addSingleArrayToArtistCollection(documentId: documentId, nameDocument: "artContentMedia", array: self.urlArrayForArtContent) {
                self.get(documentId: documentId) {
                    completion()
                }
            }
        }
    }
    
    private func obtainArtContentMediaUrls(completion: @escaping (() -> Void)) {
        var orderingArray: [String] = []
        for url in self.urlArrayForArtContent {
            if let range = url.range(of: "image_") {
                let cut = url[range.upperBound...]
                let index = cut.prefix(1)
                orderingArray.append(String(index))
            } else if let range = url.range(of: "video_") {
                let cut = url[range.upperBound...]
                let index = cut.prefix(1)
                orderingArray.append(String(index))
            }
        }
        let combined = zip(orderingArray, self.urlArrayForArtContent).sorted { $0.0 < $1.0 }
        orderingArray = combined.map {$0.0}
        self.urlArrayForArtContent = combined.map {$0.1}
        completion()
    }
    
    func deleteArtContentMediaFromStorage(documentId: String, completion: @escaping (() -> Void)) {
        let group = DispatchGroup()
        var index = 0
        
        for url in artist.artContentMedia {
            group.enter()
            if url.contains("image") {
                artistCollectionRepository.deleteArtContentMediaFromStorage(storagePath: ArtistCollectionViewModel.storagePathArtistContent, documentId: documentId, fileName: "image_" + "\(index)", message: "Photos have been deleted.") {
                    group.leave()
                }
            } else {
                artistCollectionRepository.deleteArtContentMediaFromStorage(storagePath: ArtistCollectionViewModel.storagePathArtistContent, documentId: documentId, fileName: "video_" + "\(index)", message: "Videos have been deleted.") {
                    group.leave()
                }
            }
            index += 1
        }
        group.notify(queue: .main) {
            completion()
        }
    }
    
    func removeArtContentMediaFromDatabase(documentId: String, completion: @escaping (() -> Void)) {
        artistCollectionRepository.removeArtContentMediaFromDatabase(collectionPath: ArtistCollectionViewModel.collectionPath, documentId: documentId, fieldName: "artContentMedia")
        completion()
    }
    
    func insertElementInArray(documentId: String, titleField: String, element: String, completion: (() -> Void)? = nil) {
        artistCollectionRepository.insertElementInArray(collectionPath: ArtistCollectionViewModel.collectionPath, documentId: documentId, titleField: titleField, element: element)
        completion?()
    }
    
    func removeElementFromArray(documentId: String, titleField: String, element: String, completion: (() -> Void)? = nil) {
        artistCollectionRepository.removeElementFromArray(collectionPath: ArtistCollectionViewModel.collectionPath, documentId: documentId, titleField: titleField, element: element)
        completion?()
    }
    
    func researchFilteredArtists(art: String, department: [String], place: String, completion: @escaping (() -> Void)) {
        if art == "" {
            if place == "Anywhere suits you" {
                artistCollectionRepository.researchArtists(collectionPath: ArtistCollectionViewModel.collectionPath, department: department) { artist in
                    self.artistsResult.append(artist)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    completion()
                }
            } else {
                artistCollectionRepository.researchArtists(collectionPath: ArtistCollectionViewModel.collectionPath, department: department, place: place) { artist in
                    self.artistsResult.append(artist)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    completion()
                }
            }
        } else {
            if place == "Anywhere suits you" {
                artistCollectionRepository.researchArtists(collectionPath: ArtistCollectionViewModel.collectionPath, art: art, department: department) { artist in
                    self.artistsResult.append(artist)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    completion()
                }
            } else {
                artistCollectionRepository.researchArtists(collectionPath: ArtistCollectionViewModel.collectionPath, art: art, department: department, place: place) { artist in
                    self.artistsResult.append(artist)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    completion()
                }
            }
        }
    }
    
    func researchFilteredArtistsWithGivenDate(art: String, department: [String], place: String, selectedDate: String, completion: @escaping (() -> Void)) {
        let group = DispatchGroup()
        
        self.researchFilteredArtists(art: art, department: department, place: place) {
            for artist in self.artistsResult where artist.blockedDates.contains(selectedDate) {
                group.enter()
                if let index = self.artistsResult.firstIndex(of: artist) {
                    self.artistsResult.remove(at: index)
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    completion()
                }
            }
        }
    }
    
    func uploadArtContentMediaToStorage(mediaItems: [Media], documentId: String, completion: @escaping ((Double) -> Void), completionHandler: @escaping (() -> Void)) {
        let firstGroup = DispatchGroup()
        self.urlArrayForArtContent.removeAll()
        for (index, element) in mediaItems.enumerated() {
            if element.mediaType == .video {
                firstGroup.enter()
                self.uploadArtContentVideosToDatabase(localFile: element.url ?? URL(fileURLWithPath: ""), documentId: documentId, fileName: "video_" + "\(index)") { result in
                    switch result {
                    case .success(let url):
                        self.urlArrayForArtContent.append(url)
                        completion(1 / Double(mediaItems.count))
                        firstGroup.leave()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            } else {
                firstGroup.enter()
                self.uploadArtContentImagesToDatabase(image: element.photo ?? UIImage(), documentId: documentId, fileName: "image_" + "\(index)") { result in
                    switch result {
                    case .success(let url):
                        self.urlArrayForArtContent.append(url)
                        completion(1 / Double(mediaItems.count))
                        firstGroup.leave()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
        firstGroup.notify(queue: .main) {
            self.uploadArtContentMediaUrls(documentId: documentId) {
                completionHandler()
            }
        }
    }
}
