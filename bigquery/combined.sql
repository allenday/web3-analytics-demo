WITH
onchain AS (
  SELECT *
  FROM `public-data-finance.crypto_polygon.transactions`
  WHERE TRUE
  -- AND DATE(block_timestamp) > "2022-02-23" 

  -- uncomment this join only against the last day of on-chain data
  AND DATE(block_timestamp) = EXTRACT(DATE FROM CURRENT_TIMESTAMP())
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
    REGEXP_REPLACE(items.item_list_name,"^votes:","") AS nft_collection, -- NFT collection ID
    items.affiliation AS player_id, --customer wallet
    items.quantity AS vote -- upvote/downvote

  FROM `web3-analytics-demo.analytics_304846371.*` AS events JOIN UNNEST(items) AS items 
  WHERE TRUE
  AND event_name = 'select_item'
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
  geo.country AS geo_country,
  
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
  onchain.hash AS transaction_id -- unique id of this tx
  -- EXTENDED DATA
  -- onchain.input -- same data as above, formatted for smart contract storage
FROM
  offchain LEFT JOIN onchain ON (offchain.items.affiliation = onchain.from_address)
WHERE TRUE
  -- uncomment this to show only events from web3-connected devices
  -- AND player_id != '[no wallet]'
ORDER BY event_timestamp DESC
