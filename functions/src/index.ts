/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
import * as admin from 'firebase-admin';

// Initialize Firebase Admin SDK
const serviceAccount = require('./path/to/serviceAccountKey.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://your-project-id.firebaseio.com', // Replace with your Firebase project URL
});

// Reference to Firestore collection
const scheduleCollection = admin.firestore().collection('schedule');
const interScheduleCollection = admin.firestore().collection('interSchedule');

// Function to update interSchedule collection
async function updateInterSchedule() {
  try {
    // Retrieve documents from schedule collection
    const snapshot = await scheduleCollection.get();

    // Begin batch write
    const batch = admin.firestore().batch();

    // Update interSchedule documents based on changes in schedule collection
    snapshot.forEach((doc) => {
      const scheduleData = doc.data();
      // Write your update logic here based on scheduleData
      const interScheduleRef = interScheduleCollection.doc(doc.id);
      batch.set(interScheduleRef, {scheduleData}); // Replace {...} with your updated data
    });

    // Commit the batch write
    await batch.commit();

    console.log('InterSchedule collection updated successfully.');
  } catch (error) {
    console.error('Error updating InterSchedule collection:', error);
  }
}

// Example: Listening for changes in the schedule collection
function listenForScheduleChanges() {
  // Example implementation to listen for changes in the schedule collection
  console.log('Listening for changes in the schedule collection...');

  // Listen for document changes in the schedule collection
  scheduleCollection.onSnapshot(async (snapshot) => {
    if (!snapshot.empty) {
      console.log('Schedule collection updated. Updating InterSchedule collection...');
      await updateInterSchedule();
    }
  }, (error) => {
    console.error('Error listening for schedule collection changes:', error);
  });
}

// Start listening for changes in the schedule collection
listenForScheduleChanges();


// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
