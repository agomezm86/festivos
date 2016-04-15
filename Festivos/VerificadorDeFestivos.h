//
//  VerificadorDeFestivos.h
//  Festivos
//
//  Created by Alejandro Gomez on 1/04/14.
//  Copyright (c) 2014 Intergrupo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FechasFestivas.h"

@interface VerificadorDeFestivos : NSObject

//Esta clase se encarga de validar si la fecha que recibe como parametro es un dia de fiesta
//basandose en los diferente feriados que tiene el pais

- (Festivos)VerificarSiElDiaEsFestivo:(NSDate *)fecha;

@end
