importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyAhRG-Uoie2bJwQja2tBUvMZwHFHUSK05A",
  authDomain: "dieayap-793dd.firebaseapp.com",
  projectId: "dieayap-793dd",
  storageBucket: "dieayap-793dd.firebasestorage.app",
  messagingSenderId: "843945680710",
  appId: "1:843945680710:web:db90bf74a0963d236c4f47",
});

const messaging = firebase.messaging();
