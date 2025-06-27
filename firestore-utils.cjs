const db = require('./firebase.cjs');
const { Timestamp } = require('firebase-admin/firestore');

/**
 * Update an analysis document for a given user/project/createdAt
 */
async function updateAnalysisResult(userId, projectId, createdAt, resultData) {
  const analysisCollection = db
    .collection('users')
    .doc(userId)
    .collection('projects')
    .doc(projectId)
    .collection('analysis');

  const createdAtDate = new Date(createdAt); // createdAt is ISO string
  const lowerBound = Timestamp.fromDate(new Date(createdAtDate.getTime() - 10000)); // 1 second before
  const upperBound = Timestamp.fromDate(new Date(createdAtDate.getTime() + 10000)); // 1 second after

  const snapshot = await analysisCollection
    .where('createdAt', '>=', lowerBound)
    .where('createdAt', '<=', upperBound)
    .limit(1)
    .get();

  if (snapshot.empty) {
    console.warn(`No analysis found for createdAt = ${createdAtDate}`);
    return;
  }

  const docRef = snapshot.docs[0].ref;

  await docRef.update({
    result: resultData,
    updatedAt: new Date().toISOString(),
  });

  console.log(`✅ Updated analysis for user ${userId}, project ${projectId}`);
}

module.exports = updateAnalysisResult
