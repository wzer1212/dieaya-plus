// This Service Worker handles Firebase Cloud Messaging
importScripts('https://www.gstatic.com/firebasejs/10.8.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.8.0/firebase-messaging-compat.js');

// Initialize Firebase
firebase.initializeApp({
  apiKey: 'AIzaSyDa2dgLmTivMPoMHECV8DqEV-yTatgc2LE',
  appId: '1:599093109994:web:736f4de54905c6d1d3a393',
  messagingSenderId: '599093109994',
  projectId: 'abd-el-rahman1',
  authDomain: 'abd-el-rahman1.firebaseapp.com',
  storageBucket: 'abd-el-rahman1.firebasestorage.app',
  measurementId: 'G-HCPNLR38BS',
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png',
  };
  self.registration.showNotification(notificationTitle, notificationOptions);
});
