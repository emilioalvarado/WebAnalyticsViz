USE WEBTRACKING 
GO
/****** Object:  StoredProcedure [dbo].[SP_DATAFRAME_CLIENTES]    Script Date: 11/26/2016 20:30:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SP_PATH_DATA] 
	-- Add the parameters for the stored procedure here
	@opcion int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE 
	-- BASICOS
	@user_id	varchar(256),
	@domain_userid	varchar(256),
	@domain_sessionid	varchar(256),
	@dvce_tstamp datetime,
	@page_title	varchar(1024),
	@page_urlhost	varchar(256),
	@page_urlpath	varchar(512),
	@page_url	varchar(8000),
	@sunburst_page varchar(200),
	@current_page varchar(200)
		
		
	SELECT @current_page = '';
	
    -- Cursor que devuelve los datos de navegación por session y usuario, ordenados por fecha-hora
    DECLARE vinc_cursor CURSOR FOR   
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
	--WHERE domain_sessionid = '89fcd34e-989b-4bba-8480-29b1160efec7'
	ORDER BY domain_userid, domain_sessionid, dvce_tstamp ASC
	  
	OPEN vinc_cursor  
	  
	FETCH NEXT FROM vinc_cursor   
	INTO	@user_id,
			@domain_userid	,
			@domain_sessionid	,
			@dvce_tstamp ,
			@page_title	,
			@page_urlhost	,
			@page_urlpath	,
			@page_url	,
			@sunburst_page 
	  
	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		
		IF @sunburst_page <> @current_page
		BEGIN
		
			-- Insertando los datos del path de navegación
			INSERT INTO dbo.PATH_DATA(
				user_id	,
				domain_userid	,
				domain_sessionid	,
				dvce_tstamp ,
				page_title	,
				page_urlhost	,
				page_urlpath	,
				page_url	,
				sunburst_page 
			)
			VALUES(
				@user_id	,
				@domain_userid	,
				@domain_sessionid	,
				@dvce_tstamp ,
				@page_title	,
				@page_urlhost	,
				@page_urlpath	,
				@page_url	,
				@sunburst_page 
			)
	  
		END
		
	    SELECT @current_page = @sunburst_page;
	   
		-- Declare an inner cursor based     
		-- on vendor_id from the outer cursor.  
	  
		
		FETCH NEXT FROM vinc_cursor   
		INTO	@user_id,
				@domain_userid	,
				@domain_sessionid	,
				@dvce_tstamp ,
				@page_title	,
				@page_urlhost	,
				@page_urlpath	,
				@page_url	,
				@sunburst_page 
	END   
	CLOSE vinc_cursor;  
	DEALLOCATE vinc_cursor;  
    
END
