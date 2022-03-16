# web3-analytics-demo

## working with NodeJS / Google AppEngine

```
cd appengine

# install node dependencies
npm install

# run a local dev server on $PORT (default 3000)
#npm run start

# deploy to appengine
npm run deploy
```

# Using Web3Auth on a real domain.

- By default this example will work only on localhost.

- If You want to host this example on any domain. You need to get Web3Auth clientId, configure a Web3Auth verifier for firebase from `https://dashboard.web3auth.io`  and configure your domain's firebase config on firebase console.

- After configuring, replace the config in appengine/public/config.js file with your own firebase and web3auth config.


## deploying on-chain

TODO
- document testnet we're using (Polgyon Mumbai preferred)
  - test faucet(s)
- how to deploy the contract
  - capture contract address to index.html
  - capture ABI to index.html

## integrating with Google Analytics

TODO
- how to get a GA property ID
  - place property ID in index.html
  - capture wallet address as a GA event

## merging Google Analytics data with Crypto Public Datasets

TODO
- [Polygon Public Dataset in Google BigQuery](https://console.cloud.google.com/marketplace/product/public-data-finance/crypto-polygon-dataset?project=public-data-finance) *public-data-finance:crypto_polygon*
- [GA4 BQ streaming export](https://support.google.com/analytics/answer/9823238#step3&zippy=%2Cin-this-article)
- Google Data Studio
