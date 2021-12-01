//
//  ArtistCollectionViewModel.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 04/11/2021.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

final class ArtistCollectionViewModel: ObservableObject {
    
    @Published var artist = Artist(art: "", place: "", address: "", headline: "", textPresentation: "")
    
    @Published var retrieveUrlsArray: [String] = []
    
    static let collectionPath = "artist"
    
    private let store = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    func setArtistCollection(id: String, nameDocument: String, document: String) {
        store.collection(ArtistCollectionViewModel.collectionPath).document(id).setData([nameDocument: document]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Single document successfully written!")
            }
        }
    }
    
    func get(documentPath: String) {
        let docRef = store.collection(ArtistCollectionViewModel.collectionPath).document(documentPath)

        docRef.getDocument { (document, error) in
            let result = Result {
              try document?.data(as: Artist.self)
            }
            switch result {
            case .success(let artist):
                if let artist = artist {
                    self.artist = artist
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding user: \(error)")
            }
        }
    }

    func addSingleDocumentToArtistCollection(id: String, nameDocument: String, document: String) {
        store.collection(ArtistCollectionViewModel.collectionPath).document(id).updateData([nameDocument: document]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Single document successfully written!")
            }
        }
    }
    
    func uploadPresentationVideo(url: URL, id: String) {
        let uploadTask = storage.child(Artist.videoPresentationFileName).child(id).putFile(from: url, metadata: nil) { (_, error) in
            if let error = error {
                print("An error has occured - \(error)")
            } else {
                print("Video uploaded successfully")
            }
        }
        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                print(completedUnitCount)
            }
        }
    }
    
    func uploadArtContentVideos(url: URL, id: String, fileName: String, completion: @escaping (Result<String, Error>) -> Void) {
        let uploadTask = storage.child(Artist.artContentFileName).child(id).child(fileName).putFile(from: url, metadata: nil) { (_, error) in
            if let error = error {
                print("An error has occured - \(error)")
            } else {
                completion(.success("Video uploaded successfully"))
            }
        }
        uploadTask.observe(.progress) { (snapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
                print(completedUnitCount)
            }
        }
    }
    
    func uploadArtContentImages(image: UIImage, id: String, fileName: String, completion: @escaping (Result<String, Error>) -> Void) {
        if let imageData = image.jpegData(compressionQuality: 1) {
            storage.child(Artist.artContentFileName).child(id).child(fileName).putData(imageData, metadata: nil) { (_, err) in
                if let err = err {
                    print("An error has occured - \(err.localizedDescription)")
                } else {
                    completion(.success("Image uploaded successfully"))
                }
            }
        }
    }
    
    func downloadArtContentImages(id: String, fileName: String, progress: @escaping (Result<String, Error>) -> Void) {
        
        storage.child("artists_content").child(id).child(fileName).downloadURL { (url, error) in
            if error != nil {
                progress(.failure(error!))
            }
            if let url = url {
                progress(.success("\(url)"))
            }
        }
    }
    
    func downloadProfileImage(id: String, progress: @escaping (Result<String, Error>) -> Void) {
        storage.child("artists_profile_photos").child(id).downloadURL { (url, error) in
            if error != nil {
                progress(.failure(error!))
            }
            if let url = url {
                progress(.success("\(url)"))
            }
        }
    }
    
    func downloadPresentationVideo(id: String, progress: @escaping (Result<String, Error>) -> Void) {
        storage.child("artists_presentation_videos").child(id).downloadURL { (url, error) in
            if error != nil {
                progress(.failure(error!))
            }
            if let url = url {
                progress(.success("\(url)"))
            }
        }
    }
    
    func deleteArtContentMedia(id: String, nbOfPhotos: Int, nbOfVideos: Int) {
        
        for photo in 1..<nbOfPhotos + 1 {
            storage.child("artists_content").child(id).child("image_" + "\(photo)").delete { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                  print("Photos have been deleted.")
                }
            }
        }
        
        for video in 1..<nbOfVideos + 1 {
            storage.child("artists_content").child(id).child("video_" + "\(video)").delete { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                  print("Videos have been deleted.")
                }
            }
        }
    }
}
