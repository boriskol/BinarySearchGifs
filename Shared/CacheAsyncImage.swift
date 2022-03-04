//
//  CacheAsyncImage.swift
//  InsertionSortGifs
//
//  Created by Borna Libertines on 16/02/22.
//

import Foundation
import SwiftUI

struct CacheAsyncImage<Content>: View where Content: View {
   
   private let url: URL
   private let scale: CGFloat
   private let transaction: Transaction
   private let content: (AsyncImagePhase) -> Content
   
   init(
      url: URL,
      scale: CGFloat = 1.0,
      transaction: Transaction = Transaction(),
      @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
   ) {
      self.url = url
      self.scale = scale
      self.transaction = transaction
      self.content = content
   }
   
   var body: some View {
      //let _ = print("ItemCache \(url.absoluteString)")
      //let _ = print("ItemCache \(String(describing: ItemCache.shared.getItem(for: url.absoluteString)))")
      if let cached = ItemCache.shared.getItem(for: url.absoluteString){
         //if let cached = ImageCache[url] {
         content(.success(cached))
      } else {
         ////let _ = print("request \(url.absoluteString)")
         AsyncImage(
            url: url,
            scale: scale,
            transaction: transaction
         ) { phase in
            cacheAndRender(phase: phase)
         }
      }
   }
   
   func cacheAndRender(phase: AsyncImagePhase) -> some View {
      if case .success(let image) = phase {
         //ImageCache[url] = image
         ItemCache.shared.cache(image, for: url.absoluteString)
      }
      
      return content(phase)
   }
}

// TODO:  Fix this withNSCach
/*
 fileprivate class ImageCache {
 //static private var cache: [URL: Image] = [:]
 
 static subscript(url: URL) -> Image? {
 get {
 //ImageCache.cache[url]
 return ItemCache.shared.getItem(for: url)
 }
 set {
 //ImageCache.cache[url] = newValue
 return ItemCache.shared.cache(newValue!, for: url)
 
 }
 }
 }
 */
class StructWrapper<T>: NSObject {
   let value: T
   init(_ _struct: T) {
      value = _struct
   }
}
fileprivate class ItemCache: NSCache<NSString, StructWrapper<Image>> {
   static let shared = ItemCache()
   
   func cache(_ item: Image, for key: String) {
      //let _ = print("cache \(key.absoluteString), image: \(item)")
      let itemWrapper = StructWrapper(item)
      self.setObject(itemWrapper, forKey: key as NSString )
   }
   func getItem(for key: String) -> Image? {
      let itemWrapper = self.object(forKey: key as NSString)
      return itemWrapper?.value
   }
}
