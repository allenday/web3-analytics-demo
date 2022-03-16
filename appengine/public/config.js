
/**
* Get clientId from the project you created under Plug n Play
* on Web3Auth Developer Dashboard https://dashboard.web3auth.io/
*/
const clientId = "BKPxkCtfC9gZ5dj-eg-W6yb5Xfr3XkxHuGZl2o2Bn8gKQ7UYike9Dh6c-_LaXlUN77x0cBoPwcSx-IVm0llVsLA";

 // get your firebase config from firebase console
 const firebaseConfig = {
     apiKey: "AIzaSyCkbfXYqxw7ygo-XxfAt866Yja4jNs31Po",
     authDomain: "web3auth-firebase.firebaseapp.com",
     projectId: "web3auth-firebase",
     storageBucket: "web3auth-firebase.appspot.com",
     messagingSenderId: "707643268846",
     appId: "1:707643268846:web:6d92e69726852a38e39dff",
     measurementId: "G-V631CSBMVY",
 };
 

// Initialize Firebase
firebase.initializeApp(firebaseConfig);