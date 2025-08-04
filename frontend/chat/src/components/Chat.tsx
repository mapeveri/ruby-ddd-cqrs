import { useState, useEffect, useRef } from 'react';
import Message from './Message';
import InputBox from './InputBox';

type MessageType = {
  id: string;
  sender_id: string;
  receiver_id: string;
  chat_id: string;
  content: string;
};

const CHAT_ID = '17e87dd4-24ca-4eed-b8a1-ae48d4338de3';
const USER_ID = 'ef17ef70-5f1d-4ae4-af0d-e82544dbada9';
const RECEIVER_ID = '9bdf3547-25e3-45ff-a27a-4bcc1a6c71ed';

export default function Chat() {
  const [messages, setMessages] = useState<MessageType[]>([]);
  const chatRef = useRef<HTMLDivElement | null>(null);

  useEffect(() => {
    fetch(`/api/v1/messages/${CHAT_ID}`)
      .then(res => res.json())
      .then((data: MessageType[]) => {
        setMessages(data);
      })
      .catch(console.error);
  }, []);

  const addMessage = (text: string): void => {
    const newMsg = {
      id: crypto.randomUUID(),
      sender_id: USER_ID,
      receiver_id: RECEIVER_ID,
      content: text,
      chat_id: CHAT_ID,
    };

    fetch('/api/v1/messages', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(newMsg),
    })
      .then(res => {
        if (!res.ok) throw new Error('Error sending the message');
        return res.json();
      })
      .then(() => {
        setMessages(prev => [...prev, newMsg]);
      })
      .catch(console.error);
  };

  useEffect(() => {
    if (chatRef.current) {
      chatRef.current.scrollTop = chatRef.current.scrollHeight;
    }
  }, [messages]);

  return (
    <div className="flex flex-col h-screen max-h-screen bg-gradient-to-br from-indigo-50 to-purple-100">
      <header className="bg-gradient-to-r from-indigo-600 to-purple-600 text-white p-5 flex items-center justify-between shadow-lg">
        <h1 className="text-xl font-bold tracking-wide">Chat</h1>
        <div className="text-sm opacity-75">You are logged in as <span className="font-semibold">User</span></div>
      </header>

      <main
        ref={chatRef}
        className="flex-1 overflow-y-auto p-6 space-y-4 scrollbar-thin scrollbar-thumb-indigo-400 scrollbar-track-indigo-100"
      >
        {messages.map(msg => (
          <Message
            key={msg.id}
            isOwn={msg.sender_id === USER_ID}
            text={msg.content}
          />
        ))}
      </main>

      <footer className="p-4 bg-white border-t border-gray-300 shadow-inner">
        <InputBox onSend={addMessage} />
      </footer>
    </div>
  );
}
