SELECT *
FROM `public-data-finance.crypto_polygon.transactions` 
WHERE from_address = "0x0c854db3034d33c0d7b31170188aae8fc5af56ea"
AND DATE(block_timestamp) > "2022-02-23" 

