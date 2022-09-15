WITH
customer AS ( --for demo purposes
  SELECT "0x0c854db3034d33c0d7b31170188aae8fc5af56ea" AS wallet
),
onchain AS (
  SELECT *
  FROM `public-data-finance.crypto_polygon.transactions`, customer
  WHERE from_address = customer.wallet
  AND DATE(block_timestamp) > "2022-02-23" 
),
offchain AS (
  SELECT event_timestamp,items
  FROM `web3-analytics-demo.analytics_304846371.events_intraday_20220225` AS events JOIN UNNEST(items) AS items, customer
  WHERE items.affiliation = customer.wallet
  AND event_name = 'select_item'
  AND event_timestamp > 1645721013034912 -- for demo purposes
)

SELECT 
  offchain.event_timestamp,
  -- ecommerce from GA4
  REGEXP_REPLACE(offchain.items.item_list_name,"^votes:","") AS nft_collection, -- NFT collection ID
  offchain.items.item_id AS nft_id, -- NFT ID
  offchain.items.affiliation AS player_id, --customer wallet
  offchain.items.quantity AS vote, -- upvote/downvote

  -- transaction data from BQ Public Datasets
  onchain.hash AS transaction_id, -- unique id of this tx
  onchain.input -- same data as above, formatted for smart contract storage
FROM
  onchain, --polygon blockchain
  offchain, --google analytics
  customer --customer of interest (for demo purpose)
WHERE
  offchain.items.affiliation = customer.wallet
  AND (
    onchain.from_address = customer.wallet 
    -- for customer 360, examine NFT holdings, etc
    --   OR
    -- onchain.to_address = customer.wallet
  )
