//
//  VerificadorDeFestivos.m
//  Festivos
//
//  Created by Alejandro Gomez on 1/04/14.
//  Copyright (c) 2014 Intergrupo. All rights reserved.
//

#import "VerificadorDeFestivos.h"

#import "FechasFestivas.h"

@interface VerificadorDeFestivos ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *dayOfWeekFormatter;

@end

@implementation VerificadorDeFestivos

@synthesize dateFormatter;
@synthesize dayOfWeekFormatter;


//Inicializacion de los DateFormatter
- (id)init
{
    if ([super init]){
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        self.dayOfWeekFormatter = [[NSDateFormatter alloc] init];
        [self.dayOfWeekFormatter setDateFormat:@"e"];
    }
    return self;
}

//Metodo principal de la clase, el unico que debe ser llamado desde la clase Calculo
//para definir cual es el tipo de festivo, si la fecha no es un festivo se retorna como valor
//NoFestivo (ver enumeraciones definidas en la clase FechasFestivas)
- (Festivos)VerificarSiElDiaEsFestivo:(NSDate *)fecha
{
    //Se realiza primero la validacion de los festivos fijos
    //estos son aquellos cuyo dia de celebracion nunca varia sin importar el año
    //Ej: navidad, año nuevo, dia del trabajo, etc...
    Festivos festivo = [self ValidarFestivosFijos:fecha];
    if (festivo == NoFestivo)
    {
        //Si la validacion de festivos fijos no retorno ninguna coincidencia se procede
        //a realizar la validacion de festivos de lunes, estos son los dias festivos cuya
        //celebracion se aplaza hasta el siguiente lunes despues del dia de celebracion
        //Ej: epifania, dia de la raza, independencia de cartagena, etc...
        festivo = [self VerificarFestivosPrimerLunes:fecha];
        if (festivo == NoFestivo)
        {
            //Si la validacion de festivos de lunes tampoco retorna alguna coincidencia
            //se procede a realizar la verificar de los festivos asociados a la pascua
            //Ej: domingo de ramos, jueves santo, viernes santos, etc...
            festivo = [self VerificarRelativosAlDiaDePascuas:fecha];
        }
    }
    return festivo;
}

//Metodo encargado de validar los festivos fijos
- (Festivos)ValidarFestivosFijos:(NSDate *)fecha
{
    //Se define como tipo de festivo inicial NoFestivo
    Festivos tipoDeFecha = NoFestivo;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth fromDate:fecha];
    //A partir del parametro de entrada fecha y mediante la clase NSDateComponents
    //se obtiene el dia y el mes de la fecha
    NSInteger day = [components day];
    NSInteger month = [components month];
    //Año nuevo
    if (day == 1 && month == 1)
        tipoDeFecha = AnoNuevo;
    //Dia del trabajo
    else if (day == 1 && month == 5)
        tipoDeFecha = DiaDelTrabajo;
    //Grito de independencia
    else if (day == 20 && month == 7)
        tipoDeFecha = GritoDeIndependencia;
    //Batalla de boyaca
    else if (day == 7 && month == 8)
        tipoDeFecha = BatallaDeBoyaca;
    //Inmaculada concepcion
    else if (day == 8 && month == 12)
        tipoDeFecha = InmaculadaConcepcion;
    //Navidad
    else if (day == 25 && month == 12)
        tipoDeFecha = Navidad;
    return tipoDeFecha;
}


//Metodo que valida los festivos de lunes
- (Festivos)VerificarFestivosPrimerLunes:(NSDate *)fecha
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:fecha];
    int year = (int)[components year];
    //Para este metodo lo que se hace es obtener el año del parametro de enetrada fecha
    //este año se pasa como parametro para cada uno de los metodos encargados de determinar la fecha
    //y estos metodos retornan una variable de tipo fecha que es la fecha de celebracion de la festividad
    //para el año en cuestion, luego esa fecha retornada se compara con la fecha original para
    //determinar si son iguales
    Festivos tipoDeFecha = NoFestivo;
    if ([[self Epifania:year] compare:fecha] == NSOrderedSame)
        tipoDeFecha = Epifania;
    else if ([[self SanJose:year] compare:fecha] == NSOrderedSame)
        tipoDeFecha = SanJose;
    else if ([[self DiaDeLaRaza:year] compare:fecha] == NSOrderedSame)
        tipoDeFecha = DiaDeLaRaza;
    else if ([[self TodosLosSantos:year] compare:fecha] == NSOrderedSame)
        tipoDeFecha = TodosLosSantos;
    else if ([[self AsuncionDeMaria:year] compare:fecha] == NSOrderedSame)
        tipoDeFecha = AsuncionDeMaria;
    else if ([[self IndependenciaDeCartagena:year] compare:fecha] == NSOrderedSame)
        tipoDeFecha = IndependenciaDeCartagena;
    else if ([[self SanPedroYSanPablo:year] compare:fecha] == NSOrderedSame)
        tipoDeFecha = SanPedroySanPablo;
    return tipoDeFecha;
}


//Metodo para validar los festivos de pascuas
- (Festivos)VerificarRelativosAlDiaDePascuas:(NSDate *)fecha
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:fecha];
    int year = (int)[components year];
    //Para este metodo lo que se hace es obtener el año del parametro de enetrada fecha
    //este año se pasa como parametro para cada uno de los metodos encargados de determinar la fecha
    //y estos metodos retornan una variable de tipo fecha que es la fecha de celebracion de la festividad
    //para el año en cuestion, luego esa fecha retornada se compara con la fecha original para
    //determinar si son iguales
    Festivos tipoDeFecha = NoFestivo;
    if ([[self DomingoDeRamos:year] compare:fecha] == NSOrderedSame)
        tipoDeFecha = DomingoDeRamos;
    else if ([[self JuevesSanto:year] compare:fecha] == NSOrderedSame)
        tipoDeFecha = JuevesSanto;
    else if ([[self ViernesSanto:year] compare:fecha] == NSOrderedSame)
        tipoDeFecha = ViernesSanto;
    else if ([[self DomingoDePascuas:year] compare:fecha] == NSOrderedSame)
        tipoDeFecha = DomingoDePascua;
    else if ([[self AscensionDeJesus:year] compare:fecha] == NSOrderedSame)
        tipoDeFecha = AscencionDeJesus;
    else if ([[self CorpusChristi:year] compare:fecha] == NSOrderedSame)
        tipoDeFecha = CorpusChristi;
    else if ([[self SagradoCorazon:year] compare:fecha] == NSOrderedSame)
        tipoDeFecha = SagradoCorazon;
    return tipoDeFecha;
}

//Epifania
- (NSDate *)Epifania:(int)ano
{
    NSString *dateString = [NSString stringWithFormat:@"%d-1-6", ano];
    NSDate *date = [self.dateFormatter dateFromString:dateString];
    NSString *dayOfWeekString = [self.dayOfWeekFormatter stringFromDate:date];
    while ([dayOfWeekString intValue]!= 2)
    {
        int daysToAdd = 1;
        date = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
        dayOfWeekString = [self.dayOfWeekFormatter stringFromDate:date];
    }
    return date;
}

//San Jose
- (NSDate *)SanJose:(int)ano
{
    NSString *dateString = [NSString stringWithFormat:@"%d-3-19", ano];
    NSDate *date = [self.dateFormatter dateFromString:dateString];
    NSString *dayOfWeekString = [self.dayOfWeekFormatter stringFromDate:date];
    while ([dayOfWeekString intValue]!= 2)
    {
        int daysToAdd = 1;
        date = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
        dayOfWeekString = [self.dayOfWeekFormatter stringFromDate:date];
    }
    return date;
}


//Dia de la raza
- (NSDate *)DiaDeLaRaza:(int)ano
{
    NSString *dateString = [NSString stringWithFormat:@"%d-10-12", ano];
    NSDate *date = [self.dateFormatter dateFromString:dateString];
    NSString *dayOfWeekString = [self.dayOfWeekFormatter stringFromDate:date];
    while ([dayOfWeekString intValue]!= 2)
    {
        int daysToAdd = 1;
        date = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
        dayOfWeekString = [self.dayOfWeekFormatter stringFromDate:date];
    }
    return date;
}


//Todos los santos
- (NSDate *)TodosLosSantos:(int)ano
{
    NSString *dateString = [NSString stringWithFormat:@"%d-11-1", ano];
    NSDate *date = [self.dateFormatter dateFromString:dateString];
    NSString *dayOfWeekString = [self.dayOfWeekFormatter stringFromDate:date];
    while ([dayOfWeekString intValue]!= 2)
    {
        int daysToAdd = 1;
        date = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
        dayOfWeekString = [self.dayOfWeekFormatter stringFromDate:date];
    }
    return date;
}

//Asuncion de Maria
- (NSDate *)AsuncionDeMaria:(int)ano
{
    NSString *dateString = [NSString stringWithFormat:@"%d-8-15", ano];
    NSDate *date = [self.dateFormatter dateFromString:dateString];
    NSString *dayOfWeekString = [self.dayOfWeekFormatter stringFromDate:date];
    while ([dayOfWeekString intValue]!= 2)
    {
        int daysToAdd = 1;
        date = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
        dayOfWeekString = [self.dayOfWeekFormatter stringFromDate:date];
    }
    return date;
}

//Independencia de Cartagena
- (NSDate *)IndependenciaDeCartagena:(int)ano
{
    NSString *dateString = [NSString stringWithFormat:@"%d-11-11", ano];
    NSDate *date = [self.dateFormatter dateFromString:dateString];
    NSString *dayOfWeekString = [self.dayOfWeekFormatter stringFromDate:date];
    while ([dayOfWeekString intValue]!= 2)
    {
        int daysToAdd = 1;
        date = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
        dayOfWeekString = [self.dayOfWeekFormatter stringFromDate:date];
    }
    return date;
}

//San Pedro y San Pablo
- (NSDate *)SanPedroYSanPablo:(int)ano
{
    NSString *dateString = [NSString stringWithFormat:@"%d-6-29", ano];
    NSDate *date = [self.dateFormatter dateFromString:dateString];
    NSString *dayOfWeekString = [self.dayOfWeekFormatter stringFromDate:date];
    while ([dayOfWeekString intValue]!= 2)
    {
        int daysToAdd = 1;
        date = [date dateByAddingTimeInterval:60*60*24*daysToAdd];
        dayOfWeekString = [self.dayOfWeekFormatter stringFromDate:date];
    }
    return date;
}

//Ascension de Jesus
- (NSDate *)AscensionDeJesus:(int)ano
{
    NSDate *pascuas = [self DomingoDePascuas:ano];
    int conteoLunes = 0;
    while (conteoLunes < 7)
    {
        int daysToAdd = 1;
        pascuas = [pascuas dateByAddingTimeInterval:60*60*24*daysToAdd];
        NSString *dayOfWeekString = [self.dayOfWeekFormatter stringFromDate:pascuas];
        if ([dayOfWeekString intValue] == 2)
            conteoLunes++;
    }
    return pascuas;
}

//Corpus Christi
- (NSDate *)CorpusChristi:(int)ano
{
    NSDate *pascuas = [self DomingoDePascuas:ano];
    int conteoLunes = 0;
    while (conteoLunes < 10)
    {
        int daysToAdd = 1;
        pascuas = [pascuas dateByAddingTimeInterval:60*60*24*daysToAdd];
        NSString *dayOfWeekString = [self.dayOfWeekFormatter stringFromDate:pascuas];
        if ([dayOfWeekString intValue] == 2)
            conteoLunes++;
    }
    return pascuas;
    
}

//Sagrado Corazon
- (NSDate *)SagradoCorazon:(int)ano
{
    NSDate *pascuas = [self DomingoDePascuas:ano];
    int conteoLunes = 0;
    while (conteoLunes < 11)
    {
        int daysToAdd = 1;
        pascuas = [pascuas dateByAddingTimeInterval:60*60*24*daysToAdd];
        NSString *dayOfWeekString = [self.dayOfWeekFormatter stringFromDate:pascuas];
        if ([dayOfWeekString intValue] == 2)
            conteoLunes++;
    }
    return pascuas;
}

//Domingo de ramos
- (NSDate *)DomingoDeRamos:(int)ano
{
    NSDate *pascuas = [self DomingoDePascuas:ano];
    int daysToAdd = -7;
    pascuas = [pascuas dateByAddingTimeInterval:60*60*24*daysToAdd];
    return pascuas;
}

//Jueves santo
- (NSDate *)JuevesSanto:(int)ano
{
    NSDate *pascuas = [self DomingoDePascuas:ano];
    int daysToAdd = -3;
    pascuas = [pascuas dateByAddingTimeInterval:60*60*24*daysToAdd];
    return pascuas;
}

//Viernes santo
- (NSDate *)ViernesSanto:(int)ano
{
    NSDate *pascuas = [self DomingoDePascuas:ano];
    int daysToAdd = -2;
    pascuas = [pascuas dateByAddingTimeInterval:60*60*24*daysToAdd];
    return pascuas;
}

//Domingo de pascuas
- (NSDate *)DomingoDePascuas:(int)ano
{
    int year = ano;
    int calculo = ((((year % 19) * 19) + (year / 100) - ((year / 100) / 4)
                    - ((((year / 100) * 8) + 13) / 25) + 15) % 30)
    - (((year % 19) + (((((year % 19) * 19) + (year / 100) - ((year / 100) / 4)
                         - ((((year / 100) * 8) + 13) / 25) + 15) % 30) * 11)) / 319)
    + (((((year / 100) % 4) * 2) + (((year % 100) / 4) * 2)
        - ((year % 100) % 4) - ((((year % 19) * 19) + (year / 100) - ((year / 100) / 4)
                                 - ((((year / 100) * 8) + 13) / 25) + 15) % 30)
        + (((year % 19) + (((((year % 19) * 19) + (year / 100) - ((year / 100) / 4)
                             - ((((year / 100) * 8) + 13) / 25) + 15) % 30) * 11)) / 319) + 32) % 7);
    int month = (calculo + 90) / 25;
    int day = (calculo + month + 19) % 32;
    NSString *dateString = [NSString stringWithFormat:@"%d-%d-%d", year, month, day];
    return [self.dateFormatter dateFromString:dateString];
}

@end
