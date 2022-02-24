SELECT event_timestamp,items FROM `web3-analytics-demo.analytics_304846371.events_intraday_20220225` 
WHERE event_name = 'select_item' AND event_timestamp > 1645721013034912
ORDER BY event_timestamp LIMIT 1000
