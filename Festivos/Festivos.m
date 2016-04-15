//
//  Festivos.m
//  Festivos
//
//  Created by Alejandro Gomez on 1/04/14.
//  Copyright (c) 2014 Intergrupo. All rights reserved.
//

#import "Festivos.h"

#import "Calculos.h"

@interface Festivos ()

@property (nonatomic, strong) Calculos *calculos;

@end

@implementation Festivos

@synthesize calculos;

- (id)init
{
    if ([super init]){
        //Instancia de la clase calculos
        self.calculos = [[Calculos alloc] init];
    }
    return self;
}

//Metodo para hallar si determinada fecha es dia laboral, retorna un booleano
//Retorna el valor obtenido del metodo del mismo nombre en la clase Calculos
- (BOOL)EsUnDiaNoLaboral:(NSDate *)fecha
{
    return [self.calculos EsUnDiaNoLaboral:fecha];
}

//Metodo para calcular el numero de dias laborales que tiene determinado mes y año, retorna un entero
//Retorna el valor obtenido del metodo del mismo nombre en la clase Calculos
- (int)ObtenerCantidadDeDiasLaboralesEnElMes:(int)mes enElAno:(int)ano
{
    return [self.calculos ObtenerCantidadDeDiasLaboralesEnElMes:mes enElAno:ano];
}

//Metodo para calcular el numero de dias laboral en determinado rango de fechas, retorna un entero
//Retorna el valor obtenido del metodo del mismo nombre en la clase Calculos
- (int)ObtenerCantidadDeDiasLaboralesEnElRango:(NSDate *)fechaInicial hasta:(NSDate *)fechaFinal
{
    return [self.calculos ObtenerCantidadDeDiasLaboralesEnElRango:fechaInicial hasta:fechaFinal];
}

//Metodo para calcular una fecha a partir de una fecha inicial y un numero de dias laborales, retorna una fecha
//Retorna el valor obtenido del metodo del mismo nombre en la clase Calculos
- (NSDate *)ObtenerNuevaFechaLaboral:(NSDate *)fechaInicial dias:(int)cantidadDiasLaborales
{
    return [self.calculos ObtenerNuevaFechaLaboral:fechaInicial dias:cantidadDiasLaborales];
}

@end
