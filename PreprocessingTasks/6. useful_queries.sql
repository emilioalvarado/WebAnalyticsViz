/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 10
	   [sequence_number]
      ,[event]
      ,[user_ipaddress]
      ,[user_id]
      ,[domain_userid]
      ,[domain_sessionid]
      ,[dvce_tstamp]
      ,[page_title]
      ,[page_urlhost]
      ,[page_urlpath]
      ,[page_url]
      ,[page_referrer]
       ,[refr_urlhost]
      ,[refr_urlpath]
      ,[refr_source]
      ,[refr_medium]
      , sunburst_page
  FROM [WEBTRACKING].[dbo].[VW_SUBSET]
  
  
  -- Tomar page_url y recortar https://voicebunny.com/users/#/signin
  -- para obtener: 'users'
--PATINDEX('%/%', page_url)

-- Sentencia para obtener el primer sitio visitado
SELECT --TOP 100 
		page_urlhost, page_url, page_urlpath 
		, PATINDEX('%'+page_urlhost+'%', page_url) as inicio
		, SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url)) as cadena
		, PATINDEX('%/%', SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url))) as fin
		, SUBSTRING(SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url)),
					 1, 
					 PATINDEX('%/%', SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url)))-1) as URL
FROM [WEBTRACKING].[dbo].[VW_SUBSET]
WHERE PATINDEX('%/%', SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url))) > 0
AND USER_ID = 70659
ORDER BY dvce_tstamp


-- Sentencia para encontrar los valores únicos de URL para el sunburst
SELECT DISTINCT SUBSTRING(SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url)),
					 1, 
					 PATINDEX('%/%', SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url)))-1) as URL
FROM [WEBTRACKING].[dbo].[VW_SUBSET]
WHERE PATINDEX('%/%', SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url))) > 0
AND USER_ID = 70659

-- Se agrupan los valores que tienen 'dashboard' con más caracteres
SELECT DISTINCT NEWURL = 
      CASE 
         WHEN PATINDEX('%dashboard%',
						SUBSTRING(SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url)),
					    1, 
					    PATINDEX('%/%', SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url)))-1) 
					) > 0 THEN 'dashboard'  
         ELSE SUBSTRING(SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url)),
					 1, 
					 PATINDEX('%/%', SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url)))-1)
      END
FROM [WEBTRACKING].[dbo].[VW_SUBSET]
WHERE PATINDEX('%/%', SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url))) > 0
AND USER_ID = 70659


-- Se agrega campo para colocar el nombre de la pagina que luego será el path del sunburst
ALTER TABLE DATA_SET ADD sunburst_page varchar(200) null


-- Se actualizan los valores del nuevo campo
BEGIN TRAN
UPDATE DATA_SET
SET sunburst_page = CASE 
						 WHEN PATINDEX('%dashboard%',
										SUBSTRING(SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url)),
										1, 
										PATINDEX('%/%', SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url)))-1) 
									) > 0 THEN 'dashboard'  
						 ELSE SUBSTRING(SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url)),
									 1, 
									 PATINDEX('%/%', SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url)))-1)
					  END
FROM WEBTRACKING.dbo.DATA_SET
WHERE PATINDEX('%/%', SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url))) > 0

-- (795190 row(s) affected)
COMMIT TRAN


-- Se identifican registros que si tienen page_urlpath pero no fueron actualizados en la anterior sentencia
SELECT page_urlhost, page_url, page_urlpath, SUBSTRING(page_urlpath, 2, LEN(page_urlpath)), PATINDEX('%/%', SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url)))
FROM WEBTRACKING.dbo.DATA_SET (NOLOCK)
WHERE sunburst_page is null
AND		len(page_urlpath) > 1


BEGIN TRAN
UPDATE DATA_SET
SET sunburst_page = SUBSTRING(page_urlpath, 2, LEN(page_urlpath))
FROM WEBTRACKING.dbo.DATA_SET
WHERE sunburst_page is null
AND		len(page_urlpath) > 1

-- (3809 row(s) affected)
COMMIT TRAN



-- Los siguientes registros serán excluidos por no tener información suficiente en el page_url
SELECT page_urlhost, page_url, page_urlpath, SUBSTRING(page_urlpath, 2, LEN(page_urlpath)), PATINDEX('%/%', SUBSTRING(page_url, PATINDEX('%'+page_urlhost+'%', page_url) + LEN(page_urlhost) + 1, LEN(page_url)))
FROM WEBTRACKING.dbo.DATA_SET (NOLOCK)
WHERE sunburst_page is null
-- (68695 row(s) affected)


-- SET DE DATOS DE LA VISTA
SELECT TOP 100
		*
FROM WEBTRACKING.dbo.VW_SUBSET


-- Primer cursor para extracción de datos
SELECT domain_sessionid, domain_userid, user_id, 
		sunburst_page, COUNT(*) as visit_number
FROM [WEBTRACKING].[dbo].[VW_SUBSET]
WHERE USER_ID = 70659
GROUP BY domain_sessionid, domain_userid, user_id, 
			sunburst_page
ORDER BY visit_number DESC


-- Analisis de datos de la sesión '28de82d8-d8dc-4087-b4ac-81bdcb57d8d0'
SELECT 	user_id
	  ,domain_userid
	  ,domain_sessionid
	  ,dvce_tstamp
	  ,page_title
	  ,page_urlhost
	  ,page_urlpath
	  ,page_url
	  , sunburst_page
FROM VW_SUBSET
--WHERE domain_sessionid = '28de82d8-d8dc-4087-b4ac-81bdcb57d8d0'
WHERE domain_sessionid = '89fcd34e-989b-4bba-8480-29b1160efec7'
ORDER BY domain_userid, domain_sessionid, dvce_tstamp ASC


75841123-63ab-41e3-8667-dc0609e4b97a
89fcd34e-989b-4bba-8480-29b1160efec7
5a266c68-8cc2-4cc9-a3d8-dbf656df8de2

-- Conteo para este ejemplo de la sesión '28de82d8-d8dc-4087-b4ac-81bdcb57d8d0'
SELECT domain_sessionid, domain_userid, user_id, 
		sunburst_page, COUNT(*) as visit_number
FROM [WEBTRACKING].[dbo].[VW_SUBSET]
WHERE domain_sessionid = '28de82d8-d8dc-4087-b4ac-81bdcb57d8d0'
GROUP BY domain_sessionid, domain_userid, user_id, 
			sunburst_page
ORDER BY visit_number DESC

domain_sessionid	domain_userid	user_id	sunburst_page	visit_number
28de82d8-d8dc-4087-b4ac-81bdcb57d8d0	d9717ae01dd6272a	66505	admin	152
28de82d8-d8dc-4087-b4ac-81bdcb57d8d0	d9717ae01dd6272a	66505	search	10
28de82d8-d8dc-4087-b4ac-81bdcb57d8d0	d9717ae01dd6272a	66505	projects	4
28de82d8-d8dc-4087-b4ac-81bdcb57d8d0	d9717ae01dd6272a	66505	samples	1


SELECT DISTINCT sunburst_page, COUNT(*) as visit_number
FROM [WEBTRACKING].[dbo].[VW_SUBSET]
WHERE domain_sessionid = '28de82d8-d8dc-4087-b4ac-81bdcb57d8d0'
GROUP BY sunburst_page
ORDER BY visit_number DESC




admin
search
admin
samples
admin
projects
admin
search
admin
search
admin
projects
admin
projects
admin
search
admin
search
admin


--- Se ejecuta el SP que trae los datos para el path de navegación
DECLARE @RC int
DECLARE @opcion int

-- TODO: Set parameter values here.

EXECUTE @RC = [WEBTRACKING].[dbo].[SP_PATH_DATA] 
   @opcion
GO


-- Sentencia para obtener el aggregated_dataset
SELECT 	user_id	  , domain_userid  ,domain_sessionid	  ,dvce_tstamp	  	  ,page_url	  , sunburst_page, navpath
FROM PATH_DATA (NOLOCK)
--WHERE domain_sessionid in ('28de82d8-d8dc-4087-b4ac-81bdcb57d8d0', '89fcd34e-989b-4bba-8480-29b1160efec7')
ORDER BY domain_sessionid, dvce_tstamp


-- TRUNCATE TABLE PATH_DATA

SELECT user_id	  ,domain_userid  ,domain_sessionid	  ,dvce_tstamp	  	  ,page_url	  , sunburst_page
FROM DATA_SET (NOLOCK) 
--WHERE domain_sessionid in ('28de82d8-d8dc-4087-b4ac-81bdcb57d8d0', '89fcd34e-989b-4bba-8480-29b1160efec7')
ORDER BY domain_sessionid, dvce_tstamp


-- Sentencia para obtener el detailed_subset
SELECT user_id	  ,domain_userid  ,domain_sessionid	  ,dvce_tstamp	  	  ,page_url	  , sunburst_page
FROM VW_SUBSET (NOLOCK) 
WHERE domain_sessionid in (
	SELECT DISTINCT domain_sessionid
	FROM PATH_DATA (NOLOCK)
)
--and domain_sessionid in ('28de82d8-d8dc-4087-b4ac-81bdcb57d8d0', '89fcd34e-989b-4bba-8480-29b1160efec7')
ORDER BY domain_sessionid, dvce_tstamp


SELECT user_id	  ,domain_userid  ,domain_sessionid	  ,dvce_tstamp	  	  ,page_url	  , sunburst_page, navpath
--SELECT DISTINCT user_id
--SELECT USER_ID, COUNT(*)
FROM PATH_DATA (NOLOCK) 
WHERE navpath = 'users-dashboard-users' 
AND USER_ID = 31195
GROUP BY USER_ID
ORDER BY domain_sessionid, dvce_tstamp


SELECT user_id	  ,domain_userid  ,domain_sessionid	  ,dvce_tstamp	  	  ,page_url	  , sunburst_page
FROM VW_SUBSET (NOLOCK) 
WHERE domain_sessionid = 'c3d4dd30-fa9c-46e1-adea-e48a687e3c63'
USER_ID = 8109
ORDER BY dvce_tstamp

-- Lista de valores unicos de pagina
SELECT sunburst_page as page, COUNT(*) as count
FROM PATH_DATA (NOLOCK)
GROUP BY sunburst_page
ORDER BY count desc


-- Estoy trabajando con
'28de82d8-d8dc-4087-b4ac-81bdcb57d8d0', '89fcd34e-989b-4bba-8480-29b1160efec7')
Insertando... search-admin-samples-admin-projects-admin-search-admin-search-admin-projects-admin-projects-admin-search-admin-search-admin
Insertando... dashboard-projects-dashboard-projects-reads-projects



--- Se ejecuta el SP que trae el path de navegación armado
DECLARE @RC int
DECLARE @opcion int

-- TODO: Set parameter values here.

EXECUTE @RC = [WEBTRACKING].[dbo].[SP_SUNBURST_DATA] 
   @opcion
GO


SELECT * FROM SUNBURST_DATA (NOLOCK)
-- TRUNCATE TABLE SUNBURST_DATA 

SELECT REPLACE ( 'h1-Welcome-Powtoon-users-h2-Get-a-voice-over-today-and-save-money-on-your-first-project' , '-' , '.')  
REPLACE('h1-Welcome-Powtoon-users-h2-Get-a-voice-over-today-and-save-money-on-your-first-project')

-- Datos para construir el sunburst
SELECT --TOP 100
		navpath, COUNT(*) as visits
FROM SUNBURST_DATA (NOLOCK)
--WHERE --navpath not like '%h1.Welcome%' AND
		--LEN(navpath) <= 100
GROUP BY navpath
--HAVING COUNT(*) > 1
--ORDER BY LEN(navpath) DESC
ORDER BY COUNT(*) DESC



SELECT MAX(LEN(navpath))
FROM SUNBURST_DATA (NOLOCK)
