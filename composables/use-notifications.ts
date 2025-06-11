import { ref } from "vue";

export function useNotifications() {
  const uid = ref("");
  const initialized = ref(false);
  let FIREBASE_DATABASE_URL = "";
  

  function initialize(userId: string) {
    if (import.meta.client && !initialized.value) {
      uid.value = userId;
      initialized.value = true;
      FIREBASE_DATABASE_URL = useRuntimeConfig().public.firebaseDatabaseUrl as string;
    }
  }

  async function addNotification(message: string) {
    if (!uid.value) return;

    const payload = {
      message,
      read: false,
      timestamp: Date.now(),
    };

    try {
      const res = await fetch(`${FIREBASE_DATABASE_URL}/notifications/${uid.value}.json`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });

      if (!res.ok) throw new Error(await res.text());

      return await res.json(); // returns { name: "firebase-generated-id" }
    } catch (e) {
      console.error("Failed to add notification:", e);
    }
  }

  async function fetchNotifications(callback: (notifications: any[]) => void) {
    if (!uid.value) return callback([]);

    try {
      const res = await fetch(`${FIREBASE_DATABASE_URL}/notifications/${uid.value}.json`);
      if (!res.ok) throw new Error(await res.text());

      const data = await res.json();
      const notifications = data
        ? Object.entries(data).map(([id, value]: any) => ({ id, ...value }))
        : [];
      callback(notifications);
    } catch (e) {
      console.error("Failed to fetch notifications:", e);
      callback([]);
    }
  }

  async function markAsRead(notificationId: string) {
    if (!uid.value) throw new Error("Missing user ID");

    try {
      await fetch(`${FIREBASE_DATABASE_URL}/notifications/${uid.value}/${notificationId}.json`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ read: true, readAt: Date.now() }),
      });
    } catch (e) {
      console.error("Failed to mark notification as read:", e);
    }
  }

  async function deleteNotification(notificationId: string) {
    if (!uid.value) throw new Error("Missing user ID");

    try {
      await fetch(`${FIREBASE_DATABASE_URL}/notifications/${uid.value}/${notificationId}.json`, {
        method: "DELETE",
      });
    } catch (e) {
      console.error("Failed to delete notification:", e);
    }
  }

  return {
    initialize,
    addNotification,
    fetchNotifications,
    markAsRead,
    deleteNotification,
  };
}
