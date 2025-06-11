import type { User } from "firebase/auth";
import {
  get,
  push,
  update,
  remove,
  Database,
  ref as dbRef,
  type DatabaseReference
} from "firebase/database";
import { onMounted, ref, watchEffect } from "vue";
import { useFirebaseDatabase } from "~/services/firebase.service";

export function useNotifications() {
  let uid = "";
  const db = ref<Database | null>(null);
  const userRef = ref<DatabaseReference | null>(null);
  const initialized = ref(false);

  function initialize(userId: string) {
    if (import.meta.client) {
        db.value = useFirebaseDatabase();

        if (db.value && !initialized.value) {
            uid = userId;
            console.log(db.value);
            // userRef.value = dbRef(db.value);
            initialized.value = true;
        }
    }
  }

  function addNotification(message: string) {
    if (!userRef.value) {
      console.warn("Notification skipped: userRef not ready");
      return Promise.resolve(); // Or reject based on use case
    }

    return push(userRef.value, {
      message,
      read: false,
      timestamp: Date.now()
    });
  }

  function fetchNotifications(callback: (notifications: any[]) => void) {
    if (!userRef.value) {
      console.warn("Cannot fetch notifications: userRef not ready");
      callback([]);
      return;
    }

    get(userRef.value)
      .then((snapshot) => {
        const data = snapshot.val();
        console.log(userRef.value);
        console.log(data);
        const notifications = data
          ? Object.entries(data).map(([id, value]: any) => ({ id, ...value }))
          : [];
        callback(notifications);
      })
      .catch((error) => {
        console.error("Error fetching notifications:", error);
        callback([]);
      });
  }

  function markAsRead(notificationId: string) {
    if (!uid || !db.value) throw new Error("Missing user/db");
    const notifRef = dbRef(db.value, `notifications/${uid}/${notificationId}`);
    return update(notifRef, { read: true, readAt: Date.now() });
  }

  function deleteNotification(notificationId: string) {
    if (!uid || !db.value) throw new Error("Missing user/db");
    const notifRef = dbRef(db.value, `notifications/${uid}/${notificationId}`);
    return remove(notifRef);
  }

  return {
    markAsRead,
    initialize,
    addNotification,
    fetchNotifications,
    deleteNotification
  };
}
