//
//  FechasFestivas.h
//  Festivos
//
//  Created by Alejandro Gomez on 1/04/14.
//  Copyright (c) 2014 Intergrupo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FechasFestivas : NSObject

//Contiene la enumeracion con las diferencias festividades que se celebran en Colombia

enum {
    AnoNuevo,
    DiaDelTrabajo,
    GritoDeIndependencia,
    BatallaDeBoyaca,
    InmaculadaConcepcion,
    Navidad,
    Epifania,
    SanJose,
    DiaDeLaRaza,
    TodosLosSantos,
    AsuncionDeMaria,
    IndependenciaDeCartagena,
    SanPedroySanPablo,
    DomingoDeRamos,
    JuevesSanto,
    ViernesSanto,
    DomingoDePascua,
    AscencionDeJesus,
    CorpusChristi,
    SagradoCorazon,
    NoFestivo
};

typedef NSInteger Festivos;

@end
