async function sendNotification({
  userId,
  title,
  message,
  type = 'info',
  FIREBASE_DB_URL
}) {
  const timestamp = Date.now();
  const payload = {
    title,
    message,
    type,
    read: false,
    timestamp,
  };

  try {
    const res = await fetch(`${FIREBASE_DB_URL}/notifications/${userId}.json`, {
      method: 'POST', // creates a unique key under this user
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    });

    if (!res.ok) throw new Error(await res.text());

    const data = await res.json();

    return {
      status: 'success',
      notified: true,
      notificationId: data.name, // Firebase returns the new key as "name"
      userId,
    };
  } catch (error) {
    console.error("Failed to send notification:", error.message);
    return {
      status: 'error',
      notified: false,
      error: error.message,
    };
  }
}

module.exports = sendNotification;
