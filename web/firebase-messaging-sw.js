importScripts(
  "https://www.gstatic.com/firebasejs/11.0.2/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/11.0.2/firebase-messaging-compat.js"
);

// Initialize Firebase
firebase.initializeApp({
  apiKey: "AIzaSyC68yXHqqUTiF8ntdi_vPzpdFCBOMtD--Q",
  authDomain: "moapp-toto.firebaseapp.com",
  projectId: "moapp-toto",
  storageBucket: "moapp-toto.firebasestorage.app",
  messagingSenderId: "377762176742",
  appId: "1:377762176742:web:0939baceeecd5b4e786527",
});

// Retrieve an instance of Firebase Messaging
const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
  const promiseChain = clients
    .matchAll({
      type: "window",
      includeUncontrolled: true,
    })
    .then((windowClients) => {
      for (let i = 0; i < windowClients.length; i++) {
        const windowClient = windowClients[i];
        windowClient.postMessage(payload);
      }
    })
    .then(() => {
      return registration.showNotification("New Message");
    });
  return promiseChain;
});
self.addEventListener("notificationclick", function (event) {
  console.log("notification received: ", event);
});
