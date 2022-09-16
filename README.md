
# web3-analytics-demo

<img src="hero.png" width="400"/>

This repo contains a small example game. The purpose is to demonstrate how to
integrate Google Analytics with a web3 dApp.

The game is simple. On page-load, two NFTs from a collection (preconfigured)
appear side by side, and the player can click either of them. The clicked item
receives `+1` points, and the unclicked item receives `-1` points. Two new NFTs
are selected at random, and the gameplay continues.

There are three possible things that can happen during gameplay, related to the
web3 wallet status.

## Game modes

1. If the user doesn't have - or has not connected - a web3 wallet, gameplay
events are logged to Google Analytics like an ordinary web2 game.
2. If the user has connected a web3 wallet, events are logged to Google
Analytics along with the user's web3 wallet address.
3. As a variant of (2), when a web3 wallet is connected the user can
optionally to have their vote recorded on-chain.

## Game components

![](web3-analytics-demo.png)

The game consists of 3 parts:

* [appengine](./appengine) - HTML/CSS/JS assets for the client-side game logic
* [solidity](./solidity) - Solidity assets for the on-chain game logic (simply
  keeps track of wins/losses per NFT)
* [bigquery](./bigquery) - SQL queries for analyzing game play data. This
  requires the deployment's linked Google Analytics property to have BigQuery
  export enabled. The example [combined.sql](./bigquery/combined.sql) leverages
  the Polygon public dataset in BigQuery to join Google Analytics events with
  on-chain events where possible (see game mode 1, above).

## Development / Deployment

### working with NodeJS / Google AppEngine

```
cd appengine

# install node dependencies
npm install

# run a local dev server on $PORT (default 3000)
#npm run start

# deploy to appengine
npm run deploy
```

### Using Web3Auth on a real domain.

- By default this example will work only on localhost.

- If You want to host this example on any domain. You need to get Web3Auth clientId, configure a Web3Auth verifier for firebase from `https://dashboard.web3auth.io`  and configure your domain's firebase config on firebase console.

- After configuring, replace the config in appengine/public/config.js file with your own firebase and web3auth config.


### deploying on-chain

TODO
- document testnet we're using (Polgyon Mumbai preferred)
  - test faucet(s)
- how to deploy the contract
  - capture contract address to index.html
  - capture ABI to index.html

### integrating with Google Analytics

TODO
- how to get a GA property ID
  - place property ID in index.html
  - capture wallet address as a GA event

## Analytics

### merging Google Analytics data with Crypto Public Datasets

TODO
- [Polygon Public Dataset in Google BigQuery](https://console.cloud.google.com/marketplace/product/public-data-finance/crypto-polygon-dataset?project=public-data-finance) *public-data-finance:crypto_polygon*
- [GA4 BQ streaming export](https://support.google.com/analytics/answer/9823238#step3&zippy=%2Cin-this-article)
- Google Data Studio
