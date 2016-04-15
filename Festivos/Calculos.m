//
//  Calculos.m
//  Festivos
//
//  Created by Alejandro Gomez on 1/04/14.
//  Copyright (c) 2014 Intergrupo. All rights reserved.
//

#import "Calculos.h"

#import "FechasFestivas.h"
#import "VerificadorDeFestivos.h"

@interface Calculos ()

@property (nonatomic, strong) VerificadorDeFestivos *verificadorDeFestivos;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *dayOfWeekFormatter;

@end

@implementation Calculos

@synthesize dateFormatter;
@synthesize dayOfWeekFormatter;

//Se crea una instancia de la clase VerificadorDeFestivos
//Se inicializan variables de formato de fecha para ser usadas en diferentes metodos
- (id)init
{
    if ([super init]){
        self.verificadorDeFestivos = [[VerificadorDeFestivos alloc] init];
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        self.dayOfWeekFormatter = [[NSDateFormatter alloc] init];
        [self.dayOfWeekFormatter setDateFormat:@"e"];
    }
    return self;
}

//Determina si la fecha en cuestion esta por debajo del año 1900
//o por encima del año 2099, en ambos casos retorna un YES
- (BOOL)LaFechaSeEncuentraFueraDeRango:(NSDate *)fecha
{
    NSString *dateString1 = @"1900-1-1";
    NSString *dateString2 = @"2100-1-1";
    NSDate *date1 = [self.dateFormatter dateFromString:dateString1];
    NSDate *date2 = [self.dateFormatter dateFromString:dateString2];
    NSComparisonResult result1 = [date1 compare:fecha];
    NSComparisonResult result2 = [date2 compare:fecha];
    
    if (result1 == NSOrderedDescending || result2 == NSOrderedAscending)
        return YES;
    return NO;
}

//Determina si el año en cuestion esta por debajo del año 1900
//o por encima del año 2099, en ambos casos retorna un YES
- (BOOL)ElAnoSeEncuentraFueraDeRango:(int)ano
{
    if (ano < 1900 || ano >= 2100)
        return YES;
    return NO;
}


//Determina si el mes en cuestion tiene un valor numerico inferior a 1 o superior a 12
//en ambos casos retorna YES
- (BOOL)ElMesSeEncuentraFueraDeRango:(int)mes
{
    if (mes < 1 || mes > 12)
        return YES;
    return NO;
}

//Cualquier parametros de tipo NSDate que sea recibido por la clase debe ser primero formateado
//para obtener una variable de tipo fecha con el mismo formato manejo para las demas variables de
//tipo fecha
- (NSDate *)FormatearFecha:(NSDate *)fecha
{
    return [self.dateFormatter dateFromString:[self.dateFormatter stringFromDate:fecha]];
}

//Metodo para saber si determinada fecha es un dia no laboral
- (BOOL)EsUnDiaNoLaboral:(NSDate *)fecha
{
    //Se realiza el formateo inicial de la variable fecha
    fecha = [self FormatearFecha:fecha];
    if ([self LaFechaSeEncuentraFueraDeRango:fecha])
        return NO;
    
    BOOL respuesta = NO;
    //Se verifica mediante la clase VerificadorDeFestivos, si el dia en cuestion es festivo
    Festivos festivo = [self.verificadorDeFestivos VerificarSiElDiaEsFestivo:fecha];
    if (festivo == NoFestivo)
    {
        //Si el dia en cuestion no es festivo se debe validar que el dia no caiga en sabado o domingo
        //en tal caso el dia tambien sera tomado como no laboral
        NSString *dayOfWeekString = [self.dayOfWeekFormatter stringFromDate:fecha];
        respuesta = ([dayOfWeekString intValue] == 1) || ([dayOfWeekString intValue] == 7);
    }
    else
        respuesta = YES;
    return respuesta;
}

//Metodo para obtener el numero de dias laborales de determinado mes
- (int)ObtenerCantidadDeDiasLaboralesEnElMes:(int)mes enElAno:(int)ano
{
    //Se valida que el mes y el año no se encuentre fuera de los rangos minimos y maximos permitidos
    if ([self ElAnoSeEncuentraFueraDeRango:ano])
        return NO;
    if ([self ElMesSeEncuentraFueraDeRango:mes])
        return NO;
    
    int cantidadDeDiasHabiles = 0;
    //Se define el primer dia del mes
    NSString *dateString1 = [NSString stringWithFormat:@"%d-%d-1", ano, mes];
    NSDate *date1 = [self.dateFormatter dateFromString:dateString1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //Se calcula el numero de dias calendario que tiene el mes en cuestion
    //mediante la clase NSCalendar
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date1];
    //Se define el ultimo dia del mes
    NSString *dateString2 = [NSString stringWithFormat:@"%d-%d-%lu", ano, mes, (unsigned long)days.length];
    NSDate *date2 = [self.dateFormatter dateFromString:dateString2];
    //Mediante el metodo ObtenerCantidadDeDiasLaboralesEnElRango se realiza un barrido por todo el rango
    //de fechas para determinar la cantidad de dias habiles
    cantidadDeDiasHabiles = [self ObtenerCantidadDeDiasLaboralesEnElRango:date1 hasta:date2];
    return cantidadDeDiasHabiles;
}

//Metodo para obtener el numero de dias laborales en determinado rango de fechas
- (int)ObtenerCantidadDeDiasLaboralesEnElRango:(NSDate *)fechaInicial hasta:(NSDate *)fechaFinal
{
    //Se realiza el formateo inicial y la validacion de rango de la fecha inicial
    fechaInicial = [self FormatearFecha:fechaInicial];
    if ([self LaFechaSeEncuentraFueraDeRango:fechaInicial])
        return NO;
    //Se realiza el formateo inicial y la validacion de rango de la fecha final
    fechaFinal = [self FormatearFecha:fechaFinal];
    if ([self LaFechaSeEncuentraFueraDeRango:fechaFinal])
        return NO;
    
    int cantidadDeDiasHabiles = 0;
    //Se realiza la comparacion entre las dos fechas para definir cual es mayor y cual menor
    NSComparisonResult result = [fechaInicial compare:fechaFinal];
    if (result != NSOrderedSame)
    {
        NSDate *inicial = fechaInicial;
        NSDate *final = fechaFinal;
        result = [inicial compare:final];
        if (result == NSOrderedDescending)
        {
            //Si la fecha final es menor a la inicial se realiza la siguiente asignacion
            inicial = fechaFinal;
            final = fechaInicial;
        }
        
        result = [inicial compare:final];
        //Este ciclo se debe realizar mientras la comparacion de fechas indique que
        //la fecha inicial es menor o igual que la fecha final
        while (result == NSOrderedAscending || result == NSOrderedSame)
        {
            //Si la fecha inicial es un dia laboral el contador de dias habiles se incrementa en 1
            if (![self EsUnDiaNoLaboral:inicial])
                cantidadDeDiasHabiles++;
            int daysToAdd = 1;
            //La fecha inicial se incrementa en 1 dia para pasar al siguiente ciclo hasta que el
            //criterio para finalizarlo se cumpla
            inicial = [inicial dateByAddingTimeInterval:60*60*24*daysToAdd];
            result = [inicial compare:final];
        }
    }
    return cantidadDeDiasHabiles;
}

//Metodo para obtener una fecha a partir de una fecha inicial y una cantidad de dias laborales
- (NSDate *)ObtenerNuevaFechaLaboral:(NSDate *)fechaInicial dias:(int)cantidadDiasLaborales
{
    //Se realiza el formateo inicial y la validacion de rango de la fecha inicial
    fechaInicial = [self FormatearFecha:fechaInicial];
    if ([self LaFechaSeEncuentraFueraDeRango:fechaInicial])
        return NO;
    
    NSDate *inicial = [self.dateFormatter dateFromString:[self.dateFormatter stringFromDate:fechaInicial]];
    int contador = 0;
    //Si la cantidad de dias laborales que el usuario ingreso es positiva
    if (cantidadDiasLaborales > 0)
    {
        while (contador < cantidadDiasLaborales)
        {
            int daysToAdd = 1;
            //Por cada ciclo la fecha se incrementa en 1 dia
            inicial = [inicial dateByAddingTimeInterval:60*60*24*daysToAdd];
            //La variable contador se incrementa si la fecha es un dia laboral
            if (![self EsUnDiaNoLaboral:inicial])
                contador++;
        }
    }
    //Si la cantidad de dias laborales que el usuario ingreso es negativa
    else if (cantidadDiasLaborales < 0)
    {
        while (contador > cantidadDiasLaborales)
        {
            int daysToAdd = -1;
            //Por cada ciclo la fecha se decrementa en 1 dia
            inicial = [inicial dateByAddingTimeInterval:60*60*24*daysToAdd];
            //La variable contador se incrementa si la fecha es un dia laboral
            if (![self EsUnDiaNoLaboral:inicial])
                contador--;
        }
    }
    return inicial;
}

@end