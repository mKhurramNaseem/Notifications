/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const admin = require('firebase-admin');

const functions = require('firebase-functions');
const { object } = require("firebase-functions/v1/storage");


admin.initializeApp({
    credential : admin.credential.applicationDefault(),
})

exports.onUpload = functions.storage.object().onFinalize((object,context) => {
    const registrationToken = 'eES6tk5KRsyQegotOfm-uY:APA91bFpGEcZzYpTBLdBnBM1r7IzbBc8Zg4Z3Vc2Gv-VLqfBMJi3xcUcsJxpBa5OQu-LOiSrwo9GKy28l5m8itjphJRGoSSN-Zfdd6Ozx8Gm7H1V0kHKMcXFl3MyKEGgh9KsQPDzARuB';    
    const message = {
        notification : {
          title: 'Upload',
          body: '2:45'
        },
        token: registrationToken
      };
      // Send a message to the device corresponding to the provided
      // registration token.
      
      admin.messaging().send(message)
        .then((response) => {
          // Response is a message ID string.
          console.log('Successfully sent message:', response);
        })
        .catch((error) => {
          console.log('Error sending message:', error);
        });
          //   return snap.ref.update({uppercase}, {merge: true});          
});

exports.makeUppercase = functions.firestore.document('/messages/{documentId}')
    .onCreate(async (snap, context) => {
    //   const original = snap.data().original;
    //   console.log('Uppercasing', context.params.documentId, original);
    //   const uppercase = original.toUpperCase();
      // This registration token comes from the client FCM SDKs.
const registrationToken = 'eES6tk5KRsyQegotOfm-uY:APA91bFpGEcZzYpTBLdBnBM1r7IzbBc8Zg4Z3Vc2Gv-VLqfBMJi3xcUcsJxpBa5OQu-LOiSrwo9GKy28l5m8itjphJRGoSSN-Zfdd6Ozx8Gm7H1V0kHKMcXFl3MyKEGgh9KsQPDzARuB';
const data = await admin.firestore().doc('messages/$documentId').get();

const message = {
  notification : {
    title: data['hello'] ?? 'Khuuuuuuu',
    body: '2:45'
  },
  token: registrationToken
};
// Send a message to the device corresponding to the provided
// registration token.

admin.messaging().send(message)
  .then((response) => {
    // Response is a message ID string.
    console.log('Successfully sent message:', response);
  })
  .catch((error) => {
    console.log('Error sending message:', error);
  });
    //   return snap.ref.update({uppercase}, {merge: true});
    });


// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
