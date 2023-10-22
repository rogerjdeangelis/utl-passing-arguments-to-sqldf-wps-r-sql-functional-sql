%let pgm=utl-passing-arguments-to-sqldf-wps-r-sql-functional-sql;

Passing arguments to sqldf wps r sql functional sql;

github
https://tinyurl.com/5aeuz244
https://github.com/rogerjdeangelis/utl-passing-arguments-to-sqldf-wps-r-sql-functional-sql

https://tinyurl.com/yxt49ztu
https://github.com/cran/sqldf/tree/master#example-5-insert-variables

  PROBLEM (select from iris species=virginica and sepallength>70 )

       arg1 =  SPECIES       (variable to subset. we want SPECIES= virginica)
       arg2 =  virginica     (species we are interested in)
       arg3 =  SEPALLENGTH   (variablename we are interested in sepallength)
       arg4 =  70            (we are interetsed in sepallengths over 70)

       Select
           *
       from
           iris
       where
            arg1 = arg2  ==> Species     = virginica
        and arg2 < arg4  ==> sepallength > 70

  THREE SOLUTIONS

       1 wps r functional sqldf
       2 wps r pass macro vars
       3 wps r submit string sqdf

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
input
     Species $10.
     SepalLength
     SepalWidth
     PetalLength
     PetalWidth;
cards4;
VERSICOLOR 70 32 47 14
VERSICOLOR 67 31 44 14
VERSICOLOR 66 29 46 13
VERSICOLOR 67 31 47 15
VERSICOLOR 69 31 49 15
VERSICOLOR 66 30 44 14
VERSICOLOR 68 28 48 14
VERSICOLOR 67 30 50 17
VIRGINICA 67 31 56 24
VIRGINICA 69 31 51 23
VIRGINICA 68 32 59 23
VIRGINICA 77 38 67 22
VIRGINICA 67 33 57 25
VIRGINICA 76 30 66 21
VIRGINICA 67 30 52 23
VIRGINICA 79 38 64 20
VIRGINICA 67 33 57 21
VIRGINICA 77 28 67 20
VIRGINICA 72 32 60 18
VIRGINICA 77 30 61 23
VIRGINICA 72 30 58 16
VIRGINICA 71 30 59 21
VIRGINICA 77 26 69 23
VIRGINICA 69 32 57 23
VIRGINICA 74 28 61 19
VIRGINICA 73 29 63 18
VIRGINICA 67 25 58 18
VIRGINICA 69 31 54 21
VIRGINICA 72 36 61 25
VIRGINICA 68 30 55 21
;;;;
run;quit;

proc sort data=sd1.have out=x;
by descending species sepallength;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*              INPUT                             PROCESS                                   OUTPUT                        */
/*                                                                                                                        */
/* Obs     SPECIES      SEPALLENGTH                                                   SPECIES     SEPALLENGTH             */
/*                                                                                                                        */
/*   1    VIRGINICA          67         select                                       VIRGINICA         77                 */
/*   2    VIRGINICA          67            *                                         VIRGINICA         76                 */
/*   3    VIRGINICA          67         from                                         VIRGINICA         79                 */
/*   4    VIRGINICA          67           iris                                       VIRGINICA         77                 */
/*   5    VIRGINICA          67         where s                                      VIRGINICA         72                 */
/*   6    VIRGINICA          68               arg1 = arg2 ==> SPECIES = virginica    VIRGINICA         77                 */
/*   7    VIRGINICA          68           and arg3 = arg4 ==> SEPALLENGTH > 59       VIRGINICA         72                 */
/*   8    VIRGINICA          69                                                      VIRGINICA         71                 */
/*   9    VIRGINICA          69                                                      VIRGINICA         77                 */
/*  10    VIRGINICA          69                                                      VIRGINICA         74                 */
/*  11    VIRGINICA          71                                                      VIRGINICA         72                 */
/*  12    VIRGINICA          72                                                                                           */
/*  13    VIRGINICA          72                                                                                           */
/*  14    VIRGINICA          72                                                                                           */
/*  15    VIRGINICA          73                                                                                           */
/*  16    VIRGINICA          74                                                                                           */
/*  17    VIRGINICA          76                                                                                           */
/*  18    VIRGINICA          77                                                                                           */
/*  19    VIRGINICA          77                                                                                           */
/*  20    VIRGINICA          77                                                                                           */
/*  21    VIRGINICA          77                                                                                           */
/*  22    VIRGINICA          79                                                                                           */
/*  23    VERSICOLOR         66                                                                                           */
/*  24    VERSICOLOR         66                                                                                           */
/*  25    VERSICOLOR         67                                                                                           */
/*  26    VERSICOLOR         67                                                                                           */
/*  27    VERSICOLOR         67                                                                                           */
/*  28    VERSICOLOR         68                                                                                           */
/*  29    VERSICOLOR         69                                                                                           */
/*  30    VERSICOLOR         70                                                                                           */
/*                                                                                                                        */
/**************************************************************************************************************************/
/*                               __                  _   _                   _             _     _  __
/ | __      ___ __  ___   _ __  / _|_   _ _ __   ___| |_(_) ___  _ __   __ _| |  ___  __ _| | __| |/ _|
| | \ \ /\ / / `_ \/ __| | `__|| |_| | | | `_ \ / __| __| |/ _ \| `_ \ / _` | | / __|/ _` | |/ _` | |_
| |  \ V  V /| |_) \__ \ | |   |  _| |_| | | | | (__| |_| | (_) | | | | (_| | | \__ \ (_| | | (_| |  _|
|_|   \_/\_/ | .__/|___/ |_|   |_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|\__,_|_| |___/\__, |_|\__,_|_|
             |_|                                                                        |_|
*/

proc datasets lib=sd1
 nolist nodetails;delete want; run;quit;

libname sd1 "d:/sd1"
 %utl_submit_wps64x('
 libname sd1 "d:/sd1";
 proc r;
 export data=sd1.have r=have;
 submit;
 library(sqldf);

 specieVar <- "SPECIES";
 specieVal <- `"VIRGINICA"`;

 sepalVar  <- "SEPALLENGTH";
 sepalVal <-69;

 want<-fn$sqldf("select * from have where $sepalVar > $sepalVal and $specieVar= $specieVal");
 want;
 endsubmit;
 import data=sd1. want r=want;
run;quit;
');

libname sd1 "d:/sd1";
proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  The WPS PROC R                                                                                                        */
/*                                                                                                                        */
/*       SPECIES SEPALLENGTH SEPALWIDTH PETALLENGTH PETALWIDTH                                                            */
/*  1  VIRGINICA          77         38          67         22                                                            */
/*  2  VIRGINICA          76         30          66         21                                                            */
/*  3  VIRGINICA          79         38          64         20                                                            */
/*  4  VIRGINICA          77         28          67         20                                                            */
/*  5  VIRGINICA          72         32          60         18                                                            */
/*  6  VIRGINICA          77         30          61         23                                                            */
/*  7  VIRGINICA          72         30          58         16                                                            */
/*  8  VIRGINICA          71         30          59         21                                                            */
/*  9  VIRGINICA          77         26          69         23                                                            */
/*  10 VIRGINICA          74         28          61         19                                                            */
/*  11 VIRGINICA          73         29          63         18                                                            */
/*  12 VIRGINICA          72         36          61         25                                                            */
/*                                                                                                                        */
/* WPS BASE                                                                                                               */
/*                                                                                                                        */
/ *Obs    SPECIES     SEPALLENGTH    SEPALWIDTH    PETALLENGTH    PETALWIDTH                                              */
/*                                                                                                                        */
/*  1    VIRGINICA         77            38             67            22                                                  */
/*  2    VIRGINICA         76            30             66            21                                                  */
/*  3    VIRGINICA         79            38             64            20                                                  */
/*  4    VIRGINICA         77            28             67            20                                                  */
/*  5    VIRGINICA         72            32             60            18                                                  */
/*  6    VIRGINICA         77            30             61            23                                                  */
/*  7    VIRGINICA         72             30             58            16                                                  */
/*  8    VIRGINICA         71            30             59            21                                                  */
/*  9    VIRGINICA         77            26             69            23                                                  */
/* 10    VIRGINICA         74            28             61            19                                                  */
/* 11    VIRGINICA         73            29             63            18                                                  */
/* 12    VIRGINICA         72            36             61            25                                                  */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___
|___ \  __      ___ __  ___   _ __   _ __   __ _ ___ ___   _ __ ___   __ _  ___ _ __ ___   __   ____ _ _ __ ___
  __) | \ \ /\ / / `_ \/ __| | `__| | `_ \ / _` / __/ __| | `_ ` _ \ / _` |/ __| `__/ _ \  \ \ / / _` | `__/ __|
 / __/   \ V  V /| |_) \__ \ | |    | |_) | (_| \__ \__ \ | | | | | | (_| | (__| | | (_) |  \ V / (_| | |  \__ \
|_____|   \_/\_/ | .__/|___/ |_|    | .__/ \__,_|___/___/ |_| |_| |_|\__,_|\___|_|  \___/    \_/ \__,_|_|  |___/
                 |_|                |_|
*/

proc datasets lib=sd1
 nolist nodetails;delete want; run;quit;

libname sd1 "d:/sd1"

%utl_submit_wps64x("

 libname sd1 'd:/sd1';

 %let specieVar = SPECIES;
 %let specieVal = \`VIRGINICA\`;

 %let sepalVar  = SEPALLENGTH;
 %let sepalVal  = 69;

 proc r;
 export data=sd1.have r=have;
 submit;
 library(sqldf);

 want<-fn$sqldf('select * from have where &sepalVar > &sepalVal and &specieVar= &specieVal ');
 want;

 endsubmit;
 import data=sd1. want r=want;

run;quit;
");


libname sd1 "d:/sd1";

proc print data=sd1.want;
run;quit;


/**************************************************************************************************************************/
/*                                                                                                                        */
/*  The WPS PROC R                                                                                                        */
/*                                                                                                                        */
/*       SPECIES SEPALLENGTH SEPALWIDTH PETALLENGTH PETALWIDTH                                                            */
/*  1  VIRGINICA          77         38          67         22                                                            */
/*  2  VIRGINICA          76         30          66         21                                                            */
/*  3  VIRGINICA          79         38          64         20                                                            */
/*  4  VIRGINICA          77         28          67         20                                                            */
/*  5  VIRGINICA          72         32          60         18                                                            */
/*  6  VIRGINICA          77         30          61         23                                                            */
/*  7  VIRGINICA          72         30          58         16                                                            */
/*  8  VIRGINICA          71         30          59         21                                                            */
/*  9  VIRGINICA          77         26          69         23                                                            */
/*  10 VIRGINICA          74         28          61         19                                                            */
/*  11 VIRGINICA          73         29          63         18                                                            */
/*  12 VIRGINICA          72         36          61         25                                                            */
/*                                                                                                                        */
/* WPS BASE                                                                                                               */
/*                                                                                                                        */
/ *Obs    SPECIES     SEPALLENGTH    SEPALWIDTH    PETALLENGTH    PETALWIDTH                                              */
/*                                                                                                                        */
/*  1    VIRGINICA         77            38             67            22                                                  */
/*  2    VIRGINICA         76            30             66            21                                                  */
/*  3    VIRGINICA         79            38             64            20                                                  */
/*  4    VIRGINICA         77            28             67            20                                                  */
/*  5    VIRGINICA         72            32             60            18                                                  */
/*  6    VIRGINICA         77            30             61            23                                                  */
/*  7    VIRGINICA         72             30             58            16                                                  */
/*  8    VIRGINICA         71            30             59            21                                                  */
/*  9    VIRGINICA         77            26             69            23                                                  */
/* 10    VIRGINICA         74            28             61            19                                                  */
/* 11    VIRGINICA         73            29             63            18                                                  */
/* 12    VIRGINICA         72            36             61            25                                                  */
/*                                                                                                                        */
/**************************************************************************************************************************/


/*____                                         _               _ _         _        _                             _  __
|___ /  __      ___ __  ___   _ __   ___ _   _| |__  _ __ ___ (_) |_   ___| |_ _ __(_)_ __   __ _   ___  __ _  __| |/ _|
  |_ \  \ \ /\ / / `_ \/ __| | `__| / __| | | | `_ \| `_ ` _ \| | __| / __| __| `__| | `_ \ / _` | / __|/ _` |/ _` | |_
 ___) |  \ V  V /| |_) \__ \ | |    \__ \ |_| | |_) | | | | | | | |_  \__ \ |_| |  | | | | | (_| | \__ \ (_| | (_| |  _|
|____/    \_/\_/ | .__/|___/ |_|    |___/\__,_|_.__/|_| |_| |_|_|\__| |___/\__|_|  |_|_| |_|\__, | |___/\__, |\__,_|_|
                 |_|                                                                        |___/          |_|
*/

proc datasets lib=sd1
 nolist nodetails;delete want; run;quit;

libname sd1 "d:/sd1"

 %utl_submit_wps64x('
 libname sd1 "d:/sd1";
 proc r;
 export data=sd1.have r=have;
 submit;
 library(sqldf);

 specieVar <- "SPECIES";
 specieVal <- `"VIRGINICA"`;

 specieVar;
 specieVal;

 sepalVar  <- "SEPALLENGTH";
 sepalVal  <- 69;

sepalVar;
sepalVal;

 sqlcmd = paste ("select * from have where", sepalVar, ">" , sepalVal, "and", specieVar, "=", specieVal );
 sqlcmd;

 want<-sqldf(sqlcmd);
 want;

 endsubmit;
 import data=sd1. want r=want;
run;quit;
');

libname sd1 "d:/sd1";
proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* Generated selct script                                                                                                 */
/*                                                                                                                        */
/*  select * from have where SEPALLENGTH > 69 and SPECIES = \"VIRGINICA\"                                                 */
/*                                                                                                                        */
/*  WPS PROC R                                                                                                            */
/*                                                                                                                        */
/*      SPECIES SEPALLENGTH SEPALWIDTH PETALLENGTH PETALWIDTH                                                             */
/* 1  VIRGINICA          77         38          67         22                                                             */
/* 2  VIRGINICA          76         30          66         21                                                             */
/* 3  VIRGINICA          79         38          64         20                                                             */
/* 4  VIRGINICA          77         28          67         20                                                             */
/* 5  VIRGINICA          72         32          60         18                                                             */
/* 6  VIRGINICA          77         30          61         23                                                             */
/* 7  VIRGINICA          72         30          58         16                                                             */
/* 8  VIRGINICA          71         30          59         21                                                             */
/* 9  VIRGINICA          77         26          69         23                                                             */
/* 10 VIRGINICA          74         28          61         19                                                             */
/* 11 VIRGINICA          73         29          63         18                                                             */
/* 12 VIRGINICA          72         36          61         25                                                             */
/*                                                                                                                        */
/*                                                                                                                        */
/* WPS BASE                                                                                                               */
/*                                                                                                                        */
/* Obs     SPECIES     SEPALLENGTH    SEPALWIDTH    PETALLENGTH    PETALWIDTH                                             */
/*                                                                                                                        */
/*   1    VIRGINICA         77            38             67            22                                                 */
/*   2    VIRGINICA         76            30             66            21                                                 */
/*   3    VIRGINICA         79            38             64            20                                                 */
/*   4    VIRGINICA         77            28             67            20                                                 */
/*   5    VIRGINICA         72            32             60            18                                                 */
/*   6    VIRGINICA         77            30             61            23                                                 */
/*   7    VIRGINICA         72            30             58            16                                                 */
/*   8    VIRGINICA         71            30             59            21                                                 */
/*   9    VIRGINICA         77            26             69            23                                                 */
/*  10    VIRGINICA         74            28             61            19                                                 */
/*  11    VIRGINICA         73            29             63            18                                                 */
/*  12    VIRGINICA         72            36             61            25                                                 */
/*                                                                                                                        */
/**************************************************************************************************************************/



 /*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
