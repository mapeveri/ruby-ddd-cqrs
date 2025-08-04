import { useEffect, useState } from 'react';

interface SessionData {
  user_id: string;
  name: string;
}

export function useSession() {
  const [session, setSession] = useState<SessionData | null>(null);
  const userId = getOrCreateUserId();
  
  useEffect(() => {
    fetch('/api/v1/users/join', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ user_id: userId }),
    })
      .then(response => {
        if (!response.ok) {
          throw new Error(`Error: ${response.status}`);
        }
        return response.json();
      })
      .then((data: SessionData) => {
        localStorage.setItem('user_id', data.user_id);
        localStorage.setItem('name', data.name);
        setSession(data);
      })
      .catch(err => {
        console.error('Error joining chat:', err);
      });
  }, []);

  return session;
}

function getOrCreateUserId(): string {
  let userId = localStorage.getItem('user_id');
  if (!userId) {
    userId = crypto.randomUUID();
    localStorage.setItem('user_id', userId);
  }
  return userId;
}