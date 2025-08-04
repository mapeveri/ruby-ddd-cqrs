import { useState } from 'react';

type Props = {
  onSend: (text: string) => void;
};

export default function InputBox({ onSend }: Props) {
  const [text, setText] = useState('');

  const handleSend = () => {
    if (text.trim() === '') return;
    onSend(text);
    setText('');
  };

  return (
    <div className="flex items-center space-x-3">
      <input
        className="flex-1 border border-gray-300 rounded-full px-5 py-3 text-black placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition"
        type="text"
        value={text}
        onChange={e => setText(e.target.value)}
        placeholder="Write a message..."
        onKeyDown={e => e.key === 'Enter' && handleSend()}
      />
      <button
        onClick={handleSend}
        className="bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-full px-6 py-3 transition"
      >
        Send
      </button>
    </div>
  );
}
