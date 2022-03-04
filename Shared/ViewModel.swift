//
//  ViewModel.swift
//  InsertionSortGifs
//
//  Created by Borna Libertines on 16/02/22.
//
/*
 
 */
import Foundation
/*
 
 func linearSearch<T: Equatable>(_ a: [T], _ key: T) -> Int? {
     for i in 0 ..< a.count {
         if a[i] == key {
             return i
         }
     }
     return nil
 }
 
 */
class ViewModel: ObservableObject {
   
   @Published var gifs = [GifCollectionViewCellViewModel]()
   @Published var searchgif = [GifCollectionViewCellViewModel]()
   @Published var gifIndex:Int = 0
   // MARK:  Initializer Dependency injestion
   let appiCall: ApiLoader?
   
   init(appiCall: ApiLoader = ApiLoader()){
      self.appiCall = appiCall
   }
   
   //gifs.firstIndex(of: 43)
   func linearSearch<T: Equatable>(_ array: [T], _ object: T) async -> Int? {
     for (index, obj) in array.enumerated() where obj == object {
       return index
     }
     return nil
   }
   
   func binarySearch<T: Comparable>(array: [T], key: T) -> Int? {
     var lowerBound = 0
     var upperBound = array.count
     
     while lowerBound < upperBound {
       let midIndex = lowerBound + (upperBound - lowerBound) / 2
       if array[midIndex] == key {
         return midIndex
       } else if array[midIndex] < key {
         lowerBound = midIndex + 1
       } else {
         upperBound = midIndex
       }
     }
     
     return nil
   }
   func splitArray<T: Comparable>(array: [T], key: Int) -> [T] {
      return Array(array[key..<array.count])
   }

   @MainActor public func linearS(k: GifCollectionViewCellViewModel) async {
      debugPrint(binarySearch(array: gifs, key: k))
      self.gifIndex = await linearSearch(gifs, k)!
      debugPrint(gifIndex)
      //debugPrint(gifs.firstIndex(of: k)!)
      self.searchgif = splitArray(array: gifs, key: gifIndex)//Array(gifs[gifIndex..<gifs.count])!
   }
   
   
   @MainActor func loadGift() async {
      Task(priority: .userInitiated, operation: {
         let fp: APIListResponse? = try? await appiCall?.fetchAPI(urlParams: [Constants.rating: Constants.rating, Constants.limit: Constants.limitNum], gifacces: Constants.trending)
         let d = fp?.data.map({ return GifCollectionViewCellViewModel(id: $0.id!, title: $0.title!, rating: $0.rating, Image: $0.images?.fixed_height?.url, url: $0.url)
         })
         self.gifs = d!
      })
   }
   
   
   deinit{
      debugPrint("ViewModel deinit")
   }
}


