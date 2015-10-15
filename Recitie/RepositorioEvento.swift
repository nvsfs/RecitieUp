//
//  RepositorioEvento.swift
//  Recitie
//
//  Created by Natalia Souza on 10/14/15.
//  Copyright © 2015 Natalia. All rights reserved.
//

import Foundation


class RepositorioEvento {
    
    var teste = Event()
    
    var eventos:[Event] = []
 
    func inserir(event:Event){
        
        eventos.append(event)

    }
    
    
    func buscarTodos() -> [Event]{
        return eventos
    }
    
    
}