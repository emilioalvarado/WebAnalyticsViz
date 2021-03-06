USE [WEBTRACKING]
GO
/****** Object:  StoredProcedure [dbo].[SP_PATH_DATA]    Script Date: 11/26/2016 22:37:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SP_SUNBURST_DATA] 
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
	@current_page varchar(2000),
	@current_domain_sessionid	varchar(256)
		
		
	SELECT @current_page = '';
	SELECT @current_domain_sessionid = '';
	
    -- Cursor que devuelve los datos de navegación por session y usuario, ordenados por fecha-hora
    DECLARE vinc_cursor CURSOR FOR   
	SELECT 	user_id
		  --,domain_userid
		  ,domain_sessionid
		  ,dvce_tstamp
		  --,page_title
		  --,page_urlhost
		  --,page_urlpath
		  ,page_url
		  , REPLACE ( sunburst_page, '-' , '.')  as sunburst_page
	FROM PATH_DATA (NOLOCK)
	--WHERE domain_sessionid in ('28de82d8-d8dc-4087-b4ac-81bdcb57d8d0', '89fcd34e-989b-4bba-8480-29b1160efec7')
	ORDER BY domain_sessionid, dvce_tstamp ASC
	  
	OPEN vinc_cursor  
	  
	FETCH NEXT FROM vinc_cursor   
	INTO	@user_id,
			--@domain_userid	,
			@domain_sessionid	,
			@dvce_tstamp ,
			--@page_title	,
			--@page_urlhost	,
			--@page_urlpath	,
			@page_url	,
			@sunburst_page 
	  
	WHILE @@FETCH_STATUS = 0  
	BEGIN  
		-- print @domain_sessionid + ' -  ' + @current_domain_sessionid + ' - ' + @sunburst_page
		SELECT @sunburst_page = CASE
				WHEN @sunburst_page = 'h1.Welcome.Powtoon.users.h2.Get.a.voice.over.today.and.save.money.on.your.first.project'
						THEN 'h1.Welcome.Powtoon.users'
				WHEN @sunburst_page =  'h1.Welcome.GoAnimate.users.h2.Get.a.voice.over.today.and.save.money.on.your.first.project'
						THEN 'h1.Welcome.GoAnimate.users'
				WHEN @sunburst_page =  'h1.Welcome.Wideo.users.h2.Get.a.voice.over.today.and.save.money.on.your.first.project'
						THEN 'h1.Welcome.Wideo.users'
				WHEN @sunburst_page =  'h1.Welcome.Envato.users.h2.Get.a.voice.over.today.and.save.money.on.your.first.project'
						THEN 'h1.Welcome.Envato.users'
				WHEN @sunburst_page =  'b.Welcome.GroundedAnimate.users.h2.Get.a.voice.over.today.and.save.money.on.your.first.project'
						THEN 'b.Welcome.GroundedAnimate.users'
				WHEN @sunburst_page =  'h1.Welcome.GroundedAnimate.users.h2.Get.a.voice.over.today.and.save.money.on.your.first.project'
						THEN 'h1.Welcome.GroundedAnimate.users'
				ELSE @sunburst_page
		END

		
		-- En la primera iteración el @current_domain_sessionid es vacío
		IF @current_domain_sessionid = ''
		BEGIN
		---- print '@current_domain_sessionid vacío'
			SELECT @current_domain_sessionid = @domain_sessionid
		END
		
		-- Se usa el @domain_sessionid para construir el path de navegación
		IF @domain_sessionid = @current_domain_sessionid
		BEGIN
			
			-- Se construye el path de navegación con @sunburst_page
			IF LEN(@current_page)=0
			BEGIN
				---- print '@@current_page vacío'
				SELECT @current_page = @sunburst_page
				-- print 'inicio current_page: ' + @current_page
			END
			ELSE
			BEGIN
				SELECT @current_page = @current_page + '-' + @sunburst_page
				-- print 'current_page: ' + @current_page
			END
			
		END
		-- Cuando cambia el @domain_sessionid se inserta el registro, se inicializan las variables 
		-- y se construye un nuevo path en @sunburst_page
		ELSE
		BEGIN
			
			-- print 'Insertando... ' + @current_page
			-- Insertando los datos del path de navegación
			INSERT INTO dbo.SUNBURST_DATA(
				navpath
			)
			VALUES(
				@current_page 
			)
			
			UPDATE PATH_DATA
			SET navpath = @current_page
			WHERE domain_sessionid = @current_domain_sessionid
			AND navpath IS NULL;
			
			
			SELECT @current_page = @sunburst_page;
			SELECT @current_domain_sessionid = '';
			
		
		END
		
		SELECT @current_domain_sessionid = @domain_sessionid
				
		FETCH NEXT FROM vinc_cursor   
		INTO	@user_id,
				--@domain_userid	,
				@domain_sessionid	,
				@dvce_tstamp ,
				--@page_title	,
				--@page_urlhost	,
				--@page_urlpath	,
				@page_url	,
				@sunburst_page 
	END   
	CLOSE vinc_cursor;  
	DEALLOCATE vinc_cursor;  
	
	-- Se inserta el último registro luego de salir del cursor
	-- print 'Insertando... ' + @current_page
	-- Insertando los datos del path de navegación
	INSERT INTO dbo.SUNBURST_DATA(
		navpath
	)
	VALUES(
		@current_page 
	)
	
	UPDATE PATH_DATA
	SET navpath = @current_page
	WHERE domain_sessionid = @current_domain_sessionid
	AND navpath IS NULL;
    
END
