import { initializeApp } from "firebase/app";
import {
  GoogleAuthProvider,
  signInWithRedirect,
  getRedirectResult,
  getAuth,
  signOut,
} from "firebase/auth";

import { firebaseConfig, clientId } from './config'

const Web3Auth = (()=>{
    let web3AuthInstance = null;

    let firebaseApp;
    function getWeb3AuthInstance() {
        if (web3AuthInstance) {
            return web3AuthInstance
        }
        const web3authSdk = window.Core;
        web3AuthInstance  = new web3authSdk.Web3AuthCore({
           chainConfig: { chainNamespace: "eip155", chainId: "0x89" },
           clientId,
       });
       return web3AuthInstance;
    }

    function isConnected() {
        return !!getWeb3AuthInstance().provider;
    }

    function provider() {
        return getWeb3AuthInstance().provider;
    }

    async function disconnect() {
        const auth = getAuth(firebaseApp);
        await signOut(auth)
        return getWeb3AuthInstance().logout();
    }

    async function initWeb3Auth() {    
        const web3AuthInstance = getWeb3AuthInstance();
        const adapter = new OpenloginAdapter.OpenloginAdapter({
            adapterSettings: {
            // network that your verifier was deployed on (e.g. `testnet`, `mainnet`)
            network: "testnet",
            clientId,
            uxMode: "redirect",
            loginConfig: {
                jwt: {
                name: "Custom Firebase Login",
                /**
                 * name of custom verifier that you created on Web3Auth Developer Dashboard
                 * under Custom Auth section
                 */
                verifier: "web3auth-firebase-google",
                typeOfLogin: "jwt",
                clientId,
                },
            },
            redirectUrl: window.location.origin
        },
        });
        web3AuthInstance.configureAdapter(adapter);
        console.log("initWeb3Auth",web3AuthInstance)
        await web3AuthInstance.init();
        window.web3AuthInstance = web3AuthInstance;
    }

    function loginWithWeb3Auth() {
        const auth = getAuth(firebaseApp);

        const googleProvider = new GoogleAuthProvider();
        // rest of flow will be handled in redirect handler
        signInWithRedirect(auth, googleProvider);
    }

    async function _login(adapter, loginProvider, jwtToken) {
        await web3AuthInstance.connectTo(adapter, {
            relogin: true,
            loginProvider,
            extraLoginOptions: {
                id_token: jwtToken,
                domain: window.location.origin,
                verifierIdField: "sub",
            },
        });
    }

    async function connectWithWeb3Auth() {
        if(!isConnected()) return loginWithWeb3Auth()
        const url = new URL(window.location.origin);
        url.pathname = "index.html";
        window.location.href = url.href
        return;
       
    }
    async function firebaseLogin(){
        try {
            const auth = getAuth(firebaseApp);
            console.log("getting redirect result")
            const result = await getRedirectResult(auth)
            console.log("redirect", result?.user)
            if(result?.user) {
                const idToken = await result.user.getIdToken(true)
                console.log("idTOken", idToken)
                await _login("openlogin", "jwt", idToken);
                return
            }
            return connectWithWeb3Auth()

        } catch (error) {
            console.log("error", error)
            const url = new URL(window.location.origin);
            url.pathname = "index.html";
            url.searchParams.append("error", error.message || "Failed to login");
            window.location.href = url.href
        }
       
    }

  const init = async () => {
    // Initialize Firebase
    firebaseApp = initializeApp(firebaseConfig);
    await initWeb3Auth();
  }
  return {
    init,
    getWeb3AuthInstance,
    isConnected,
    disconnect,
    provider,
    loginWithWeb3Auth,
    firebaseLogin,
  }
})()


window.Web3Auth = Web3Auth;