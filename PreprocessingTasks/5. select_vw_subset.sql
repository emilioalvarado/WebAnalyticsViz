/****** Script for SelectTopNRows command from SSMS  ******/
SELECT --TOP 5
		[sequence_number]
      ,[event]
      ,[user_ipaddress]
      ,[user_id]
      ,[domain_userid]
      ,[domain_sessionid]
      ,[dvce_tstamp]
      ,[page_title]
      ,[page_urlhost]
      ,[refr_urlhost]
      ,[refr_urlpath]
      ,[page_urlpath]
      ,[page_url]
      ,[page_referrer]
      ,[refr_source]
      ,[refr_medium]
      , sunburst_page
  FROM [WEBTRACKING].[dbo].[VW_SUBSET]