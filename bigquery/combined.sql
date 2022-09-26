WITH
onchain AS (
  SELECT *,
  CAST(CAST(REGEXP_REPLACE(CONCAT('0x',SUBSTR(input,75,64)),'x0+','x') AS INT64) AS STRING) AS vote_for,
  CAST(CAST(REGEXP_REPLACE(CONCAT('0x',SUBSTR(input,75+64,64)),'x0+','x') AS INT64) AS STRING) AS vote_against
  FROM `public-data-finance.crypto_polygon.transactions`
  WHERE TRUE
  -- AND DATE(block_timestamp) > "2022-02-23" 

  -- uncomment this join only against the last day of on-chain data
  AND DATE(block_timestamp) = EXTRACT(DATE FROM CURRENT_TIMESTAMP())
  AND to_address = '0xd295fa4917aac94ee05f22316df10dc7be20946b'
),
offchain AS (
  SELECT
    event_timestamp,
    user_pseudo_id,
    device,
    geo,
    event_name,
    event_params,
    items,
    CAST(items.item_id AS INT64) AS item_id,
    REGEXP_REPLACE(items.item_list_name,"^votes:","") AS nft_collection, -- NFT collection ID
    items.affiliation AS player_id, --customer wallet
    CASE WHEN items.quantity = 1 THEN 1 ELSE 0 END AS vote
    -- items.quantity AS vote -- upvote/downvote

  FROM `web3-analytics-demo.analytics_304846371.*` AS events JOIN UNNEST(items) AS items 
  WHERE TRUE
  AND event_name = 'select_item'
),
leaderboard AS (
  SELECT item_id, SUM(vote) AS wins, COUNT(vote) AS trials, SAFE_DIVIDE(SUM(vote),COUNT(vote)) AS winrate
  FROM offchain
  GROUP BY item_id
  HAVING trials >= 3
  ORDER BY winrate DESC, wins DESC
)

SELECT 
  -- ecommerce from GA4
  -- ABBREVIATED DATA
  offchain.user_pseudo_id, -- GA ID
  offchain.player_id, --user wallet
  offchain.items.item_id, -- voted item
  offchain.vote, -- upvote/downvote
  TIMESTAMP_MICROS(offchain.event_timestamp) AS event_timestamp,
  device.mobile_brand_name AS device_brand,
  device.language AS device_language,
  --geo.country AS geo_country,
  geo,
  -- EXTENDED DATA
  -- offchain.user_pseudo_id, -- GA ID
  -- offchain.player_id, --user wallet
  -- offchain.vote, -- upvote/downvote
  -- offchain.nft_collection, -- NFT collection ID
  -- offchain.event_timestamp,
  -- offchain.device, -- device attributes
  -- offchain.geo, --  device location
  -- offchain.items, -- ecommerce data (used here for in-browser gameplay events)
  -- offchain.event_name, --  off-chain event attributes
  -- offchain.event_params, --  off-chain event attributes

  -- transaction data from BQ Public Datasets
  onchain.hash AS transaction_id, -- unique id of this tx
  -- EXTENDED DATA
  -- onchain.input -- same data as above, formatted for smart contract storage
  leaderboard.wins,
  leaderboard.trials,
  leaderboard.winrate
FROM
  leaderboard,
  offchain LEFT JOIN onchain ON 
  (offchain.player_id = onchain.from_address 
    AND 
    (
      (offchain.items.item_id = onchain.vote_for AND offchain.vote = 1)
      OR
      (offchain.items.item_id = onchain.vote_against AND offchain.vote = -1)
    )
  )
  AND CAST(offchain.items.item_id AS INT64) BETWEEN 1 AND 1024
WHERE TRUE
  AND leaderboard.item_id = offchain.item_id
  -- uncomment this to show only events from web3-connected devices
  -- AND player_id != '[no wallet]'
ORDER BY event_timestamp DESC
