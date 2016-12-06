USE [WEBTRACKING]
GO


CREATE TABLE PATH_DATA(
	user_id	varchar(256),
	domain_userid	varchar(256),
	domain_sessionid	varchar(256),
	dvce_tstamp datetime,
	page_title	varchar(1024),
	page_urlhost	varchar(256),
	page_urlpath	varchar(512),
	page_url	varchar(8000),
	sunburst_page varchar(200),
	navpath varchar(2000),
)

/****** Object:  Index [IDX_PATHDATA_DOMAINSESSIONID]    Script Date: 11/27/2016 19:56:12 ******/
CREATE NONCLUSTERED INDEX [IDX_PATHDATA_DOMAINSESSIONID] ON [dbo].[PATH_DATA] 
(
	[domain_sessionid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


