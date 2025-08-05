import { useState, useEffect, useRef } from 'react';
import Message from './Message';
import InputBox from './InputBox';
import { useSession } from '../hooks/useSession.ts';
import { useCable } from "../hooks/useCable.ts";

type MessageType = {
  id: string;
  sender_id: string;
  receiver_id: string;
  chat_id: string;
  content: string;
};

type UserType = {
  user_id: string;
  name: string;
};

const CHAT_ID = '17e87dd4-24ca-4eed-b8a1-ae48d4338de3';

export default function Chat() {
  const [messages, setMessages] = useState<MessageType[]>([]);
  const [loading, setLoading] = useState(true);
  const [onlineUsers, setOnlineUsers] = useState<UserType[]>([]);
  const chatRef = useRef<HTMLDivElement | null>(null);
  const session = useSession();

  useCable(CHAT_ID, (msg: MessageType) => {
    setMessages((prev) => {
      if (prev.some(m => m.id === msg.id)) return prev;
      return [...prev, msg];
    });
  });

  
  useEffect(() => {
    if (!session) return;

    const fetchMessages = async () => {
      try {
        const res = await fetch(`/api/v1/messages/${CHAT_ID}`);
        if (!res.ok) throw new Error('Failed to load messages');
        const data: MessageType[] = await res.json();
        setMessages(data);
      } catch (err) {
        console.error(err);
      } finally {
        setLoading(false);
      }
    };

    fetchMessages();
  }, [session]);

  useEffect(() => {
    if (!session) return;

    const fetchOnlineUsers = async () => {
      try {
        const res = await fetch('/api/v1/users/online_users');
        if (!res.ok) throw new Error('Failed to load online users');
        const users: UserType[] = await res.json();
        const others = users.filter(u => u.user_id !== session.user_id);
        setOnlineUsers(others);
      } catch (err) {
        console.error(err);
      }
    };

    fetchOnlineUsers();
    const interval = setInterval(fetchOnlineUsers, 5000);
    return () => clearInterval(interval);
  }, [session]);

  useEffect(() => {
    if (chatRef.current) {
      chatRef.current.scrollTop = chatRef.current.scrollHeight;
    }
  }, [messages]);

  const addMessage = async (text: string) => {
    if (!session) return;

    const newMsg: MessageType = {
      id: crypto.randomUUID(),
      sender_id: session.user_id,
      receiver_id: session.user_id,
      content: text,
      chat_id: CHAT_ID,
    };

    try {
      const res = await fetch('/api/v1/messages', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(newMsg),
      });
      if (!res.ok) throw new Error('Error sending the message');
      await res.json();
      setMessages(prev => [...prev, newMsg]);
    } catch (err) {
      console.error(err);
    }
  };

  return (
    <div className="flex flex-col h-screen max-h-screen bg-gradient-to-br from-indigo-50 to-purple-100">
      <header className="bg-gradient-to-r from-indigo-600 to-purple-600 text-white p-5 flex items-center justify-between shadow-lg">
        <h1 className="text-xl font-bold tracking-wide">Chat</h1>
        <div className="text-sm opacity-75">
          Logged in as <span className="font-semibold">{session?.name || '...'}</span>
        </div>
      </header>

      <div className="bg-white p-3 border-b border-gray-300">
        <h2 className="text-gray-700 font-semibold mb-2">Online Users</h2>
        {onlineUsers.length > 0 ? (
          <ul className="flex gap-3">
            {onlineUsers.map(user => (
              <li
                key={user.user_id}
                className={`cursor-pointer px-3 py-1 rounded-full text-sm ${
                  session?.user_id === user.user_id
                    ? 'bg-indigo-600 text-white'
                    : 'bg-gray-200 text-gray-700'
                }`}
              >
                {user.name}
              </li>
            ))}
          </ul>
        ) : (
          <p className="text-gray-500 text-sm">No other users online</p>
        )}
      </div>

      <main
        ref={chatRef}
        className="flex-1 overflow-y-auto p-6 space-y-4 scrollbar-thin scrollbar-thumb-indigo-400 scrollbar-track-indigo-100"
      >
        {loading ? (
          <div className="text-center text-gray-500">Loading messages...</div>
        ) : (
          messages.map(msg => (
            <Message
              key={msg.id}
              isOwn={msg.sender_id === session?.user_id}
              text={msg.content}
            />
          ))
        )}
      </main>

      <footer className="p-4 bg-white border-t border-gray-300 shadow-inner">
        {session?.user_id ? (
          <InputBox onSend={addMessage} />
        ) : (
          <div className="text-center text-gray-500">
            Waiting for another user to connect...
          </div>
        )}
      </footer>
    </div>
  );
}
