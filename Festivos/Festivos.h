//
//  Festivos.h
//  Festivos
//
//  Created by Alejandro Gomez on 1/04/14.
//  Copyright (c) 2014 Intergrupo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Festivos : NSObject

//Clase principal de la libreria
//Hace los respectivos llamados a los metodos del mismo nombre ubicados en la clase Calculos

- (BOOL)EsUnDiaNoLaboral:(NSDate *)fecha;
- (int)ObtenerCantidadDeDiasLaboralesEnElMes:(int)mes enElAno:(int)ano;
- (int)ObtenerCantidadDeDiasLaboralesEnElRango:(NSDate *)fechaInicial hasta:(NSDate *)fechaFinal;
- (NSDate *)ObtenerNuevaFechaLaboral:(NSDate *)fechaInicial dias:(int)cantidadDiasLaborales;

@end
