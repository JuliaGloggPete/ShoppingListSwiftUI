//
//  ContentView.swift
//  Shoppinglist
//
//  Created by Julia Petersson  on 2023-04-17.
//

import SwiftUI
import Firebase


struct ContentView : View {
    
    
    
    @State var signedIn = false
    
    var body: some View {
        
        if !signedIn {
            SignInView(signedIn: $signedIn)
            
        } else {
            ShoppingListView()
            
        }
        
        
    }
    
}
    




struct SignInView : View{
    
    @Binding var signedIn : Bool
    var auth = Auth.auth()
    
    var body: some View{
        
        Button(action: {
            
            auth.signInAnonymously{
                result, error in
                if let error = error {
                    print("error signing in")
                } else{
                    
                    
                    signedIn = true
                    
                }
                
            }
            
            
        })  {Text("Sign in")
        }
        
        
        
    }
    
    
}

struct ShoppingListView: View {
    
    @StateObject var shoppingListVM = ShoppingListVM()
    @State var showingAddAlert = false
    @State var newItemName = ""
    
    var body: some View {
        VStack {
            Text("test")
            List {
                ForEach(shoppingListVM.items){
                    item in
                    RowView(item: item, vm: shoppingListVM)
                    
                }
                .onDelete(){ indexSet in
                    for index in indexSet {
                        
                        shoppingListVM.delete(index: index)
                        
                    }
                    
                    
                }
            }
            Button(action: {showingAddAlert = true
                
            })
            {
                Text("Add")
                
            }
                .alert("Lägg till", isPresented: $showingAddAlert){
                    TextField("Lägg till",text: $newItemName)
                    Button("Add", action: {
                        
                        shoppingListVM.saveToFirestore(itemName: newItemName)
                        newItemName=""
                        
                    })
                    
                }
        }.onAppear(){
            // saveToFirestore(itemName: "gurka")
            shoppingListVM.listenToFirestore()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RowView: View {
    let item : Item
    let vm : ShoppingListVM
    
    var body: some View {
        HStack{
            Text(item.name)
            Spacer()
            Button(action:{
                vm.toggle(item: item)
                
            }) {Image(systemName: item.done ? "checkmark.square" : "square")
            }
            
            
            
        }
    }
}
