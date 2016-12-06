/***********************************************************
Es necesario utilizar tab como separador de campos ya que algunos datos contienen ';'
Adicionalmente, es necesario eliminar las comillas dobles de los datos ya que los de tipo
numérico no cargan con estas comillas.

OJO: se deja la linea de encabezado con las columnas para facilitar la manipulación del archivo,
esta línea debe eliminarse antes del cargue.
***********************************************************/

BULK INSERT DATA_SET 
   FROM 'D:\temp\VA\dataset.txt'  
   WITH   
      (  
         FIELDTERMINATOR ='\t',  
         ROWTERMINATOR ='\n'  
      );  



/*********************************************************************************************
Es necesario limpiar estas líneas en la columna page_title porque contienen caracteres invalidos
que ocasionan falla en el proceso de cargue:

Msg 4863, Level 16, State 1, Line 7
Bulk load data conversion error (truncation) for row 5373, column 61 (page_title).
Msg 4863, Level 16, State 1, Line 7
Bulk load data conversion error (truncation) for row 47003, column 61 (page_title).
Msg 4863, Level 16, State 1, Line 7
Bulk load data conversion error (truncation) for row 47005, column 61 (page_title).
Msg 4863, Level 16, State 1, Line 7
Bulk load data conversion error (truncation) for row 189151, column 61 (page_title).
Msg 4863, Level 16, State 1, Line 7
Bulk load data conversion error (truncation) for row 191907, column 61 (page_title).
Msg 4863, Level 16, State 1, Line 7
Bulk load data conversion error (truncation) for row 191913, column 61 (page_title).
Msg 4863, Level 16, State 1, Line 7
Bulk load data conversion error (truncation) for row 210624, column 61 (page_title).
Msg 4863, Level 16, State 1, Line 7
Bulk load data conversion error (truncation) for row 238803, column 61 (page_title).
Msg 4863, Level 16, State 1, Line 7
Bulk load data conversion error (truncation) for row 256267, column 61 (page_title).
Msg 4863, Level 16, State 1, Line 7
Bulk load data conversion error (truncation) for row 258322, column 61 (page_title).
Msg 4863, Level 16, State 1, Line 7
Bulk load data conversion error (truncation) for row 284122, column 61 (page_title).
Msg 4865, Level 16, State 1, Line 7
Cannot bulk load because the maximum number of errors (10) was exceeded.
Msg 7399, Level 16, State 1, Line 7
The OLE DB provider "BULK" for linked server "(null)" reported an error. The provider did not give any information about the error.
Msg 7330, Level 16, State 2, Line 7
Cannot fetch a row from OLE DB provider "BULK" for linked server "(null)".


---- Luego de la limpieza:

(867694 row(s) affected)


-- Por alguna razon la primera fila queda con un caracter especial:
  
  SELECT *
  FROM DATA_SET (NOLOCK)
  WHERE sequence_number = '´++49556488190729371027578760004582998527602555422563631106'
    
  
  UPDATE DATA_SET
  SET sequence_number = '49556488190729371027578760004582998527602555422563631106'
  WHERE sequence_number = '´++49556488190729371027578760004582998527602555422563631106'
  
  

*/