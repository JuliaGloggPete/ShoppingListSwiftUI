//
//  ContentView.swift
//  Shoppinglist
//
//  Created by Julia Petersson  on 2023-04-17.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    let db = Firestore.firestore()
    @State var items = [Item]()
    
    var body: some View {
        VStack {
            Text("test")
            List {
                ForEach(items){
                    item in 
                    HStack{
                        Text(item.name)
                        Spacer()
                        Button(action:{
                            if let id = item.id {
                                db.collection("items").document(id).updateData([
                                    "done" : !item.done])
                            }
                            
                        }) {Image(systemName: item.done ? "checkmark.square" : "square")
                        }
                        
                        
                        
                    }
                    
                }
                
                
            }
            
            
   
        }.onAppear(){
           // saveToFirestore(itemName: "gurka")
            listenToFirestore()
      
            
        }

    }
    
    func saveToFirestore(itemName: String){
        let item = Item(name: itemName)
        do {
           try db.collection("items").addDocument(from: item)
        }
        catch{
            
            print("Error saving to dv")
            
        }
        
    }
    
    func listenToFirestore(){
        
        db.collection("items").addSnapshotListener() {
            snapshot, err in
            
            guard let snapshot = snapshot else {return}
            
            if let err = err {
                print("error getting document \(err)")
            } else
            {
                items.removeAll()
                for document in snapshot.documents {
                    do {
                        let item = try document.data(as : Item.self)
                        items.append(item)
                    } catch {
                        print("Error reading form db")
                        
                    }
                }
                
                
            }
            
            
        }
        
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
