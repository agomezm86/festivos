//
//  Calculos.h
//  Festivos
//
//  Created by Alejandro Gomez on 1/04/14.
//  Copyright (c) 2014 Intergrupo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculos : NSObject

//Esta clase se encarga de realizar los calculos necesarios para cada una de las cuatro
//funcionalidades que tiene esta libreria
//1. Definir si un dia es laboral
//2. Obtener la cantidad de dias laborales de determinado mes
//3. Obtener la cantidad de dias laborales en determinado rango de fechas
//4. Obtener una fecha a partir de una fecha inicial y un plazo de dias laborales

- (BOOL)EsUnDiaNoLaboral:(NSDate *)fecha;
- (int)ObtenerCantidadDeDiasLaboralesEnElMes:(int)mes enElAno:(int)ano;
- (int)ObtenerCantidadDeDiasLaboralesEnElRango:(NSDate *)fechaInicial hasta:(NSDate *)fechaFinal;
- (NSDate *)ObtenerNuevaFechaLaboral:(NSDate *)fechaInicial dias:(int)cantidadDiasLaborales;

@end
