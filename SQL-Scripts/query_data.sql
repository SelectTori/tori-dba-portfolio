/*
-----------------------------------------------
  Created by: Torian Knox
  Created on: 8/13/2025
  Description: Verifying data
-----------------------------------------------
*/
USE GrantsDB
GO


-- Row counts by table
select 'Providers' Table_Name, count(*) Record_Count from Providers UNION ALL
select 'Families', count(*) from Families UNION ALL
select 'Children', count(*) from Children UNION ALL
select 'Applications', count(*) from Applications UNION ALL
select 'Awards', count(*) from Awards UNION ALL
select 'Disbursements', count(*) from Disbursements UNION ALL
select 'FundingSources', count(*) from FundingSources
order by Record_Count desc

-- Approved apps vs others
select Status, count(*) Cnt
from Applications
group by Status

-- Updating FiscalYear
select * from FundingSources

update FundingSources
set FiscalYear = '2025'
where FundingID in (1,2)

-- Creating KPI view: monthly disbursements by funding source
create view vw_MonthlyDisbursements as
(select
  d.PeriodMonth,
  fs.Name        AS FundingSource,
  sum(d.PaidAmount) AS TotalPaid
from Disbursements d
JOIN Awards a ON a.AwardID = d.AwardID
JOIN FundingSources fs ON fs.FundingID = a.FundingID
group by d.PeriodMonth, fs.Name)

select * from vw_MonthlyDisbursements ORDER BY PeriodMonth, FundingSource

