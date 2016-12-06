USE [WEBTRACKING]
GO

/****** Object:  View [dbo].[VW_SUBSET]    Script Date: 11/26/2016 13:22:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[VW_SUBSET]
AS
SELECT     sequence_number, event, user_ipaddress, user_id, domain_userid, domain_sessionid, dvce_tstamp, page_title, page_urlhost, refr_urlhost, refr_urlpath, 
                      page_urlpath, page_url, page_referrer, refr_source, refr_medium, sunburst_page
FROM         dbo.DATA_SET (NOLOCK)
WHERE	event = 'PV'
AND     sunburst_page is not null	

GO


